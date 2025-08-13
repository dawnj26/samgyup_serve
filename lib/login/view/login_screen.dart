import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';
import 'package:samgyup_serve/app/bloc/app_bloc.dart';
import 'package:samgyup_serve/login/bloc/login_bloc.dart';
import 'package:samgyup_serve/login/view/login_form.dart';
import 'package:samgyup_serve/shared/snackbar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        switch (state) {
          case LoginFailure(:final message):
            showSnackBar(context, message);
          case LoginSuccess(:final user):
            context.read<AppBloc>().add(AppEvent.login(user: user));
        }
      },
      child: FScaffold(
        header: FHeader.nested(
          prefixes: [
            FHeaderAction.back(
              onPress: () {
                context.router.back();
              },
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.admin_panel_settings_outlined, size: 32),
                SizedBox(width: 8),
                Text(
                  'Admin Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}
