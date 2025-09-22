import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/home/home_bloc.dart';
import 'package:samgyup_serve/bloc/login/login_bloc.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/login/view/login_form.dart';

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
      child: FormScaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<HomeBloc>().add(
                const HomeEvent.statusChanged(SessionStatus.initial),
              );
            },
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
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
      ),
    );
  }
}
