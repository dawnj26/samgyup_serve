part of 'qr_bloc.dart';

enum QrStatus { initial, loading, success, failure }

@freezed
abstract class QrState with _$QrState {
  const factory QrState.initial({
    @Default(QrStatus.initial) QrStatus status,
    String? fileId,
    String? errorMessage,
  }) = _Initial;
}
