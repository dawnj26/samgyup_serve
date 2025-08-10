import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/components/buttons/primary_button.dart';
import 'package:samgyup_serve/login/bloc/login_bloc.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  void _onPressed(BuildContext context) {
    context.read<LoginBloc>().add(const LoginEvent.loginSubmitted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return PrimaryButton(
          onPressed: !isLoading ? () => _onPressed(context) : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login'),
              if (isLoading) ...[
                const SizedBox(width: 8),
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
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
