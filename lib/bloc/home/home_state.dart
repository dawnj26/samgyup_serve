part of 'home_bloc.dart';

enum SessionStatus { initial, order, reservation, login }

enum HomeStatus { initial, loading, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial({
    @Default(SessionStatus.initial) SessionStatus session,
    @Default(HomeStatus.initial) HomeStatus status,
    @Default('') String reservationId,
    String? errorMessage,
  }) = _Initial;
}
