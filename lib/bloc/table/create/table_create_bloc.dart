import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:samgyup_serve/shared/form/table/capacity.dart';
import 'package:samgyup_serve/shared/form/table/table_number.dart';
import 'package:samgyup_serve/shared/form/table/table_status_input.dart';
import 'package:table_repository/table_repository.dart';

part 'table_create_event.dart';
part 'table_create_state.dart';
part 'table_create_bloc.freezed.dart';

class TableCreateBloc extends Bloc<TableCreateEvent, TableCreateState> {
  TableCreateBloc({
    required TableRepository tableRepository,
  }) : _repo = tableRepository,
       super(const _Initial()) {
    on<_TableNumberChanged>(_onTableNumberChanged);
    on<_CapacityChanged>(_onCapacityChanged);
    on<_TableStatusChanged>(_onTableStatusChanged);
    on<_FormSubmitted>(_onFormSubmitted);
  }

  final TableRepository _repo;

  void _onTableNumberChanged(
    _TableNumberChanged event,
    Emitter<TableCreateState> emit,
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
    Emitter<TableCreateState> emit,
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
    Emitter<TableCreateState> emit,
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
    Emitter<TableCreateState> emit,
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
    } on Exception catch (_) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Something went wrong. Please try again.',
        ),
      );
    }
  }
}
