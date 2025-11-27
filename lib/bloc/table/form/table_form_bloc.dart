import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:log_repository/log_repository.dart';
import 'package:samgyup_serve/shared/form/table/capacity.dart';
import 'package:samgyup_serve/shared/form/table/table_number.dart';
import 'package:samgyup_serve/shared/form/table/table_status_input.dart';
import 'package:table_repository/table_repository.dart';

part 'table_form_event.dart';
part 'table_form_state.dart';
part 'table_form_bloc.freezed.dart';

class TableFormBloc extends Bloc<TableFormEvent, TableFormState> {
  TableFormBloc({
    required TableRepository tableRepository,
    Table? initialTable,
  }) : _repo = tableRepository,
       super(
         _Initial(
           tableNumber: TableNumber.pure(initialTable?.number.toString() ?? ''),
           capacity: Capacity.pure(initialTable?.capacity.toString() ?? ''),
           tableStatus: TableStatusInput.pure(initialTable?.status),
           initialTable: initialTable,
         ),
       ) {
    on<_TableNumberChanged>(_onTableNumberChanged);
    on<_CapacityChanged>(_onCapacityChanged);
    on<_TableStatusChanged>(_onTableStatusChanged);
    on<_FormSubmitted>(_onFormSubmitted);
  }

  final TableRepository _repo;

  void _onTableNumberChanged(
    _TableNumberChanged event,
    Emitter<TableFormState> emit,
  ) {
    final tableNumber = TableNumber.dirty(event.value);
    emit(
      state.copyWith(
        tableNumber: tableNumber,
      ),
    );
  }

  void _onCapacityChanged(
    _CapacityChanged event,
    Emitter<TableFormState> emit,
  ) {
    final capacity = Capacity.dirty(event.value);
    emit(
      state.copyWith(
        capacity: capacity,
      ),
    );
  }

  void _onTableStatusChanged(
    _TableStatusChanged event,
    Emitter<TableFormState> emit,
  ) {
    final tableStatus = TableStatusInput.dirty(event.status);
    emit(
      state.copyWith(
        tableStatus: tableStatus,
      ),
    );
  }

  Future<void> _onFormSubmitted(
    _FormSubmitted event,
    Emitter<TableFormState> emit,
  ) async {
    final tableNumber = TableNumber.dirty(state.tableNumber.value);
    final capacity = Capacity.dirty(state.capacity.value);
    final tableStatus = TableStatusInput.dirty(state.tableStatus.value);

    final isFormValid = Formz.validate([tableNumber, capacity, tableStatus]);

    if (!isFormValid) {
      return emit(
        state.copyWith(
          tableNumber: tableNumber,
          capacity: capacity,
          tableStatus: tableStatus,
        ),
      );
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    try {
      if (state.initialTable != null) {
        final updatedTable = state.initialTable!.copyWith(
          number: int.parse(tableNumber.value),
          capacity: int.parse(capacity.value),
          status: tableStatus.value!,
        );

        if (updatedTable == state.initialTable) {
          return emit(state.copyWith(status: FormzSubmissionStatus.canceled));
        }

        await _repo.updateTable(updatedTable);

        await LogRepository.instance.logAction(
          action: LogAction.update,
          message: 'Table ${updatedTable.number} updated',
          resourceId: updatedTable.id,
          details:
              'Table ID: ${updatedTable.id}, Number: ${updatedTable.number}, '
              'Capacity: ${updatedTable.capacity}, '
              'Status: ${updatedTable.status.label}',
        );

        return emit(state.copyWith(status: FormzSubmissionStatus.success));
      }

      final table = Table(
        number: int.parse(tableNumber.value),
        capacity: int.parse(capacity.value),
        status: tableStatus.value!,
      );

      await _repo.createTable(table);
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
