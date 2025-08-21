part of 'inventory_status_bloc.dart';

@freezed
class InventoryStatusEvent with _$InventoryStatusEvent {
  const factory InventoryStatusEvent.started() = _Started;
  const factory InventoryStatusEvent.reload() = _Reload;
  const factory InventoryStatusEvent.loadMore() = _LoadMore;
  const factory InventoryStatusEvent.itemRemoved({
    required InventoryItem item,
  }) = _ItemRemoved;
}
