import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/revenue/revenue_bloc.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/dashboard/components/chart_period_dropdown.dart';

class RevenueSummary extends StatelessWidget {
  const RevenueSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Main();
  }
}

class _Main extends StatelessWidget {
  const _Main();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sales',
              style: textTheme.labelLarge,
            ),
            ChartPeriodDropdown(
              onChanged: (period) {
                context.read<RevenueBloc>().add(
                  RevenueEvent.periodChanged(period),
                );
              },
            ),
          ],
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
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<RevenueBloc, RevenueState>(
      builder: (context, state) {
        switch (state.status) {
          case RevenueStatus.initial:
          case RevenueStatus.loading:
            return const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case RevenueStatus.loaded:
            return RevenueLineChart(
              data: state.data,
              period: state.period,
            );
          case RevenueStatus.error:
            return SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  state.errorMessage ?? 'An unknown error occurred',
                  style: textTheme.bodyMedium,
                ),
              ),
            );
        }
      },
    );
  }
}
