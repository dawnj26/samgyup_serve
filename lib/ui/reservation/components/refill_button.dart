import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/timer/timer_bloc.dart';

class RefillButton extends StatelessWidget {
  const RefillButton({
    required this.child,
    required this.startTime,
    required this.durationMinutes,
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final DateTime startTime;
  final int durationMinutes;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: key,
      create: (context) => TimerBloc()
        ..add(
          TimerEvent.started(
            startTime: startTime,
            duration: Duration(minutes: durationMinutes),
          ),
        ),
      child: _Button(
        onPressed,
        child,
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button(this.onPressed, this.child);

  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final hours = state.duration.inHours.toString().padLeft(2, '0');
        final minutes = state.duration.inMinutes
            .remainder(60)
            .toString()
            .padLeft(2, '0');
        final seconds = state.duration.inSeconds
            .remainder(60)
            .toString()
            .padLeft(2, '0');

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: state.isFinished ? null : onPressed,
              child: child,
            ),
            const SizedBox(height: 4),
            Text(
              '$hours:$minutes:$seconds',
              style: textTheme.bodyMedium?.copyWith(
                color: state.isFinished ? Colors.red : colorScheme.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}
