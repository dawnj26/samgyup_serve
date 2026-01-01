import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:order_repository/order_repository.dart';

part 'order_status_event.dart';
part 'order_status_state.dart';
part 'order_status_bloc.freezed.dart';

class OrderStatusBloc extends Bloc<OrderStatusEvent, OrderStatusState> {
  OrderStatusBloc({
    required OrderRepository orderRepository,
    required OrderStatus initialStatus,
    required String orderId,
  }) : _orderRepository = orderRepository,
       _orderId = orderId,
       super(
         _Initial(
           status: initialStatus,
         ),
       ) {
    on<_Started>(_onStarted);
    on<_Changed>((event, emit) {
      emit(state.copyWith(status: event.status));
    });
  }

  final OrderRepository _orderRepository;
  final String _orderId;
  RealtimeSubscription? _subscription;

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<OrderStatusState> emit,
  ) async {
    await _subscribe();
  }

  Future<void> _subscribe() async {
    await _subscription?.close();

    _subscription = _orderRepository.orderState(_orderId);
    _subscription?.stream.listen((data) {
      final order = Order.fromJson(data.payload);
      add(OrderStatusEvent.changed(status: order.status));
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.close();
    return super.close();
  }
}
