part of 'table_create_bloc.dart';

@freezed
abstract class TableCreateState with _$TableCreateState {
  const factory TableCreateState.initial({
    @Default(TableNumber.pure()) TableNumber tableNumber,
    @Default(Capacity.pure()) Capacity capacity,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
    @Default(TableStatusInput.pure()) TableStatusInput tableStatus,
    String? errorMessage,
  }) = _Initial;
}
