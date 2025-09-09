import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:samgyup_serve/bloc/table/form/table_form_bloc.dart';
import 'package:samgyup_serve/shared/form/table/capacity.dart';
import 'package:samgyup_serve/shared/form/table/table_number.dart';
import 'package:samgyup_serve/shared/form/table/table_status_input.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/table/components/components.dart';
import 'package:table_repository/table_repository.dart';

class TableFormBottomSheet extends StatelessWidget {
  const TableFormBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final initialTable = context.select(
      (TableFormBloc bloc) => bloc.state.initialTable,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: BottomSheetLayout(
        padding: const EdgeInsets.all(16),
        height: screenSize.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Title(),
            const SizedBox(height: 24),
            _TableNumber(
              initialTable?.number.toString(),
            ),
            const SizedBox(height: 16),
            _Capacity(
              initialTable?.capacity.toString(),
            ),
            const SizedBox(height: 16),
            _TableStatus(
              initialTable?.status,
            ),
            const Spacer(),
            const _SaveButton(),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final initialTable = context.select(
      (TableFormBloc bloc) => bloc.state.initialTable,
    );

    return Text(
      initialTable == null ? 'Add Table' : 'Edit Table ${initialTable.number}',
      style: textTheme.titleLarge,
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (TableFormBloc bloc) => bloc.state.status,
    );
    final isLoading = status == FormzSubmissionStatus.inProgress;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return FilledButton(
      onPressed: isLoading
          ? null
          : () {
              FocusScope.of(context).unfocus();
              context.read<TableFormBloc>().add(
                const TableFormEvent.formSubmitted(),
              );
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Save'),
          if (isLoading) ...[
            const SizedBox(width: 16),
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: primaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TableNumber extends StatelessWidget {
  const _TableNumber([this.initialValue]);

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final tableNumber = context.select(
      (TableFormBloc bloc) => bloc.state.tableNumber,
    );

    return TableNumberInput(
      initialValue: initialValue,
      onChanged: (value) => context.read<TableFormBloc>().add(
        TableFormEvent.tableNumberChanged(value),
      ),
      errorText: tableNumber.displayError?.message,
    );
  }
}

class _Capacity extends StatelessWidget {
  const _Capacity([this.initialValue]);

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final capacity = context.select(
      (TableFormBloc bloc) => bloc.state.capacity,
    );

    return CapacityInput(
      initialValue: initialValue,
      onChanged: (value) => context.read<TableFormBloc>().add(
        TableFormEvent.capacityChanged(value),
      ),
      errorText: capacity.displayError?.message,
    );
  }
}

class _TableStatus extends StatelessWidget {
  const _TableStatus([this.initialValue]);

  final TableStatus? initialValue;

  @override
  Widget build(BuildContext context) {
    final tableStatus = context.select(
      (TableFormBloc bloc) => bloc.state.tableStatus,
    );

    return TableStatusDropdownMenu(
      value: initialValue,
      onSelected: (status) {
        if (status == null) return;

        context.read<TableFormBloc>().add(
          TableFormEvent.tableStatusChanged(status),
        );
      },
      errorText: tableStatus.displayError?.message,
    );
  }
}
