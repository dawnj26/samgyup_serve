//
// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/src/enums/enums.dart';
import 'package:inventory_repository/src/models/stock_batch.dart';

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
    required double lowStockThreshold,
    required DateTime createdAt,
    required double price,
    @Default(InventoryItemStatus.inStock) InventoryItemStatus status,
    @JsonKey(includeToJson: false) @Default([]) List<StockBatch> stockBatches,
    String? imageId,
    DateTime? updatedAt,
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
    price: 0,
    category: InventoryCategory.unknown,
    lowStockThreshold: 0,
    createdAt: DateTime.now(),
  );

  const InventoryItem._();

  /// Calculates the total stock quantity across all batches.
  double get totalStock => stockBatches.fold(
    0,
    (sum, batch) => sum + batch.quantity,
  );

  /// Returns the available stock quantity, excluding expired batches.
  double getAvailableStock() {
    final now = DateTime.now();
    return stockBatches
        .where(
          (batch) =>
              batch.expirationDate == null ||
              batch.expirationDate!.isAfter(now),
        )
        .fold(0, (sum, batch) => sum + batch.quantity);
  }
}
