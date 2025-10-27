part of 'inventory_stock_bloc.dart';

@freezed
abstract class InventoryStockState with _$InventoryStockState {
  const factory InventoryStockState.initial({
    required InventoryItem item,
    @Default(LoadingStatus.initial) LoadingStatus status,
    DateTime? expiration,
    @Default(Stock.pure()) Stock stock,
    @Default(LowStockThreshold.pure()) LowStockThreshold lowStockThreshold,
  }) = _Initial;
}
