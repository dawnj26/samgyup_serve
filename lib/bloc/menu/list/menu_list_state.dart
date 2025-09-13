part of 'menu_list_bloc.dart';

enum MenuListStatus { initial, loading, success, failure }

@freezed
abstract class MenuListState with _$MenuListState {
  const factory MenuListState.initial({
    @Default(MenuListStatus.initial) MenuListStatus status,
    @Default([]) List<MenuItem> items,
    String? errorMessage,
  }) = _Initial;
}
