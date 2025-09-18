import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';
part 'order_list_bloc.freezed.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  OrderListBloc({
    required OrderRepository orderRepository,
    required MenuRepository menuRepository,
    required PackageRepository packageRepository,
  }) : _orderRepo = orderRepository,
       _menuRepo = menuRepository,
       _packageRepo = packageRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final OrderRepository _orderRepo;
  final MenuRepository _menuRepo;
  final PackageRepository _packageRepo;

  Future<void> _onStarted(
    _Started event,
    Emitter<OrderListState> emit,
  ) async {
    emit(state.copyWith(status: OrderListStatus.loading));

    try {
      final orders = await _orderRepo.fetchOrdersByIds(event.orderIds);
      final packageOrderMap = <String, Order>{
        for (final order in orders)
          if (order.type == OrderType.package) order.cartId: order,
      };
      final menuOrderMap = <String, Order>{
        for (final order in orders)
          if (order.type == OrderType.menu) order.cartId: order,
      };

      final packages = await _packageRepo.fetchPackages(
        ids: packageOrderMap.keys.toList(),
      );
      final menuItems = await _menuRepo.fetchItems(
        menuIds: menuOrderMap.keys.toList(),
      );

      final packageCart = packages.map(
        (package) {
          final order = packageOrderMap[package.id]!;
          return CartItem<FoodPackage>(
            id: order.id,
            item: package,
            quantity: order.quantity,
          );
        },
      ).toList();
      final menuItemCart = menuItems.map(
        (menuItem) {
          final order = menuOrderMap[menuItem.id]!;
          return CartItem<MenuItem>(
            id: order.id,
            item: menuItem,
            quantity: order.quantity,
          );
        },
      ).toList();

      emit(
        state.copyWith(
          status: OrderListStatus.success,
          orderIds: event.orderIds,
          packages: packageCart,
          menuItems: menuItemCart,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: OrderListStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: OrderListStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
