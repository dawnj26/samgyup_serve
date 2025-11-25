import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:samgyup_serve/data/models/refill_data.dart';

part 'refill_event.dart';
part 'refill_state.dart';
part 'refill_bloc.freezed.dart';

class RefillBloc extends Bloc<RefillEvent, RefillState> {
  RefillBloc({
    required InventoryRepository inventoryRepository,
  }) : _repo = inventoryRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
  }

  final InventoryRepository _repo;

  Future<void> _onStarted(
    _Started event,
    Emitter<RefillState> emit,
  ) async {
    emit(state.copyWith(status: RefillStatus.loading));

    try {
      final cart = <CartItem<InventoryItem>>[];
      for (final data in event.data) {
        final menuItem = await _repo.fetchItemById(
          data.menuId,
          includeBatch: true,
          includeDeleted: true,
        );

        cart.add(
          CartItem(
            item: menuItem,
            quantity: data.quantity,
          ),
        );
      }

      emit(
        state.copyWith(
          status: RefillStatus.success,
          orders: cart,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: RefillStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: RefillStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
