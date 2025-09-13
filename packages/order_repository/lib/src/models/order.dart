import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// {@template order}
/// Creates a new Order.
///
/// - [menuIds]: list of menu item ids included in the order.
/// - [packageIds]: list of package ids included in the order.
/// - [totalPrice]: total price of the order.
/// - [id]: optional unique identifier for the order (defaults to empty string).
/// - [createdAt]: optional creation timestamp.
/// - [updatedAt]: optional last-update timestamp.
/// {@endtemplate}
@freezed
abstract class Order with _$Order {
  /// {@macro order}
  const factory Order({
    /// IDs of individual menu items included in this order.
    required List<String> menuIds,

    /// IDs of package items included in this order.
    required List<String> packageIds,

    /// Total price for the order.
    required double totalPrice,

    /// Unique identifier for the order.
    @Default('') String id,

    /// When the order was created.
    DateTime? createdAt,

    /// When the order was last updated.
    DateTime? updatedAt,
  }) = _Order;

  /// Deserialize an Order from JSON.
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
