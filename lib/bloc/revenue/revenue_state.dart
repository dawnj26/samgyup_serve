part of 'revenue_bloc.dart';

enum RevenueStatus { initial, loading, loaded, error }

@freezed
abstract class RevenueState with _$RevenueState {
  const factory RevenueState.initial({
    @Default(RevenueStatus.initial) RevenueStatus status,
    @Default([]) List<RevenueDataPoint> data,
    @Default(ChartPeriod.weekly) ChartPeriod period,
    String? errorMessage,
  }) = _Initial;
}
