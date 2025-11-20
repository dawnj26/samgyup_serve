part of 'batch_delete_bloc.dart';

@freezed
abstract class BatchDeleteEvent with _$BatchDeleteEvent {
  const factory BatchDeleteEvent.started({
    required StockBatch batch,
  }) = _Started;
}
