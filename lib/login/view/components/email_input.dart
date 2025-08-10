import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/components/outlined_text_field.dart';
import 'package:samgyup_serve/login/bloc/login_bloc.dart';
import 'package:samgyup_serve/shared/form/email.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final email = state.email;

        String? errorText;
        if (email.displayError == EmailValidationError.empty) {
          errorText = 'Email is required';
        } else if (email.displayError == EmailValidationError.invalid) {
          errorText = 'Invalid email address';
        }

        return OutlinedTextField(
          onChanged: (value) {
            context.read<LoginBloc>().add(
              LoginEvent.emailChanged(email: value),
            );
          },
          keyboardType: TextInputType.emailAddress,
          key: const Key('loginForm_emailInput_textField'),
          labelText: 'Email address',
          errorText: errorText,
        );
      },
    );
  }
}
