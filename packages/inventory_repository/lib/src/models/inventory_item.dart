import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/src/enums/enums.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

/// {@template inventory_item}
/// Represents an item in the inventory.
/// Contains details such as name, measurement unit, category, stock levels,
/// and other relevant information.
/// {@endtemplate}
@freezed
abstract class InventoryItem with _$InventoryItem {
  /// {@macro inventory_item}
  factory InventoryItem({
    required String id,
    required String name,
    required MeasurementUnit unit,
    required InventoryCategory category,
    required double stock,
    required double lowStockThreshold,
    required DateTime createdAt,
    @Default(InventoryItemStatus.inStock) InventoryItemStatus status,
    DateTime? updatedAt,
    DateTime? expirationDate,
    double? price,
    String? description,
  }) = _InventoryItem;

  /// Converts a JSON map to an [InventoryItem] instance.
  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);

  /// Creates an empty [InventoryItem] instance with default values.
  factory InventoryItem.empty() => InventoryItem(
    id: '',
    name: '',
    unit: MeasurementUnit.unknown,
    category: InventoryCategory.unknown,
    stock: 0,
    lowStockThreshold: 0,
    createdAt: DateTime.now(),
  );

  const InventoryItem._();

  /// Checks if the item is in stock
  bool get isLowStock => stock <= lowStockThreshold;

  /// Checks if the item is out of stock
  bool get isOutOfStock => stock <= 0;

  /// Checks if the item is expired
  bool get isExpired =>
      expirationDate != null && expirationDate!.isBefore(DateTime.now());
}
