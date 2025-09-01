import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/login/login_bloc.dart';
import 'package:samgyup_serve/ui/components/buttons/primary_button.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  void _onPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<LoginBloc>().add(const LoginEvent.loginSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;
        final primaryColor = Theme.of(context).colorScheme.primary;

        return PrimaryButton(
          onPressed: !isLoading ? () => _onPressed(context) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Log in'),
              if (isLoading) ...[
                const SizedBox(width: 8),
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
