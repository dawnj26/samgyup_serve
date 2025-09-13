part of 'order_cart_bloc.dart';

@freezed
abstract class OrderCartEvent with _$OrderCartEvent {
  const factory OrderCartEvent.addMenuItem(CartItem<MenuItem> cartItem) =
      _AddMenuItem;
  const factory OrderCartEvent.removeMenuItem(CartItem<MenuItem> cartItem) =
      _RemoveMenuItem;
  const factory OrderCartEvent.addPackage(CartItem<FoodPackage> cartItem) =
      _AddPackage;
  const factory OrderCartEvent.removePackage(CartItem<FoodPackage> cartItem) =
      _RemovePackage;
  const factory OrderCartEvent.clearCart() = _ClearCart;
  const factory OrderCartEvent.updateMenuItemQuantity(int index, int quantity) =
      _UpdateMenuItemQuantity;
  const factory OrderCartEvent.updatePackageQuantity(int index, int quantity) =
      _UpdatePackageQuantity;
}
