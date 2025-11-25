part of 'inventory_stock_bloc.dart';

@freezed
class InventoryStockEvent with _$InventoryStockEvent {
  const factory InventoryStockEvent.submitted({
    required String userId,
  }) = _Submitted;
  const factory InventoryStockEvent.stockChanged({
    required String stock,
  }) = _StockChanged;
  const factory InventoryStockEvent.expirationChanged({
    required DateTime? expiration,
  }) = _ExpirationChanged;
}
