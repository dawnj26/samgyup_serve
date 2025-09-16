import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/activity/activity_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/bloc/order/order_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<ActivityBloc, ActivityState>(
          listenWhen: (p, c) => c.status == ActivityStatus.inactive,
          listener: (context, state) {
            if (state.status == ActivityStatus.inactive) {
              context.read<ActivityBloc>().add(const ActivityEvent.reset());
              context.read<HomeBloc>().add(
                const HomeEvent.statusChanged(HomeStatus.initial),
              );
            }
          },
        ),
        BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            switch (state.status) {
              case OrderStatus.initial:
              case OrderStatus.loading:
                showLoadingDialog(context: context);
              case OrderStatus.success:
                context.router.pop();
                showSnackBar(context, 'Order placed successfully');
              case OrderStatus.failure:
                context.router.pop();
                showErrorDialog(
                  context: context,
                  message: state.errorMessage ?? 'Something went wrong',
                );
            }
          },
        ),
      ],
      child: this,
    );
  }
}
