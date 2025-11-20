part of 'users_list_bloc.dart';

@freezed
abstract class UsersListEvent with _$UsersListEvent {
  const factory UsersListEvent.started() = _Started;
}
