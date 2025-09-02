part of 'menu_select_bloc.dart';

@freezed
class MenuSelectEvent with _$MenuSelectEvent {
  const factory MenuSelectEvent.started() = _Started;
  const factory MenuSelectEvent.loadMore() = _LoadMore;
  const factory MenuSelectEvent.itemToggled({
    required MenuItem item,
    required bool isSelected,
  }) = _ItemToggled;
  const factory MenuSelectEvent.saved() = _Saved;
  const factory MenuSelectEvent.selectedItemsChanged(List<MenuItem> items) =
      _SelectedItemsChanged;
}
