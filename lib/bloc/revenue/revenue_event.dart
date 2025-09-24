part of 'revenue_bloc.dart';

@freezed
class RevenueEvent with _$RevenueEvent {
  const factory RevenueEvent.started() = _Started;
  const factory RevenueEvent.periodChanged(ChartPeriod period) = _PeriodChanged;
}
