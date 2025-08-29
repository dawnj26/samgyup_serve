part of 'menu_details_bloc.dart';

@freezed
class MenuDetailsEvent with _$MenuDetailsEvent {
  const factory MenuDetailsEvent.started() = _Started;
  const factory MenuDetailsEvent.reloaded() = _Reloaded;
  const factory MenuDetailsEvent.menuReloaded() = _MenuReloaded;
}
