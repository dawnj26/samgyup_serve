import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';
part 'order_list_bloc.freezed.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  OrderListBloc({
    required OrderRepository orderRepository,
    required InventoryRepository inventoryRepository,
    required PackageRepository packageRepository,
  }) : _orderRepo = orderRepository,
       _inventoryRepo = inventoryRepository,
       _packageRepo = packageRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final OrderRepository _orderRepo;
  final InventoryRepository _inventoryRepo;
  final PackageRepository _packageRepo;

  Future<void> _onStarted(
    _Started event,
    Emitter<OrderListState> emit,
  ) async {
    emit(state.copyWith(status: OrderListStatus.loading));

    try {
      final orders = await _orderRepo.fetchOrdersByIds(event.orderIds);

      final menuOrders = orders
          .where((order) => order.type == OrderType.menu)
          .toList();
      final packageOrders = orders
          .where((order) => order.type == OrderType.package)
          .toList();

      final packages = await _packageRepo.fetchPackages(
        ids: packageOrders.map((order) => order.cartId).toSet().toList(),
        includeDeleted: true,
      );
      final menuItems = await _inventoryRepo.fetchItems(
        itemIds: menuOrders.map((order) => order.cartId).toSet().toList(),
        includeDeleted: true,
      );

      final packageCart = packageOrders.map(
        (order) {
          final package = packages.firstWhere(
            (pkg) => pkg.id == order.cartId,
          );
          return CartItem<FoodPackageItem>(
            id: order.id,
            item: package,
            quantity: order.quantity,
          );
        },
      ).toList();

      final menuItemCart = menuOrders.map(
        (order) {
          final menuItem = menuItems.firstWhere(
            (item) => item.id == order.cartId,
          );
          return CartItem<InventoryItem>(
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
