part of 'menu_tab_bloc.dart';

@freezed
class MenuTabEvent with _$MenuTabEvent {
  const factory MenuTabEvent.started() = _Started;
  const factory MenuTabEvent.fetchMore() = _FetchMore;
}
