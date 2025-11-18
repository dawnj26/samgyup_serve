part of 'inventory_select_bloc.dart';

@freezed
abstract class InventorySelectEvent with _$InventorySelectEvent {
  const factory InventorySelectEvent.started() = _Started;
  const factory InventorySelectEvent.loadMore() = _LoadMore;
  const factory InventorySelectEvent.itemSelected(
    InventoryItem item,
  ) = _ItemSelected;
  const factory InventorySelectEvent.itemRemoved(
    String inventoryItemId,
  ) = _ItemRemoved;
  const factory InventorySelectEvent.cleared() = _Cleared;
  const factory InventorySelectEvent.saved() = _Saved;
}
