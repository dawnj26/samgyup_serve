part of 'refill_bloc.dart';

@freezed
abstract class RefillEvent with _$RefillEvent {
  const factory RefillEvent.started({
    required List<RefillData> data,
  }) = _Started;
}
