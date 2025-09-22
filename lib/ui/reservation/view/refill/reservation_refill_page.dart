import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:package_repository/package_repository.dart';
import 'package:samgyup_serve/bloc/menu/list/menu_list_bloc.dart';
import 'package:samgyup_serve/bloc/order/cart/order_cart_bloc.dart';
import 'package:samgyup_serve/bloc/reservation/refill/reservation_refill_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/navigation.dart';
import 'package:samgyup_serve/ui/reservation/view/refill/reservation_refill_screen.dart';

@RoutePage()
class ReservationRefillPage extends StatelessWidget
    implements AutoRouteWrapper {
  const ReservationRefillPage({
    required this.package,
    required this.quantity,
    required this.startTime,
    super.key,
    this.onSave,
  });

  final FoodPackage package;
  final DateTime startTime;
  final int quantity;
  final void Function(List<CartItem<MenuItem>> items)? onSave;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservationRefillBloc, ReservationRefillState>(
      listener: (context, state) {
        if (state.status == ReservationRefillStatus.timeLimitExceeded) {
          goToPreviousRoute(context);
        }

        if (state.status == ReservationRefillStatus.loading) {
          showLoadingDialog(context: context);
        }

        if (state.status == ReservationRefillStatus.success) {
          context.router.pop();
          goToPreviousRoute(context);
          onSave?.call(state.cartItems);
        }

        if (state.status == ReservationRefillStatus.failure) {
          showErrorDialog(
            context: context,
            message: state.message ?? 'Failed to process refill request.',
          );
        }
      },
      child: ReservationRefillScreen(
        quantity: quantity,
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MenuListBloc(
            menuIds: package.menuIds,
            menuRepository: context.read(),
          )..add(const MenuListEvent.started()),
        ),
        BlocProvider(
          create: (context) => OrderCartBloc(),
        ),
        BlocProvider(
          create: (context) => ReservationRefillBloc(
            startTime: startTime,
            package: package,
            menuRepository: context.read(),
          ),
        ),
      ],
      child: this,
    );
  }
}
