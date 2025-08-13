import 'package:flutter/material.dart';
import 'package:samgyup_serve/ui/login/view/components/email_input.dart';
import 'package:samgyup_serve/ui/login/view/components/login_button.dart';
import 'package:samgyup_serve/ui/login/view/components/password_input.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EmailInput(),
        SizedBox(height: 8),
        PasswordInput(),
        SizedBox(height: 16),
        LoginButton(),
      ],
    );
  }
}
