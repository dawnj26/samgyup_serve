import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_info.freezed.dart';
part 'inventory_info.g.dart';

/// {@template inventory_info}
/// A model representing inventory information.
///
/// Contains details about the total number of items and their statuses.
/// {@endtemplate}
@freezed
abstract class InventoryInfo with _$InventoryInfo {
  /// {@macro inventory_info}
  const factory InventoryInfo({
    required int totalItems,
    required int inStockItems,
    required int lowStockItems,
    required int outOfStockItems,
  }) = _InventoryInfo;

  /// Creates an empty [InventoryInfo] instance with default values.
  factory InventoryInfo.empty() => const InventoryInfo(
    totalItems: -1,
    inStockItems: -1,
    lowStockItems: -1,
    outOfStockItems: -1,
  );

  /// Creates an instance of [InventoryInfo] from a JSON map.
  factory InventoryInfo.fromJson(Map<String, dynamic> json) =>
      _$InventoryInfoFromJson(json);
}
