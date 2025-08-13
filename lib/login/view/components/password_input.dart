import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:forui/widgets/button.dart';
import 'package:samgyup_serve/components/outlined_text_field.dart';
import 'package:samgyup_serve/login/bloc/login_bloc.dart';
import 'package:samgyup_serve/shared/form/password.dart';

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
            if (value == password.value) return;

            context.read<LoginBloc>().add(
              LoginEvent.passwordChanged(password: value),
            );
          },
          key: const Key('loginForm_passwordInput_textField'),
          labelText: 'Password',
          hintText: 'Enter your password',
          errorText: errorText,
          obscureText: _obscureText,
          suffixIcon: FButton(
            mainAxisSize: MainAxisSize.min,
            style: FButtonStyle.ghost(),
            child: Icon(
              _obscureText ? FIcons.eyeClosed : FIcons.eye,
              size: 16,
            ),
            onPress: () {
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
