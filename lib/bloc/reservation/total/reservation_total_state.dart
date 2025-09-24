part of 'reservation_total_bloc.dart';

enum ReservationTotalStatus { initial, loading, success, failure }

@freezed
abstract class ReservationTotalState with _$ReservationTotalState {
  const factory ReservationTotalState.initial({
    @Default(ReservationTotalStatus.initial) ReservationTotalStatus status,
    @Default(0) int todayTotal,
    String? errorMessage,
  }) = _Initial;
}
