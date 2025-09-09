part of 'table_details_bloc.dart';

enum TableDetailsStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
abstract class TableDetailsState with _$TableDetailsState {
  const factory TableDetailsState.initial({
    required Table table,
    @Default(false) bool isDirty,
    @Default(TableDetailsStatus.initial) TableDetailsStatus status,
    String? errorMessage,
  }) = _Initial;
}
