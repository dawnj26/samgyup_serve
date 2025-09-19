import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:order_repository/order_repository.dart';

part 'reservation_refill_event.dart';
part 'reservation_refill_state.dart';
part 'reservation_refill_bloc.freezed.dart';

class ReservationRefillBloc
    extends Bloc<ReservationRefillEvent, ReservationRefillState> {
  ReservationRefillBloc({
    required MenuRepository menuRepository,
  }) : _menuRepository = menuRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final MenuRepository _menuRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<ReservationRefillState> emit,
  ) async {
    emit(state.copyWith(status: ReservationRefillStatus.loading));
    try {
      for (final cartItem in event.cartItems) {
        await _menuRepository.decrementStock(
          menuId: cartItem.item.id,
          quantity: cartItem.quantity,
        );
      }

      emit(
        state.copyWith(
          status: ReservationRefillStatus.success,
          cartItems: event.cartItems,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: ReservationRefillStatus.failure,
          message: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: ReservationRefillStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }
}
