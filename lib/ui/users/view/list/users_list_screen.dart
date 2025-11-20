import 'package:authentication_repository/authentication_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samgyup_serve/bloc/app/app_bloc.dart';
import 'package:samgyup_serve/bloc/users/action/users_action_bloc.dart';
import 'package:samgyup_serve/bloc/users/list/users_list_bloc.dart';
import 'package:samgyup_serve/router/router.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/users/components/components.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Users'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.router.push(
            UserAddRoute(
              onSuccess: () {
                context.read<UsersListBloc>().add(
                  const UsersListEvent.started(),
                );
              },
            ),
          );
        },
        label: const Text('Add User'),
        icon: const Icon(Icons.add),
      ),
      body: BlocBuilder<UsersListBloc, UsersListState>(
        builder: (context, state) {
          switch (state.status) {
            case LoadingStatus.initial:
            case LoadingStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case LoadingStatus.success:
              if (state.users.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No users yet',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.users.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final user = state.users[index];
                  return UserCard(user: user);
                },
              );
            case LoadingStatus.failure:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(state.errorMessage ?? 'An unknown error occurred'),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    required this.user,
    super.key,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMainAccount = user.id == '689b0f61000efd3d4df2';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: LetterAvatar(name: user.name ?? ''),
        title: Text(
          user.name ?? 'No Name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(user.email ?? 'No Email'),
        trailing: isMainAccount
            ? null
            : UserMoreOptionButton(
                onSelected: (option) async {
                  final currentUser = context.read<AppBloc>().state.user!;

                  switch (option) {
                    case UserOption.delete:
                      if (user.id == currentUser.id) {
                        showErrorDialog(
                          context: context,
                          message: 'You cannot delete your own account.',
                        );
                        return;
                      }

                      final confirm = await showConfirmationDialog(
                        context: context,
                        title: 'Delete User',
                        message: 'Are you sure you want to delete this user?',
                      );

                      if (!context.mounted || !confirm) return;

                      context.read<UsersActionBloc>().add(
                        UsersActionEvent.deleted(userId: user.id),
                      );
                    case UserOption.update:
                      await context.router.push(
                        UserEditRoute(
                          user: user,
                          onSuccess: () {
                            context.read<UsersListBloc>().add(
                              const UsersListEvent.started(),
                            );
                          },
                        ),
                      );
                  }
                },
              ),
      ),
    );
  }
}
