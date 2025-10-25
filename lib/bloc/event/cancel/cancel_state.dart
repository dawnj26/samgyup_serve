part of 'cancel_bloc.dart';

enum CancelStatus {
  initial,
  accepting,
  declining,
  success,
  failure,
}

@freezed
abstract class CancelState with _$CancelState {
  const factory CancelState.initial({
    @Default(CancelStatus.initial) CancelStatus status,
    String? errorMessage,
  }) = _Initial;
}
