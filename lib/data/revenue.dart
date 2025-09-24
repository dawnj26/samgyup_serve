import 'package:samgyup_serve/data/models/revenue_data_point.dart';

final List<RevenueDataPoint> sampleWeeklyRevenueData = [
  RevenueDataPoint(date: DateTime(2023), revenue: 0),
  RevenueDataPoint(date: DateTime(2023, 1, 2), revenue: 2000),
  RevenueDataPoint(date: DateTime(2023, 1, 9), revenue: 1800),
  RevenueDataPoint(date: DateTime(2023, 1, 11), revenue: 2200),
  RevenueDataPoint(date: DateTime(2023, 1, 12), revenue: 2500),
  RevenueDataPoint(date: DateTime(2023, 1, 20), revenue: 3000),
  RevenueDataPoint(date: DateTime(2023, 1, 21), revenue: 2800),
];

final List<RevenueDataPoint> sampleMonthlyRevenueData = [
  RevenueDataPoint(date: DateTime(2023), revenue: 0),
  RevenueDataPoint(date: DateTime(2023, 1, 7), revenue: 2000),
  RevenueDataPoint(date: DateTime(2023, 1, 14), revenue: 1800),
  RevenueDataPoint(date: DateTime(2023, 1, 21), revenue: 2200),
];

final List<RevenueDataPoint> sampleYearlyRevenueData = [
  RevenueDataPoint(date: DateTime(2023, 1, 15), revenue: 0),
  RevenueDataPoint(date: DateTime(2023, 2, 15), revenue: 1800),
  RevenueDataPoint(date: DateTime(2023, 3, 15), revenue: 2200),
  RevenueDataPoint(date: DateTime(2023, 4, 15), revenue: 2500),
  RevenueDataPoint(date: DateTime(2023, 5, 15), revenue: 3000),
  RevenueDataPoint(date: DateTime(2023, 6, 15), revenue: 2800),
  RevenueDataPoint(date: DateTime(2023, 7, 15), revenue: 3200),
  RevenueDataPoint(date: DateTime(2023, 8, 15), revenue: 3500),
  RevenueDataPoint(date: DateTime(2023, 9, 15), revenue: 4000),
  RevenueDataPoint(date: DateTime(2023, 10, 15), revenue: 2000),
  RevenueDataPoint(date: DateTime(2023, 11, 15), revenue: 4500),
  RevenueDataPoint(date: DateTime(2023, 12, 15), revenue: 5000),
];
