part of 'menu_select_bloc.dart';

@freezed
abstract class MenuSelectState with _$MenuSelectState {
  const factory MenuSelectState.initial({
    @Default([]) List<MenuItem> items,
    @Default([]) List<MenuItem> selectedItems,
    @Default(false) bool hasReachedMax,
  }) = MenuSelectInitial;

  const factory MenuSelectState.loading({
    @Default([]) List<MenuItem> items,
    @Default([]) List<MenuItem> selectedItems,
    @Default(false) bool hasReachedMax,
  }) = MenuSelectLoading;

  const factory MenuSelectState.success({
    required List<MenuItem> items,
    required List<MenuItem> selectedItems,
    required bool hasReachedMax,
  }) = MenuSelectSuccess;

  const factory MenuSelectState.done({
    required List<MenuItem> items,
    required List<MenuItem> selectedItems,
    required bool hasReachedMax,
  }) = MenuSelectDone;

  const factory MenuSelectState.failure({
    @Default([]) List<MenuItem> items,
    @Default([]) List<MenuItem> selectedItems,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = MenuSelectFailure;
}
