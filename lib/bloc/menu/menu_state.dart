part of 'menu_bloc.dart';

@freezed
abstract class MenuState with _$MenuState {
  const factory MenuState.initial({
    @Default([]) List<MenuItem> items,
    @Default(false) bool hasReachedMax,
    @Default(MenuInfo.empty()) MenuInfo menuInfo,
    @Default([]) List<MenuCategory> selectedCategories,
  }) = MenuInitial;

  const factory MenuState.loading({
    required List<MenuItem> items,
    required bool hasReachedMax,
    required MenuInfo menuInfo,
    required List<MenuCategory> selectedCategories,
  }) = MenuLoading;

  const factory MenuState.loaded({
    required List<MenuItem> items,
    required bool hasReachedMax,
    required MenuInfo menuInfo,
    required List<MenuCategory> selectedCategories,
  }) = MenuLoaded;

  const factory MenuState.error({
    required String message,
    required List<MenuItem> items,
    required bool hasReachedMax,
    required MenuInfo menuInfo,
    required List<MenuCategory> selectedCategories,
  }) = MenuError;
}
