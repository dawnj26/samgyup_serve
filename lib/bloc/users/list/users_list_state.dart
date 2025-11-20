part of 'users_list_bloc.dart';

@freezed
abstract class UsersListState with _$UsersListState {
  const factory UsersListState.initial({
    @Default([]) List<User> users,
    @Default(LoadingStatus.initial) LoadingStatus status,
    String? errorMessage,
  }) = _Initial;
}
