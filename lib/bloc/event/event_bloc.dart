import 'dart:convert';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_event.dart';
part 'event_state.dart';
part 'event_bloc.freezed.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc({
    required EventRepository eventRepository,
  }) : _eventRepository = eventRepository,
       super(const _Initial()) {
    on<_Created>(_onCreated);
  }

  final EventRepository _eventRepository;

  Future<void> _onCreated(
    _Created event,
    Emitter<EventState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EventStatus.loading));
      await _eventRepository.createEvent(
        Event(
          reservationId: event.reservationId,
          tableNumber: event.tableNumber,
          payload: jsonEncode(event.payload),
        ),
      );
      emit(state.copyWith(status: EventStatus.success));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: EventStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: EventStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
