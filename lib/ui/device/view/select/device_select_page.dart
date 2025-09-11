import 'package:auto_route/auto_route.dart';
import 'package:device_repository/device_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/device/select/device_select_bloc.dart';
import 'package:samgyup_serve/ui/device/view/select/device_select_screen.dart';

@RoutePage()
class DeviceSelectPage extends StatelessWidget implements AutoRouteWrapper {
  const DeviceSelectPage({super.key, this.onSelected});

  final void Function(Device device)? onSelected;

  @override
  Widget build(BuildContext context) {
    return DeviceSelectScreen(
      onSelected: onSelected,
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => DeviceSelectBloc(
        deviceRepository: context.read(),
      ),
      child: this,
    );
  }
}
