part of 'inventory_details_bloc.dart';

@freezed
abstract class InventoryDetailsState with _$InventoryDetailsState {
  const factory InventoryDetailsState.initial({
    required InventoryItem item,
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(false) bool isDirty,
    String? errorMessage,
  }) = _Initial;
}
