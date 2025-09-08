import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:samgyup_serve/bloc/table/create/table_create_bloc.dart';
import 'package:samgyup_serve/shared/form/table/capacity.dart';
import 'package:samgyup_serve/shared/form/table/table_number.dart';
import 'package:samgyup_serve/shared/form/table/table_status_input.dart';
import 'package:samgyup_serve/ui/components/components.dart';
import 'package:samgyup_serve/ui/table/components/components.dart';

class CreateTableBottomSheet extends StatelessWidget {
  const CreateTableBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: BottomSheetLayout(
        padding: const EdgeInsets.all(16),
        height: screenSize.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create New Table',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            const _TableNumber(),
            const SizedBox(height: 16),
            const _Capacity(),
            const SizedBox(height: 16),
            const _TableStatus(),
            const Spacer(),
            const _SaveButton(),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final status = context.select(
      (TableCreateBloc bloc) => bloc.state.status,
    );
    final isLoading = status == FormzSubmissionStatus.inProgress;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return FilledButton(
      onPressed: isLoading
          ? null
          : () {
              FocusScope.of(context).unfocus();
              context.read<TableCreateBloc>().add(
                const TableCreateEvent.formSubmitted(),
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
  const _TableNumber();

  @override
  Widget build(BuildContext context) {
    final tableNumber = context.select(
      (TableCreateBloc bloc) => bloc.state.tableNumber,
    );

    return TableNumberInput(
      onChanged: (value) => context.read<TableCreateBloc>().add(
        TableCreateEvent.tableNumberChanged(value),
      ),
      errorText: tableNumber.displayError?.message,
    );
  }
}

class _Capacity extends StatelessWidget {
  const _Capacity();

  @override
  Widget build(BuildContext context) {
    final capacity = context.select(
      (TableCreateBloc bloc) => bloc.state.capacity,
    );

    return CapacityInput(
      onChanged: (value) => context.read<TableCreateBloc>().add(
        TableCreateEvent.capacityChanged(value),
      ),
      errorText: capacity.displayError?.message,
    );
  }
}

class _TableStatus extends StatelessWidget {
  const _TableStatus();

  @override
  Widget build(BuildContext context) {
    final tableStatus = context.select(
      (TableCreateBloc bloc) => bloc.state.tableStatus,
    );

    return TableStatusDropdownMenu(
      onSelected: (status) {
        if (status == null) return;

        context.read<TableCreateBloc>().add(
          TableCreateEvent.tableStatusChanged(status),
        );
      },
      errorText: tableStatus.displayError?.message,
    );
  }
}
