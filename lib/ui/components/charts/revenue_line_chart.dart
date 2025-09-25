import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:samgyup_serve/data/models/revenue_data_point.dart';
import 'package:samgyup_serve/shared/formatter.dart';

enum ChartPeriod {
  weekly,
  monthly,
  yearly;

  String get label {
    switch (this) {
      case ChartPeriod.weekly:
        return 'Weekly';
      case ChartPeriod.monthly:
        return 'Monthly';
      case ChartPeriod.yearly:
        return 'Yearly';
    }
  }
}

class RevenueLineChart extends StatelessWidget {
  const RevenueLineChart({
    required this.data,
    required this.period,
    super.key,
    this.title,
    this.height = 300,
  });

  final List<RevenueDataPoint> data;
  final ChartPeriod period;
  final String? title;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No data available',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
            ],
            SizedBox(
              height: height,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    horizontalInterval: _getHorizontalInterval(),
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) =>
                            _buildBottomTitle(value, theme, meta),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: _getHorizontalInterval(),
                        reservedSize: 60,
                        getTitlesWidget: (value, meta) =>
                            _buildLeftTitle(value, theme),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  minX: 0,
                  maxX: _getMaxX(),
                  minY: _getMinY(),
                  maxY: _getMaxY(),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _getFlSpots(),
                      isCurved: true,
                      preventCurveOverShooting: true,
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.7),
                        ],
                      ),
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                              radius: 4,
                              color: colorScheme.primary,
                              strokeWidth: 2,
                              strokeColor: colorScheme.surface,
                            ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.3),
                            colorScheme.primary.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) =>
                          colorScheme.inverseSurface,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          final date = data[touchedSpot.x.toInt()].date;
                          final revenue = touchedSpot.y;
                          return LineTooltipItem(
                            '${_formatDate(date)}\n${formatToPHP(revenue)}',
                            TextStyle(
                              color: colorScheme.onInverseSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _getFlSpots() {
    if (data.isEmpty) return [];

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final point = entry.value;

      double x;
      switch (period) {
        case ChartPeriod.weekly:
          // For weekly: x should be 1-7 (day of week)
          x = index % 7;
        case ChartPeriod.monthly:
          // For monthly: x should be 1-30 (day of month)
          x = index % 4;
        case ChartPeriod.yearly:
          // For yearly: x should be 1-12 (month of year)
          x = index % 12;
      }

      return FlSpot(x, point.revenue);
    }).toList();
  }

  double _getMaxX() {
    switch (period) {
      case ChartPeriod.weekly:
        return 7 - 1;
      case ChartPeriod.monthly:
        return 4 - 1;
      case ChartPeriod.yearly:
        return 12 - 1;
    }
  }

  double _getMinY() {
    final minRevenue = data
        .map((e) => e.revenue)
        .reduce((a, b) => a < b ? a : b);
    return (minRevenue * 0.9).floorToDouble();
  }

  double _getMaxY() {
    final maxRevenue = data
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b);
    return (maxRevenue * 1.1).ceilToDouble();
  }

  double _getHorizontalInterval() {
    final range = _getMaxY() - _getMinY();
    return range / 5;
  }

  Widget _buildBottomTitle(double value, ThemeData theme, TitleMeta meta) {
    final date = data[value.toInt()].date.toLocal();
    final text = _formatDateForAxis(date);

    return SideTitleWidget(
      meta: meta,
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildLeftTitle(double value, ThemeData theme) {
    return Text(
      _formatCurrencyShort(value),
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  String _formatDateForAxis(DateTime date) {
    switch (period) {
      case ChartPeriod.weekly:
        return DateFormat('E').format(date); // Mon, Tue, etc.
      case ChartPeriod.monthly:
        return DateFormat('M/d').format(date); // 1/15, 2/1, etc.
      case ChartPeriod.yearly:
        return DateFormat('MMM').format(date); // Jan, Feb, etc.
    }
  }

  String _formatDate(DateTime date) {
    switch (period) {
      case ChartPeriod.weekly:
        return DateFormat('EEEE, MMM d').format(date);
      case ChartPeriod.monthly:
        return DateFormat('MMM d, yyyy').format(date);
      case ChartPeriod.yearly:
        return DateFormat('MMMM yyyy').format(date);
    }
  }

  String _formatCurrencyShort(double value) {
    if (value >= 1000000) {
      return '${formatToPHP(value / 1000000, 1)}M';
    } else if (value >= 1000) {
      return '${formatToPHP(value / 1000, 1)}K';
    }
    return formatToPHP(value, 0);
  }
}
