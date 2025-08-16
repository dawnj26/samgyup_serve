part of 'inventory_bloc.dart';

@freezed
abstract class InventoryState with _$InventoryState {
  const factory InventoryState.initial() = _Initial;
}
