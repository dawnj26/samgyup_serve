import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/login/login_bloc.dart';
import 'package:samgyup_serve/shared/form/password.dart';
import 'package:samgyup_serve/ui/components/outlined_text_field.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final password = state.password;

        String? errorText;
        if (password.displayError == PasswordValidationError.empty) {
          errorText = 'Password is required';
        }

        return OutlinedTextField(
          onChanged: (value) {
            context.read<LoginBloc>().add(
              LoginEvent.passwordChanged(password: value),
            );
          },
          key: const Key('loginForm_passwordInput_textField'),
          labelText: 'Password',
          errorText: errorText,
          obscureText: _obscureText,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        );
      },
    );
  }
}
