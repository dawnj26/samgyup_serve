import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/ui/components/components.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.router.push(const LoginRoute());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppLogo(
              size: screenWidth * 0.5,
            ),
            const SizedBox(height: 16),
            const _OrderButton(),
          ],
        ),
      ),
    );
  }
}

class _OrderButton extends StatelessWidget {
  const _OrderButton();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final deviceStatus = context.select(
      (AppBloc bloc) => bloc.state.deviceStatus,
    );
    final device = context.select(
      (AppBloc bloc) => bloc.state.device,
    );

    final isRegistered = deviceStatus == DeviceStatus.registered;
    final warningLabel = switch (deviceStatus) {
      DeviceStatus.registered => null,
      DeviceStatus.unknown => 'Unknown Device',
      DeviceStatus.unregistered =>
        'This device is not assigned. '
            'Please contact the staff for assistance. '
            '(${device!.id})',
    };

    return Column(
      children: [
        PrimaryButton(
          onPressed: isRegistered ? () {} : null,
          child: const Text('Tap to start ordering'),
        ),
        if (warningLabel != null) ...[
          const SizedBox(height: 8),
          Text(
            warningLabel,
            style: textTheme.bodySmall?.copyWith(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
