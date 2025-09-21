import 'package:auto_route/auto_route.dart';
import 'package:event_repository/event_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/event/actions/event_actions_bloc.dart';
import 'package:samgyup_serve/bloc/invoice/invoice_bloc.dart';
import 'package:samgyup_serve/bloc/order/list/order_list_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/ui/events/view/payment/event_payment_screen.dart';

@RoutePage()
class EventPaymentPage extends StatelessWidget implements AutoRouteWrapper {
  const EventPaymentPage({
    required this.invoiceId,
    required this.event,
    super.key,
  });

  final String invoiceId;
  final Event event;

  @override
  Widget build(BuildContext context) {
    return BlocListener<InvoiceBloc, InvoiceState>(
      listener: (context, state) {
        if (state.paymentStatus == PaymentStatus.processing) {
          showLoadingDialog(context: context, message: 'Processing payment...');
        }

        if (state.paymentStatus == PaymentStatus.completed) {
          context.router.pop();
          context.read<EventActionsBloc>().add(
            EventActionsEvent.completed(eventId: event.id),
          );
        }

        if (state.paymentStatus == PaymentStatus.failed) {
          context.router.pop();
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'Payment failed',
          );
        }

        if (state.status == InvoiceBlocStatus.success) {
          context.read<OrderListBloc>().add(
            OrderListEvent.started(
              orderIds: state.invoices.orderIds,
            ),
          );
        }
      },
      child: EventPaymentScreen(
        event: event,
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InvoiceBloc(
            invoiceId: invoiceId,
            billingRepository: context.read(),
            tableRepository: context.read(),
            reservationRepository: context.read(),
          )..add(const InvoiceEvent.started()),
        ),
        BlocProvider(
          create: (context) => OrderListBloc(
            orderRepository: context.read(),
            menuRepository: context.read(),
            packageRepository: context.read(),
          ),
        ),
      ],
      child: this,
    );
  }
}
