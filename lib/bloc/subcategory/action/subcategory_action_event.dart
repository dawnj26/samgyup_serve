part of 'subcategory_action_bloc.dart';

@freezed
abstract class SubcategoryActionEvent with _$SubcategoryActionEvent {
  const factory SubcategoryActionEvent.created({
    required String name,
    required InventoryCategory category,
  }) = _Created;
  const factory SubcategoryActionEvent.removed({
    required String id,
  }) = _Removed;
}
