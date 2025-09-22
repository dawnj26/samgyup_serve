part of 'menu_bloc.dart';

@freezed
abstract class MenuEvent with _$MenuEvent {
  const factory MenuEvent.started({
    List<MenuCategory>? initialCategories,
  }) = _Started;
  const factory MenuEvent.loadMore() = _LoadMore;
  const factory MenuEvent.refresh() = _Refresh;
  const factory MenuEvent.filterChanged({
    required List<MenuCategory> selectedCategories,
  }) = _FilterChanged;
}
