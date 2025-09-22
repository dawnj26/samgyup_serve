part of 'refill_bloc.dart';

enum RefillStatus { initial, loading, success, failure }

@freezed
abstract class RefillState with _$RefillState {
  const factory RefillState.initial({
    @Default(RefillStatus.initial) RefillStatus status,
    @Default([]) List<CartItem<MenuItem>> orders,
    String? errorMessage,
  }) = _Initial;
}
