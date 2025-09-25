import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/dashboard/components/components.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const RevenueSummary(),
            const Row(
              children: [
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: TableAvailability(),
                  ),
                ),

                Expanded(
                  child: AspectRatio(aspectRatio: 1, child: ReservationToday()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
