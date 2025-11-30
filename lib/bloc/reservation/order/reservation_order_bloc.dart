import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/order_repository.dart';

part 'reservation_order_event.dart';
part 'reservation_order_state.dart';
part 'reservation_order_bloc.freezed.dart';

class ReservationOrderBloc
    extends Bloc<ReservationOrderEvent, ReservationOrderState> {
  ReservationOrderBloc({
    required BillingRepository billingRepository,
    required InventoryRepository inventoryRepository,
    required OrderRepository orderRepository,
  }) : _billingRepository = billingRepository,
       _orderRepository = orderRepository,
       _inventoryRepository = inventoryRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final OrderRepository _orderRepository;
  final BillingRepository _billingRepository;
  final InventoryRepository _inventoryRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<ReservationOrderState> emit,
  ) async {
    if (event.items.isEmpty) {
      return emit(
        state.copyWith(
          status: ReservationOrderStatus.pure,
        ),
      );
    }

    try {
      emit(state.copyWith(status: ReservationOrderStatus.loading));
      final orders = await _orderRepository.createOrders(
        inventoryItems: event.items,
        packageItems: [],
      );

      for (final cart in event.items) {
        if (!cart.item.isAvailable) continue;
        final decrementCount = cart.quantity * cart.item.perHead;

        await _inventoryRepository.decrementStock(
          itemId: cart.item.id,
          quantity: decrementCount,
        );
      }

      await _billingRepository.addOrders(
        invoice: event.invoice,
        orders: orders,
      );

      emit(
        state.copyWith(status: ReservationOrderStatus.success, orders: orders),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: ReservationOrderStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ReservationOrderStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
