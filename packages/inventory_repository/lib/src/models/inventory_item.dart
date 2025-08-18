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
    DateTime? updatedAt,
    DateTime? expirationDate,
    double? price,
    String? description,
  }) = _InventoryItem;

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

  /// Converts a JSON map to an [InventoryItem] instance.
  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
}
