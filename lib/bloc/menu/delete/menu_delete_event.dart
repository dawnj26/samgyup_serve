part of 'menu_delete_bloc.dart';

@freezed
abstract class MenuDeleteEvent with _$MenuDeleteEvent {
  const factory MenuDeleteEvent.started({
    required String menuId,
  }) = _Started;
}
