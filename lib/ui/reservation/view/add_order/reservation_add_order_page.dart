import 'package:auto_route/auto_route.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/bloc/menu/menu_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/order/reservation_order_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/navigation.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/reservation/view/add_order/reservation_add_order_screen.dart';

@RoutePage()
class ReservationAddOrderPage extends StatelessWidget
    implements AutoRouteWrapper {
  const ReservationAddOrderPage({
    required this.invoice,
    this.onSuccess,
    super.key,
  });

  final void Function()? onSuccess;
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationOrderBloc, ReservationOrderState>(
      listener: (context, state) {
        if (state.status == ReservationOrderStatus.loading) {
          showLoadingDialog(context: context, message: 'Adding Order...');
        }

        if (state.status == ReservationOrderStatus.pure) {
          goToPreviousRoute(context);
        }

        if (state.status == ReservationOrderStatus.success) {
          context.router.pop();
          goToPreviousRoute(context);

          onSuccess?.call();
          showSnackBar(context, 'Order added successfully');
        }

        if (state.status == ReservationOrderStatus.failure) {
          context.router.pop();
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'Failed to add order',
          );
        }
      },
      child: const ReservationAddOrderScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MenuBloc(
                menuRepository: context.read(),
              )..add(
                MenuEvent.started(
                  initialCategories: MenuCategory.values
                      .where(
                        (m) =>
                            m != MenuCategory.grilledMeats &&
                            m != MenuCategory.sideDishes,
                      )
                      .toList(),
                ),
              ),
        ),
        BlocProvider(
          create: (context) => ReservationOrderBloc(
            billingRepository: context.read(),
            invoice: invoice,
            menuRepository: context.read(),
            orderRepository: context.read(),
          ),
        ),
      ],
      child: this,
    );
  }
}
