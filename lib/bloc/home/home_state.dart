part of 'home_bloc.dart';

enum HomeStatus { initial, order, reservation, login }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial({
    @Default(HomeStatus.initial) HomeStatus status,
    @Default('') String reservationId,
  }) = _Initial;
}
