part of 'inventory_list_bloc.dart';

@freezed
abstract class InventoryListState with _$InventoryListState {
  const factory InventoryListState.initial({
    @Default([]) List<InventoryCategory> categories,
    @Default([]) List<InventoryItem> items,
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = _Initial;
}
