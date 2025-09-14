import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/ui/order/view/order_screen.dart';

@RoutePage()
class OrderPage extends StatelessWidget implements AutoRouteWrapper {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        context.read<ActivityBloc>().add(
          const ActivityEvent.started(),
        );
      },
      child: const OrderScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocListener<ActivityBloc, ActivityState>(
      listenWhen: (p, c) => c.status == ActivityStatus.inactive,
      listener: (context, state) {
        if (state.status == ActivityStatus.inactive) {
          context.read<ActivityBloc>().add(const ActivityEvent.reset());
          context.router.parent<StackRouter>()?.popUntilRoot();
        }
      },
      child: this,
    );
  }
}
