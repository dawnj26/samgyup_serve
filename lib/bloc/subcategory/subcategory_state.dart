part of 'subcategory_bloc.dart';

@freezed
abstract class SubcategoryState with _$SubcategoryState {
  const factory SubcategoryState.initial({
    required InventoryCategory category,
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<Subcategory> subcategories,
    @Default(false) bool isDirty,
    String? errorMessage,
  }) = _Initial;
}
