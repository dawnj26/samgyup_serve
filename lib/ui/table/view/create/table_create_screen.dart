import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:samgyup_serve/bloc/table/create/table_create_bloc.dart';
import 'package:samgyup_serve/shared/dialog.dart';
import 'package:samgyup_serve/shared/snackbar.dart';
import 'package:samgyup_serve/ui/table/components/create_table_bottom_sheet.dart';

class TableCreateScreen extends StatelessWidget {
  const TableCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TableCreateBloc(
        tableRepository: context.read(),
      ),
      child: const _Screen(),
    );
  }
}

class _Screen extends StatelessWidget {
  const _Screen();

  @override
  Widget build(BuildContext context) {
    return BlocListener<TableCreateBloc, TableCreateState>(
      listener: (context, state) {
        switch (state.status) {
          case FormzSubmissionStatus.canceled:
          case FormzSubmissionStatus.initial:
          case FormzSubmissionStatus.inProgress:
            break;
          case FormzSubmissionStatus.success:
            context.router.pop();
            showSnackBar(context, 'Table created successfully');
          case FormzSubmissionStatus.failure:
            showErrorDialog(
              context: context,
              message: state.errorMessage ?? 'An unknown error occurred',
            );
        }
      },
      child: const CreateTableBottomSheet(),
    );
  }
}
