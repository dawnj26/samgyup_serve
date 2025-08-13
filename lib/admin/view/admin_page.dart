import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:samgyup_serve/app/bloc/app_bloc.dart';

@RoutePage()
class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>();

    return FScaffold(
      header: FHeader(
        title: const Text('Admin Page'),
        suffixes: [
          FHeaderAction(
            icon: const Icon(Icons.logout),
            onPress: () {
              appBloc.add(const AppEvent.logout());
            },
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Welcome to the Admin Page',
        ),
      ),
    );
  }
}
