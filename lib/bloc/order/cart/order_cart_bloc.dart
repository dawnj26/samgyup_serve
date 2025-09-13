import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';

part 'order_cart_event.dart';
part 'order_cart_state.dart';
part 'order_cart_bloc.freezed.dart';

class OrderCartBloc extends Bloc<OrderCartEvent, OrderCartState> {
  OrderCartBloc() : super(const _Initial()) {
    on<_AddMenuItem>(_onAddMenuItem);
    on<_RemoveMenuItem>(_onRemoveMenuItem);
    on<_AddPackage>(_onAddPackage);
    on<_RemovePackage>(_onRemovePackage);
    on<_ClearCart>(_onClearCart);
    on<_UpdateMenuItemQuantity>(_onUpdateMenuItemQuantity);
    on<_UpdatePackageQuantity>(_onUpdatePackageQuantity);
  }

  void _onAddMenuItem(_AddMenuItem event, Emitter<OrderCartState> emit) {
    final menuItems = [...state.menuItems];
    final index = menuItems.indexWhere(
      (item) => item.item.id == event.cartItem.item.id,
    );

    if (index != -1) {
      menuItems[index] = event.cartItem;
    } else {
      menuItems.add(event.cartItem);
    }

    emit(state.copyWith(menuItems: menuItems));
  }

  void _onRemoveMenuItem(_RemoveMenuItem event, Emitter<OrderCartState> emit) {
    emit(
      state.copyWith(
        menuItems: state.menuItems
            .where((item) => item.item.id != event.cartItem.item.id)
            .toList(),
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

    emit(state.copyWith(packages: packages));
  }

  void _onRemovePackage(_RemovePackage event, Emitter<OrderCartState> emit) {
    emit(
      state.copyWith(
        packages: state.packages
            .where((item) => item.item.id != event.cartItem.item.id)
            .toList(),
      ),
    );
  }

  void _onClearCart(_ClearCart event, Emitter<OrderCartState> emit) {
    emit(
      state.copyWith(
        menuItems: [],
        packages: [],
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

    if (event.quantity <= 0) {
      menuItems.removeAt(event.index);
    }
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

    if (event.quantity <= 0) {
      packages.removeAt(event.index);
    }
  }
}
