import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/reservation_bloc.dart';
import 'package:samgyup_serve/shared/formatter.dart';

class ReservationHeader extends StatelessWidget {
  const ReservationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TableNumber(),
        SizedBox(height: 4),
        _Invoice(),
        SizedBox(height: 16),
        _TimeStarted(),
      ],
    );
  }
}

class _TableNumber extends StatelessWidget {
  const _TableNumber();

  @override
  Widget build(BuildContext context) {
    final tableNumber = context.select(
      (ReservationBloc bloc) => bloc.state.table.number,
    );
    final textTheme = Theme.of(context).textTheme;

    return Text(
      'Table #$tableNumber',
      style: textTheme.headlineLarge,
    );
  }
}

class _Invoice extends StatelessWidget {
  const _Invoice();

  @override
  Widget build(BuildContext context) {
    final code = context.select(
      (ReservationBloc bloc) => bloc.state.invoice.code,
    );
    final textTheme = Theme.of(context).textTheme;

    return Text(
      code,
      style: textTheme.labelLarge,
    );
  }
}

class _TimeStarted extends StatelessWidget {
  const _TimeStarted();

  @override
  Widget build(BuildContext context) {
    final timeStarted = context.select(
      (ReservationBloc bloc) => bloc.state.reservation.startTime,
    );

    return Text('Time started: ${formatTime(timeStarted.toLocal())}');
  }
}
