part of 'table_form_bloc.dart';

@freezed
abstract class TableFormState with _$TableFormState {
  const factory TableFormState.initial({
    @Default(TableNumber.pure()) TableNumber tableNumber,
    @Default(Capacity.pure()) Capacity capacity,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(TableStatusInput.pure()) TableStatusInput tableStatus,
    Table? initialTable,
    String? errorMessage,
  }) = _Initial;
}
