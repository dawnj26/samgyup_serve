import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:samgyup_serve/bloc/table/availability/table_availability_bloc.dart';

class TableAvailability extends StatelessWidget {
  const TableAvailability({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TableAvailabilityBloc(
        tableRepository: context.read(),
      )..add(const TableAvailabilityEvent.started()),
      child: const Card(child: _Main()),
    );
  }
}

class _Main extends StatelessWidget {
  const _Main();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<TableAvailabilityBloc, TableAvailabilityState>(
      builder: (context, state) {
        switch (state.status) {
          case TableAvailabilityStatus.initial:
          case TableAvailabilityStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case TableAvailabilityStatus.success:
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Table Availability',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  CircularPercentIndicator(
                    animation: true,
                    radius: 60,
                    percent: state.totalTables == 0
                        ? 0
                        : state.availableTables / state.totalTables,
                    center: Text(
                      '${state.availableTables}/${state.totalTables}',
                      style: textTheme.bodyLarge,
                    ),
                    progressColor: Colors.green,
                  ),
                ],
              ),
            );
          case TableAvailabilityStatus.failure:
            return Center(
              child: Text(
                state.errorMessage ?? 'An unknown error occurred',
                style: const TextStyle(color: Colors.red),
              ),
            );
        }
      },
    );
  }
}
