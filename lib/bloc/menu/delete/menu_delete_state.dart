part of 'menu_delete_bloc.dart';

@freezed
class MenuDeleteState with _$MenuDeleteState {
  const factory MenuDeleteState.initial() = MenuDeleteInitial;
  const factory MenuDeleteState.deleting() = MenuDeleteDeleting;
  const factory MenuDeleteState.success() = MenuDeleteSuccess;
  const factory MenuDeleteState.error(String message) = MenuDeleteError;
}
