import 'package:authentication_repository/authentication_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/users/action/users_action_bloc.dart';
import 'package:samgyup_serve/bloc/users/list/users_list_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/users/view/list/users_list_screen.dart';

@RoutePage()
class UsersListPage extends StatelessWidget implements AutoRouteWrapper {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersActionBloc, UsersActionState>(
      listener: (context, state) {
        final action = state.action;
        if (state.status == LoadingStatus.loading) {
          showLoadingDialog(context: context, message: action.loadingMessage);
        }

        if (state.status == LoadingStatus.success) {
          context.router.pop();
          showSnackBar(context, action.successMessage);

          context.read<UsersListBloc>().add(const UsersListEvent.started());
        }

        if (state.status == LoadingStatus.failure) {
          context.router.pop();
          showErrorDialog(
            context: context,
            message: state.errorMessage ?? 'Something went wrong.',
          );
        }
      },
      child: const UsersListScreen(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UsersListBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          )..add(const UsersListEvent.started()),
        ),
        BlocProvider(
          create: (context) => UsersActionBloc(
            authenticationRepository: context.read<AuthenticationRepository>(),
          ),
        ),
      ],
      child: this,
    );
  }
}
