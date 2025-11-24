import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/total/reservation_total_bloc.dart';
import 'package:samgyup_serve/bloc/revenue/revenue_bloc.dart';
import 'package:samgyup_serve/bloc/table/availability/table_availability_bloc.dart';
import 'package:samgyup_serve/ui/dashboard/components/components.dart';
import 'package:samgyup_serve/ui/dashboard/components/peak_hours_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final content = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Text(
                  'Dashboard',
                  style: textTheme.headlineMedium,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    context.read<RevenueBloc>().add(
                      const RevenueEvent.started(),
                    );
                    context.read<TableAvailabilityBloc>().add(
                      const TableAvailabilityEvent.started(),
                    );
                    context.read<ReservationTotalBloc>().add(
                      const ReservationTotalEvent.started(),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverToBoxAdapter(
            child: RevenueSummary(),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: TableAvailability(),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ReservationToday(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverToBoxAdapter(
            child: PeakHoursChart(),
          ),
        ),
      ],
    );

    return Scaffold(
      body: kIsWeb
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: content,
              ),
            )
          : content,
    );
  }
}
