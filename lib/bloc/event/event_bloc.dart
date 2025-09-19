import 'dart:convert';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:event_repository/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';

part 'event_event.dart';
part 'event_state.dart';
part 'event_bloc.freezed.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc({
    required EventRepository eventRepository,
  }) : _eventRepository = eventRepository,
       super(const _Initial()) {
    on<_OrderCreated>(_onOrderCreated);
    on<_ItemsAdded>(_onItemsAdded);
    on<_RefillRequested>(_onRefillRequested);
    on<_PaymentRequested>(_onPaymentRequested);
  }

  final EventRepository _eventRepository;

  Future<void> _onOrderCreated(
    _OrderCreated event,
    Emitter<EventState> emit,
  ) async {
    emit(state.copyWith(status: EventStatus.loading));
    try {
      final payload = {
        'message': 'Table ${event.tableNumber} has placed a new order.',
        'orders': event.orders.map((e) => e.toJson()).toList(),
      };

      final newEvent = Event(
        reservationId: event.reservationId,
        tableNumber: event.tableNumber,
        payload: jsonEncode(payload),
        type: EventType.orderCreated,
      );
      await _eventRepository.createEvent(newEvent);
      emit(state.copyWith(status: EventStatus.success));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(status: EventStatus.failure, errorMessage: e.message),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(status: EventStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onItemsAdded(
    _ItemsAdded event,
    Emitter<EventState> emit,
  ) async {
    emit(state.copyWith(status: EventStatus.loading));
    try {
      final payload = {
        'message': 'Table ${event.tableNumber} has added items to their order.',
        'orders': event.orders.map((e) => e.toJson()).toList(),
      };

      final newEvent = Event(
        reservationId: event.reservationId,
        tableNumber: event.tableNumber,
        payload: jsonEncode(payload),
        type: EventType.itemsAdded,
      );
      await _eventRepository.createEvent(newEvent);
      emit(state.copyWith(status: EventStatus.success));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(status: EventStatus.failure, errorMessage: e.message),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(status: EventStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onRefillRequested(
    _RefillRequested event,
    Emitter<EventState> emit,
  ) async {
    emit(state.copyWith(status: EventStatus.loading));
    try {
      final payload = {
        'message': 'Table ${event.tableNumber} has requested a refill.',
        'items': event.items
            .map(
              (e) => {
                'menuId': e.item.id,
                'quantity': e.quantity,
              },
            )
            .toList(),
      };

      final newEvent = Event(
        reservationId: event.reservationId,
        tableNumber: event.tableNumber,
        payload: jsonEncode(payload),
        type: EventType.refillRequested,
      );
      await _eventRepository.createEvent(newEvent);
      emit(state.copyWith(status: EventStatus.success));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(status: EventStatus.failure, errorMessage: e.message),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(status: EventStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onPaymentRequested(
    _PaymentRequested event,
    Emitter<EventState> emit,
  ) async {
    emit(state.copyWith(status: EventStatus.loading));
    try {
      final newEvent = Event(
        reservationId: event.reservationId,
        tableNumber: event.tableNumber,
        payload: jsonEncode(event.payload),
        type: EventType.paymentRequested,
      );
      await _eventRepository.createEvent(newEvent);
      emit(state.copyWith(status: EventStatus.success));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(status: EventStatus.failure, errorMessage: e.message),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(status: EventStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
