part of 'table_details_bloc.dart';

enum TableDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

enum TableAssignmentStatus {
  initial,
  assigning,
  success,
  failure,
}

@freezed
abstract class TableDetailsState with _$TableDetailsState {
  const factory TableDetailsState.initial({
    required Table table,
    @Default(false) bool isDirty,
    @Default(TableAssignmentStatus.initial)
    TableAssignmentStatus assignmentStatus,
    @Default(TableDetailsStatus.initial) TableDetailsStatus status,
    Device? device,
    String? errorMessage,
  }) = _Initial;
}
