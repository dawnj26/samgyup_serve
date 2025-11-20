part of 'users_action_bloc.dart';

@freezed
class UsersActionEvent with _$UsersActionEvent {
  const factory UsersActionEvent.deleted({
    required String userId,
  }) = _Deleted;
  const factory UsersActionEvent.updated() = _Updated;
  const factory UsersActionEvent.passwordChanged(String password) =
      _PasswordChanged;
}
