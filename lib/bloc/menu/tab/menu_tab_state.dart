part of 'menu_tab_bloc.dart';

enum MenuTabStatus { initial, loading, success, failure, refreshing }

@freezed
abstract class MenuTabState with _$MenuTabState {
  const factory MenuTabState.initial({
    @Default(MenuTabStatus.initial) MenuTabStatus status,
    @Default([]) List<MenuItem> items,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = _Initial;
}
