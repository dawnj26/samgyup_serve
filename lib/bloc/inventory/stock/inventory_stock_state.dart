part of 'inventory_stock_bloc.dart';

@freezed
abstract class InventoryStockState with _$InventoryStockState {
  const factory InventoryStockState.initial({
    required InventoryItem item,
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(Stock.pure()) Stock stock,
    String? supplierName,
    DateTime? expiration,
    String? errorMessage,
  }) = _Initial;
}
