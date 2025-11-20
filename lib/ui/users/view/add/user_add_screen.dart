import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:samgyup_serve/bloc/users/form/user_form_bloc.dart';

class UserAddScreen extends StatelessWidget {
  const UserAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),

        centerTitle: true,
        backgroundColor: colorScheme.surface,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.person_add_outlined,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Create New Account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                const _NameInput(),
                const SizedBox(height: 16),
                const _EmailInput(),
                const SizedBox(height: 16),
                const _PasswordInput(),
                const SizedBox(height: 32),
                const _SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextField(
          key: const Key('userAddForm_nameInput_textField'),
          onChanged: (name) =>
              context.read<UserFormBloc>().add(UserFormEvent.nameChanged(name)),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Name',
            prefixIcon: const Icon(Icons.person_outline),
            border: const OutlineInputBorder(),
            errorText: state.name.displayError != null ? 'Invalid name' : null,
          ),
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('userAddForm_emailInput_textField'),
          onChanged: (email) => context.read<UserFormBloc>().add(
            UserFormEvent.emailChanged(email),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: const OutlineInputBorder(),
            errorText: state.email.displayError != null
                ? 'Invalid email'
                : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('userAddForm_passwordInput_textField'),
          onChanged: (password) => context.read<UserFormBloc>().add(
            UserFormEvent.passwordChanged(password),
          ),
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            border: const OutlineInputBorder(),
            errorText: state.password.displayError != null
                ? 'Invalid password'
                : null,
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserFormBloc, UserFormState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const Center(child: CircularProgressIndicator())
            : FilledButton(
                key: const Key('userAddForm_submitButton'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => context.read<UserFormBloc>().add(
                  const UserFormEvent.submitted(),
                ),
                child: const Text('Create User'),
              );
      },
    );
  }
}
