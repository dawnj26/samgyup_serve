part of 'user_bloc.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState.initial({
    required User user,
    @Default(LoadingStatus.initial) LoadingStatus status,
    String? errorMessage,
  }) = _Initial;
}
