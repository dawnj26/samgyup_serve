import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:order_repository/src/enums/enums.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
/// {@template order}
/// A model representing an order created from a cart.
///
/// Contains the cart identifier, the kind of order, an optional persistent
/// identifier, and optional timestamps for creation and last update.
/// {@endtemplate}
abstract class Order with _$Order {
  ///{@macro order}
  const factory Order({
    /// The identifier of the cart that this order was created from.
    required String cartId,

    /// The kind of order (e.g. menu item or pre-defined package).
    required OrderType type,

    /// The count of items in this order.
    required int quantity,

    /// The total price of the order at the time of creation.
    required double totalPrice,

    /// The current status of the order.
    @Default(OrderStatus.pending) OrderStatus status,

    /// The unique identifier for this Order. Empty when not yet persisted.
    @Default('') String id,

    /// The time when the order was created (if known).
    DateTime? createdAt,

    /// The time when the order was last updated (if known).
    DateTime? updatedAt,
  }) = _Order;

  /// Deserialize an Order from JSON.
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
