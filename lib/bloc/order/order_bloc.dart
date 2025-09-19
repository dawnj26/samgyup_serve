import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:reservation_repository/reservation_repository.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:table_repository/table_repository.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({
    required OrderRepository orderRepository,
    required BillingRepository billingRepository,
    required ReservationRepository reservationRepository,
    required MenuRepository menuRepository,
    required TableRepository tableRepository,
  }) : _orderRepository = orderRepository,
       _tableRepository = tableRepository,
       _menuRepository = menuRepository,
       _billingRepository = billingRepository,
       _reservationRepository = reservationRepository,
       super(
         const _Initial(),
       ) {
    on<_Started>(_onStarted);
  }

  final OrderRepository _orderRepository;
  final BillingRepository _billingRepository;
  final ReservationRepository _reservationRepository;
  final MenuRepository _menuRepository;
  final TableRepository _tableRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderStatus.loading));
    try {
      final orders = await _orderRepository.createOrders(
        menuItems: event.menuItems,
        packageItems: event.packages,
      );

      for (final menu in event.menuItems) {
        if (menu.item.stock == 0) continue;

        await _menuRepository.decrementStock(
          menuId: menu.item.id,
          quantity: menu.quantity,
        );
      }
      for (final cart in event.packages) {
        for (final menu in cart.item.menuIds) {
          try {
            await _menuRepository.decrementStock(
              menuId: menu,
              quantity: 1,
            );
          } on ResponseException {
            continue;
          }
        }
      }

      final invoice = await _billingRepository.createInvoice(
        orders: orders,
        code: 'SAMG-${formatDate(DateTime.now())}',
      );

      final reservation = await _reservationRepository.createReservation(
        tableId: event.tableId,
        invoiceId: invoice.id,
        startTime: DateTime.now(),
      );
      await _tableRepository.updateTableStatus(
        tableId: event.tableId,
        status: TableStatus.occupied,
      );

      emit(
        state.copyWith(
          status: OrderStatus.success,
          reservationId: reservation.id,
          orders: orders,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(status: OrderStatus.failure, errorMessage: e.message),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(status: OrderStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
