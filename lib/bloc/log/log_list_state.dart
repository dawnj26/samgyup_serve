part of 'log_list_bloc.dart';

@freezed
abstract class LogListState with _$LogListState {
  const factory LogListState.initial({
    @Default([]) List<LogBase> logs,
    @Default(false) bool hasReachedMax,
    @Default(LoadingStatus.initial) LoadingStatus status,
    LogAction? action,
    String? errorMessage,
  }) = _Initial;
}
