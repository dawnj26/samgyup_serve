import 'package:auto_route/auto_route.dart';
import 'package:billing_repository/billing_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/payment/form/payment_form_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/form/price.dart';
import 'package:samgyup_serve/shared/formatter.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/events/components/components.dart';

class PaymentBottomSheet extends StatelessWidget {
  const PaymentBottomSheet({
    required this.totalAmount,
    super.key,
    this.onSuccess,
  });

  final double totalAmount;
  final void Function(Payment payment)? onSuccess;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PaymentFormBloc(
            totalAmount: totalAmount,
            billingRepository: context.read(),
          ),
        ),
      ],
      child: BlocListener<PaymentFormBloc, PaymentFormState>(
        listener: (context, state) {
          if (state.status == FormzSubmissionStatus.success) {
            final change = state.payment!.amount - totalAmount;
            final message = 'Change: ${formatToPHP(change)}';

            showInfoDialog(
              context: context,
              title: 'Payment Successful',
              message: message,
              onOk: () {
                context.router.pop();
                onSuccess?.call(state.payment!);
              },
            );
          }

          if (state.status == FormzSubmissionStatus.failure) {
            showErrorDialog(
              context: context,
              message: state.errorMessage ?? 'Something went wrong',
            );
          }
        },
        child: _Sheet(
          amount: totalAmount,
        ),
      ),
    );
  }
}

class _Sheet extends StatelessWidget {
  const _Sheet({
    required this.amount,
  });

  final double amount;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: BottomSheetLayout(
        height: screenHeight * 0.75,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment (${formatToPHP(amount)})',
                  style: textTheme.titleLarge,
                ),
                const _Qr(),
              ],
            ),
            const SizedBox(height: 16),
            const _Price(),
            const SizedBox(height: 16),
            const _Method(),
            const SizedBox(height: 16),
            const _Ref(),
            const SizedBox(height: 16),
            const _Button(),
          ],
        ),
      ),
    );
  }
}

class _Qr extends StatelessWidget {
  const _Qr();

  @override
  Widget build(BuildContext context) {
    final fileId = context.select(
      (AppBloc bloc) => bloc.state.settings.qrCode,
    );

    return TextButton(
      onPressed: () {
        if (fileId == null) {
          return showErrorDialog(
            context: context,
            message: 'No QR code available',
          );
        }

        showImageDialog(context: context, fileId: fileId);
      },
      child: const Text('Show QR Code'),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button();

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.select(
      (PaymentFormBloc bloc) =>
          bloc.state.status == FormzSubmissionStatus.inProgress,
    );
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: isSubmitting
          ? null
          : () {
              context.read<PaymentFormBloc>().add(
                const PaymentFormEvent.submitted(),
              );
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Submit Payment'),
          if (isSubmitting) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Ref extends StatelessWidget {
  const _Ref();

  @override
  Widget build(BuildContext context) {
    return TransactionRefInput(
      onChanged: (value) => context.read<PaymentFormBloc>().add(
        PaymentFormEvent.transactionRefChanged(value),
      ),
    );
  }
}

class _Method extends StatelessWidget {
  const _Method();

  @override
  Widget build(BuildContext context) {
    return PaymentMethodDropdown(
      initialValue: PaymentMethod.cash,
      onSelected: (value) {
        if (value == null) return;

        context.read<PaymentFormBloc>().add(
          PaymentFormEvent.methodChanged(value),
        );
      },
    );
  }
}

class _Price extends StatelessWidget {
  const _Price();

  @override
  Widget build(BuildContext context) {
    final price = context.select(
      (PaymentFormBloc bloc) => bloc.state.price,
    );

    final errorText = price.displayError?.message;

    return PriceInput(
      labelText: 'Amount Tendered',
      errorText: errorText,
      onChanged: (price) => context.read<PaymentFormBloc>().add(
        PaymentFormEvent.priceChanged(price),
      ),
    );
  }
}
