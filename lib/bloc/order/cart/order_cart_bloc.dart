import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';

part 'order_cart_event.dart';
part 'order_cart_state.dart';
part 'order_cart_bloc.freezed.dart';

class OrderCartBloc extends Bloc<OrderCartEvent, OrderCartState> {
  OrderCartBloc() : super(const _Initial()) {
    on<_AddInventoryItem>(_onAddMenuItem);
    on<_RemoveMenuItem>(_onRemoveMenuItem);
    on<_AddPackage>(_onAddPackage);
    on<_RemovePackage>(_onRemovePackage);
    on<_ClearCart>(_onClearCart);
    on<_UpdateMenuItemQuantity>(_onUpdateMenuItemQuantity);
    on<_UpdatePackageQuantity>(_onUpdatePackageQuantity);
  }

  void _onAddMenuItem(_AddInventoryItem event, Emitter<OrderCartState> emit) {
    final menuItems = [...state.menuItems];
    final index = menuItems.indexWhere(
      (item) => item.item.id == event.cartItem.item.id,
    );

    if (index != -1) {
      menuItems[index] = event.cartItem;
    } else {
      menuItems.add(event.cartItem);
    }

    emit(
      state.copyWith(
        menuItems: menuItems,
        totalPrice: _getTotalPrice(menuItems, state.packages),
      ),
    );
  }

  void _onRemoveMenuItem(_RemoveMenuItem event, Emitter<OrderCartState> emit) {
    final menuItems = state.menuItems
        .where((item) => item.item.id != event.cartItem.item.id)
        .toList();

    emit(
      state.copyWith(
        menuItems: menuItems,
        totalPrice: _getTotalPrice(menuItems, state.packages),
      ),
    );
  }

  void _onAddPackage(_AddPackage event, Emitter<OrderCartState> emit) {
    final packages = [...state.packages];
    final index = packages.indexWhere(
      (item) => item.item.id == event.cartItem.item.id,
    );

    if (index != -1) {
      packages[index] = event.cartItem;
    } else {
      packages.add(event.cartItem);
    }

    emit(
      state.copyWith(
        packages: packages,
        totalPrice: _getTotalPrice(state.menuItems, packages),
      ),
    );
  }

  void _onRemovePackage(_RemovePackage event, Emitter<OrderCartState> emit) {
    final packages = state.packages
        .where((item) => item.item.id != event.cartItem.item.id)
        .toList();

    emit(
      state.copyWith(
        packages: packages,
        totalPrice: _getTotalPrice(state.menuItems, packages),
      ),
    );
  }

  void _onClearCart(_ClearCart event, Emitter<OrderCartState> emit) {
    emit(
      state.copyWith(
        menuItems: [],
        packages: [],
        totalPrice: 0,
      ),
    );
  }

  void _onUpdateMenuItemQuantity(
    _UpdateMenuItemQuantity event,
    Emitter<OrderCartState> emit,
  ) {
    final menuItems = [...state.menuItems];
    final item = menuItems[event.index];

    menuItems[event.index] = item.copyWith(
      quantity: event.quantity,
    );

    emit(
      state.copyWith(
        menuItems: menuItems,
        totalPrice: _getTotalPrice(menuItems, state.packages),
      ),
    );
  }

  void _onUpdatePackageQuantity(
    _UpdatePackageQuantity event,
    Emitter<OrderCartState> emit,
  ) {
    final packages = [...state.packages];
    final item = packages[event.index];

    packages[event.index] = item.copyWith(
      quantity: event.quantity,
    );

    emit(
      state.copyWith(
        packages: packages,
        totalPrice: _getTotalPrice(state.menuItems, packages),
      ),
    );
  }

  double _getTotalPrice(
    List<CartItem<InventoryItem>> menuItems,
    List<CartItem<FoodPackage>> packages,
  ) {
    double total = 0;

    for (final cartItem in menuItems) {
      total += cartItem.item.price * cartItem.quantity;
    }

    for (final cartPackage in packages) {
      total += cartPackage.item.price * cartPackage.quantity;
    }

    return total;
  }
}
