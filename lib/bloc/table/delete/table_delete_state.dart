part of 'table_delete_bloc.dart';

enum TableDeleteStatus {
  initial,
  loading,
  success,
  failure,
}

@freezed
abstract class TableDeleteState with _$TableDeleteState {
  const factory TableDeleteState.initial({
    @Default(TableDeleteStatus.initial) TableDeleteStatus status,
    String? errorMessage,
  }) = _Initial;
}
