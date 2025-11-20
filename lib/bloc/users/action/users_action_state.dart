part of 'users_action_bloc.dart';

enum UserAction {
  delete,
  update,
  passwordChange;

  String get loadingMessage {
    switch (this) {
      case UserAction.delete:
        return 'Deleting user...';
      case UserAction.update:
        return 'Updating user...';
      case UserAction.passwordChange:
        return 'Changing password...';
    }
  }

  String get successMessage {
    switch (this) {
      case UserAction.delete:
        return 'User deleted successfully.';
      case UserAction.update:
        return 'User updated successfully.';
      case UserAction.passwordChange:
        return 'Password changed successfully.';
    }
  }
}

@freezed
abstract class UsersActionState with _$UsersActionState {
  const factory UsersActionState.initial({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(UserAction.delete) UserAction action,
    String? errorMessage,
  }) = _Initial;
}
