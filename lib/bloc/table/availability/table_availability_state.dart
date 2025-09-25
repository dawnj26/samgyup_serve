part of 'table_availability_bloc.dart';

enum TableAvailabilityStatus { initial, loading, success, failure }

@freezed
abstract class TableAvailabilityState with _$TableAvailabilityState {
  const factory TableAvailabilityState.initial({
    @Default(TableAvailabilityStatus.initial) TableAvailabilityStatus status,
    @Default(0) int availableTables,
    @Default(0) int totalTables,
    String? errorMessage,
  }) = _Initial;
}
