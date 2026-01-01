part of 'event_order_bloc.dart';

@freezed
abstract class EventOrderState with _$EventOrderState {
  const factory EventOrderState.initial({
    @Default(LoadingStatus.initial) LoadingStatus loadingStatus,
    @Default(false) bool isCompletedAll,
    String? errorMessage,
  }) = _Initial;
}
