import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_batch.freezed.dart';
part 'stock_batch.g.dart';

/// {@template stock_batch}
/// Represents a batch of stock items with quantity and optional expiration date
/// {@endtemplate}
@freezed
abstract class StockBatch with _$StockBatch {
  /// {@macro stock_batch}
  factory StockBatch({
    required String id,
    required String itemId,
    required double quantity,
    required double baseQuantity,
    DateTime? expirationDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _StockBatch;

  /// Converts a JSON map to a [StockBatch] instance.
  factory StockBatch.fromJson(Map<String, dynamic> json) =>
      _$StockBatchFromJson(json);
}
