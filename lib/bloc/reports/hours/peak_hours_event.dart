part of 'peak_hours_bloc.dart';

@freezed
class PeakHoursEvent with _$PeakHoursEvent {
  const factory PeakHoursEvent.started() = _Started;
}
