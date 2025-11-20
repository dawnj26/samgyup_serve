part of 'batch_delete_bloc.dart';

@freezed
abstract class BatchDeleteState with _$BatchDeleteState {
  const factory BatchDeleteState.initial({
    @Default(LoadingStatus.initial) LoadingStatus status,
    String? errorMessage,
  }) = _Initial;
}
