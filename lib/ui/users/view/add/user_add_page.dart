import 'package:authentication_repository/authentication_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:samgyup_serve/bloc/users/form/user_form_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/users/view/add/user_add_screen.dart';

@RoutePage()
class UserAddPage extends StatelessWidget implements AutoRouteWrapper {
  const UserAddPage({super.key, this.onSuccess});

  final void Function()? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserFormBloc, UserFormState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isInProgress) {
          showLoadingDialog(context: context, message: 'Creating user...');
        }

        if (state.status.isSuccess) {
          context.router.pop();
          context.router.pop();

          showSnackBar(context, 'User created successfully.');
          onSuccess?.call();
        }

        if (state.status.isFailure) {
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'Something went wrong.',
          );
        }
      },
      child: const UserAddScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => UserFormBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: this,
    );
  }
}
