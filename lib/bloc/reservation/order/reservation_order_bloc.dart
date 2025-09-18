import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';

part 'reservation_order_event.dart';
part 'reservation_order_state.dart';
part 'reservation_order_bloc.freezed.dart';

class ReservationOrderBloc
    extends Bloc<ReservationOrderEvent, ReservationOrderState> {
  ReservationOrderBloc({
    required BillingRepository billingRepository,
    required Invoice invoice,
    required MenuRepository menuRepository,
    required OrderRepository orderRepository,
  }) : _billingRepository = billingRepository,
       _orderRepository = orderRepository,
       _menuRepository = menuRepository,
       _invoice = invoice,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final Invoice _invoice;
  final OrderRepository _orderRepository;
  final BillingRepository _billingRepository;
  final MenuRepository _menuRepository;

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
        menuItems: event.items,
        packageItems: [],
      );

      for (final order in orders) {
        await _menuRepository.decrementStock(
          menuId: order.cartId,
          quantity: order.quantity,
        );
      }

      await _billingRepository.addOrders(invoice: _invoice, orders: orders);

      emit(state.copyWith(status: ReservationOrderStatus.success));
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
