part of 'order_cart_bloc.dart';

@freezed
abstract class OrderCartEvent with _$OrderCartEvent {
  const factory OrderCartEvent.addMenuItem(CartItem<InventoryItem> cartItem) =
      _AddInventoryItem;
  const factory OrderCartEvent.removeMenuItem(
    CartItem<InventoryItem> cartItem,
  ) = _RemoveMenuItem;
  const factory OrderCartEvent.addPackage(CartItem<FoodPackageItem> cartItem) =
      _AddPackage;
  const factory OrderCartEvent.removePackage(
    CartItem<FoodPackageItem> cartItem,
  ) = _RemovePackage;
  const factory OrderCartEvent.clearCart() = _ClearCart;
  const factory OrderCartEvent.updateMenuItemQuantity(int index, int quantity) =
      _UpdateMenuItemQuantity;
  const factory OrderCartEvent.updatePackageQuantity(int index, int quantity) =
      _UpdatePackageQuantity;
}
