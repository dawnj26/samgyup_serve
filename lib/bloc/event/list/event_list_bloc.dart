import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'event_list_event.dart';
part 'event_list_state.dart';
part 'event_list_bloc.freezed.dart';

class EventListBloc extends Bloc<EventListEvent, EventListState> {
  EventListBloc({
    required EventRepository eventRepository,
    bool listen = true,
  }) : _repo = eventRepository,
       _audioPlayer = AudioPlayer(),
       _listen = listen,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_Refreshed>(_onRefreshed);
    on<_FilterChanged>(_onFilterChanged);
    on<_Created>((event, emit) async {
      if (event.event.status != EventStatus.pending) return;

      final events = [...state.events, event.event];
      emit(state.copyWith(events: events, latestEvent: event.event));

      unawaited(HapticFeedback.vibrate());
      await _playNotificationSound();
    });
    on<_Updated>((event, emit) {
      if (event.event.status != EventStatus.pending) {
        final events = state.events
            .where((e) => e.id != event.event.id)
            .toList();
        emit(state.copyWith(events: events));
        return;
      }

      final events = state.events.map((e) {
        return e.id == event.event.id ? event.event : e;
      }).toList();
      emit(state.copyWith(events: events, latestEvent: event.event));
    });
    on<_Deleted>((event, emit) {
      final events = state.events.where((e) => e.id != event.event.id).toList();
      emit(state.copyWith(events: events));
    });
  }

  final EventRepository _repo;
  final AudioPlayer _audioPlayer;
  RealtimeSubscription? _subscription;
  final bool _listen;

  Future<void> _onFilterChanged(
    _FilterChanged event,
    Emitter<EventListState> emit,
  ) async {
    emit(
      state.copyWith(
        status: EventListStatus.loading,
        filter: event.filter,
      ),
    );
    try {
      final events = await _repo.getEvents(statuses: [event.filter]);
      emit(
        state.copyWith(
          status: EventListStatus.success,
          events: events,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: EventListStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: EventListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<EventListState> emit,
  ) async {
    emit(state.copyWith(status: EventListStatus.loading));
    try {
      await _audioPlayer.setVolume(1);
      await _subscribe();

      final events = await _repo.getEvents(statuses: [state.filter]);
      emit(
        state.copyWith(
          status: EventListStatus.success,
          events: events,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: EventListStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: EventListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshed(
    _Refreshed event,
    Emitter<EventListState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EventListStatus.loading));

      final events = await _repo.getEvents(statuses: [state.filter]);
      emit(
        state.copyWith(
          status: EventListStatus.success,
          events: events,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: EventListStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: EventListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _subscribe() async {
    await _subscription?.close();

    if (!_listen) return;

    _subscription = _repo.eventState;
    _subscription?.stream.listen((response) {
      final event = Event.fromJson(response.payload);

      if (response.events.contains('databases.*.tables.*.rows.*.create')) {
        add(EventListEvent.created(event: event));
      } else if (response.events.contains(
        'databases.*.tables.*.rows.*.update',
      )) {
        add(EventListEvent.updated(event: event));
      } else if (response.events.contains(
        'databases.*.tables.*.rows.*.delete',
      )) {
        add(EventListEvent.deleted(event: event));
      }
    });
  }

  Future<void> _playNotificationSound() async {
    await _audioPlayer.stop();

    await _audioPlayer.setAsset('assets/sounds/notification.mp3');
    await _audioPlayer.play();
  }

  @override
  Future<void> close() async {
    await _subscription?.close();
    await _audioPlayer.dispose();
    return super.close();
  }
}
