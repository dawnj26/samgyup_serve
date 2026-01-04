part of 'home_bloc.dart';

enum SessionStatus {
  initial,
  count,
  order,
  reservation,
  login,
  payment,
  cancel,
}

enum HomeStatus { initial, loading, success, failure }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.initial({
    @Default(SessionStatus.initial) SessionStatus session,
    @Default(HomeStatus.initial) HomeStatus status,
    @Default('') String reservationId,
    @Default('') String invoiceId,
    @Default(1) int customerCount,
    Table? table,
    String? errorMessage,
  }) = _Initial;
}
