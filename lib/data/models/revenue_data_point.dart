import 'package:freezed_annotation/freezed_annotation.dart';

part 'revenue_data_point.freezed.dart';
part 'revenue_data_point.g.dart';

@freezed
abstract class RevenueDataPoint with _$RevenueDataPoint {
  factory RevenueDataPoint({
    required DateTime date,
    required double revenue,
  }) = _RevenueDataPoint;

  factory RevenueDataPoint.fromJson(Map<String, dynamic> json) =>
      _$RevenueDataPointFromJson(json);
}
