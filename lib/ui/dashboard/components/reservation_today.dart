import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/total/reservation_total_bloc.dart';

class ReservationToday extends StatelessWidget {
  const ReservationToday({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReservationTotalBloc(
        reservationRepository: context.read(),
      )..add(const ReservationTotalEvent.started()),
      child: const Card(child: _Main()),
    );
  }
}

class _Main extends StatelessWidget {
  const _Main();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<ReservationTotalBloc, ReservationTotalState>(
      builder: (context, state) {
        switch (state.status) {
          case ReservationTotalStatus.initial:
          case ReservationTotalStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ReservationTotalStatus.success:
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reservations Today',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 32),
                  Text('${state.todayTotal}', style: textTheme.headlineLarge),
                ],
              ),
            );
          case ReservationTotalStatus.failure:
            return Center(
              child: Text(
                state.errorMessage ?? 'An unknown error occurred',
                style: textTheme.bodyMedium?.copyWith(color: Colors.red),
              ),
            );
        }
      },
    );
  }
}
