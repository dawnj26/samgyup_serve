import 'package:freezed_annotation/freezed_annotation.dart';

part 'cart_item.freezed.dart';

/// Represents an item in a shopping cart with a quantity.
///
/// This class is generic, allowing it to hold any type of item.
@freezed
abstract class CartItem<T> with _$CartItem<T> {
  /// Creates a new CartItem with the specified item and quantity.
  ///
  /// [item] The item being added to the cart.
  /// [quantity] The number of this item in the cart, defaults to 1.
  factory CartItem({
    required T item,
    @Default('') String id,
    @Default(1) int quantity,
  }) = _CartItem;
}
