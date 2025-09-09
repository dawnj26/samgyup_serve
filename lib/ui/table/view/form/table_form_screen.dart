import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:samgyup_serve/bloc/table/form/table_form_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/table/components/table_form_bottom_sheet.dart';
import 'package:table_repository/table_repository.dart' as t;

class TableFormScreen extends StatelessWidget {
  const TableFormScreen({super.key, this.onSaved, this.initialTable});

  final void Function()? onSaved;
  final t.Table? initialTable;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TableFormBloc(
        tableRepository: context.read(),
        initialTable: initialTable,
      ),
      child: _Screen(
        onSaved,
      ),
    );
  }
}

class _Screen extends StatelessWidget {
  const _Screen(this.onSaved);

  final void Function()? onSaved;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TableFormBloc, TableFormState>(
      listener: (context, state) {
        switch (state.status) {
          case FormzSubmissionStatus.canceled:
            context.router.pop();
          case FormzSubmissionStatus.initial:
          case FormzSubmissionStatus.inProgress:
            break;
          case FormzSubmissionStatus.success:
            context.router.pop();
            showSnackBar(context, 'Table saved successfully');
            onSaved?.call();
          case FormzSubmissionStatus.failure:
            showErrorDialog(
              context: context,
              message: state.errorMessage ?? 'An unknown error occurred',
            );
        }
      },
      child: const TableFormBottomSheet(),
    );
  }
}
