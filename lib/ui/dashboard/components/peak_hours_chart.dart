import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:samgyup_serve/bloc/reports/hours/peak_hours_bloc.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

class PeakHoursChart extends StatelessWidget {
  const PeakHoursChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Peak Hours',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        const _Chart(),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<PeakHoursBloc, PeakHoursState>(
      builder: (context, state) {
        switch (state.status) {
          case LoadingStatus.initial:
          case LoadingStatus.loading:
            return const SizedBox(
              height: 300,
              child: Center(child: CircularProgressIndicator()),
            );
          case LoadingStatus.failure:
            return SizedBox(
              height: 300,
              child: Center(
                child: Text(state.errorMessage ?? 'Error loading data'),
              ),
            );
          case LoadingStatus.success:
            var data = state.peakHours;
            if (data.isEmpty) {
              data = List.filled(24, 0);
            }

            var maxY = data
                .reduce((curr, next) => curr > next ? curr : next)
                .toDouble();
            if (maxY == 0) maxY = 5;
            final interval = maxY / 5;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxY * 1.2,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (group) =>
                              colorScheme.inverseSurface,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final hour = group.x;
                            final count = rod.toY.toInt();
                            final time = DateFormat(
                              'h a',
                            ).format(DateTime(2024, 1, 1, hour));
                            return BarTooltipItem(
                              '$time\n$count reservations',
                              TextStyle(
                                color: colorScheme.onInverseSurface,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            getTitlesWidget: (value, meta) {
                              final hour = value.toInt();
                              if (hour % 4 == 0) {
                                final time = DateFormat(
                                  'h a',
                                ).format(DateTime(2024, 1, 1, hour));
                                return SideTitleWidget(
                                  meta: meta,
                                  child: Text(
                                    time,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 24,
                            interval: interval == 0 ? 1 : interval,
                            getTitlesWidget: (value, meta) {
                              if (value == 0) return const SizedBox.shrink();
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  value.toInt().toString(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                      ),
                      gridData: FlGridData(
                        drawVerticalLine: false,
                        horizontalInterval: interval == 0 ? 1 : interval,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(data.length, (index) {
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: data[index].toDouble(),
                              color: colorScheme.primary,
                              width: 8,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
