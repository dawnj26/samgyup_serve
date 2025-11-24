part of 'peak_hours_bloc.dart';

@freezed
abstract class PeakHoursState with _$PeakHoursState {
  const factory PeakHoursState.initial({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<int> peakHours,
    String? errorMessage,
  }) = _Initial;
}
