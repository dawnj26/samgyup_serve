import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/refill/refill_bloc.dart';
import 'package:samgyup_serve/data/models/refill_data.dart';
import 'package:samgyup_serve/ui/events/view/refill/event_refill_screen.dart';

@RoutePage()
class EventRefillPage extends StatelessWidget implements AutoRouteWrapper {
  const EventRefillPage({required this.event, super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return EventRefillScreen(
      event: event,
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MenuRepository(),
      child: BlocProvider(
        create: (context) {
          final payload = jsonDecode(event.payload) as Map<String, dynamic>;
          final data = payload['data'] as Map<String, dynamic>;
          final orders = data['items'] as List<dynamic>? ?? [];

          final refillData = orders
              .map((e) => RefillData.fromJson(e as Map<String, dynamic>))
              .toList();

          return RefillBloc(
            menuRepository: context.read(),
          )..add(
            RefillEvent.started(data: refillData),
          );
        },
        child: this,
      ),
    );
  }
}
