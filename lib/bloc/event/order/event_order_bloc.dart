import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:order_repository/order_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'event_order_event.dart';
part 'event_order_state.dart';
part 'event_order_bloc.freezed.dart';

class EventOrderBloc extends Bloc<EventOrderEvent, EventOrderState> {
  EventOrderBloc({
    required OrderRepository orderRepository,
  }) : _orderRepository = orderRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_CompletedAll>(_onCompletedAll);
  }

  final OrderRepository _orderRepository;

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<EventOrderState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));

    try {
      await _orderRepository.updateStatus(
        orderId: event.orderId,
        newStatus: event.newStatus,
      );

      emit(state.copyWith(loadingStatus: LoadingStatus.success));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  FutureOr<void> _onCompletedAll(
    _CompletedAll event,
    Emitter<EventOrderState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.loading));

    try {
      final futures = event.orderIds.map(
        (orderId) => _orderRepository.updateStatus(
          orderId: orderId,
          newStatus: OrderStatus.completed,
        ),
      );

      await Future.wait(futures);

      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.success,
          isCompletedAll: true,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
