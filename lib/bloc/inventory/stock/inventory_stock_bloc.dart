import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/form/inventory/stock.dart';

part 'inventory_stock_event.dart';
part 'inventory_stock_state.dart';
part 'inventory_stock_bloc.freezed.dart';

class InventoryStockBloc
    extends Bloc<InventoryStockEvent, InventoryStockState> {
  InventoryStockBloc({
    required InventoryRepository inventoryRepository,
    required InventoryItem item,
  }) : _inventoryRepository = inventoryRepository,
       super(
         _Initial(
           item: item,
         ),
       ) {
    on<_StockChanged>(_onStockChanged);
    on<_ExpirationChanged>(_onExpirationChanged);
    on<_Submitted>(_onSubmitted);
  }

  final InventoryRepository _inventoryRepository;

  Future<void> _onStockChanged(
    _StockChanged event,
    Emitter<InventoryStockState> emit,
  ) async {
    final stock = Stock.dirty(event.stock);

    emit(
      state.copyWith(
        stock: stock,
      ),
    );
  }

  Future<void> _onExpirationChanged(
    _ExpirationChanged event,
    Emitter<InventoryStockState> emit,
  ) async {
    emit(
      state.copyWith(
        expiration: event.expiration,
      ),
    );
  }

  Future<void> _onSubmitted(
    _Submitted event,
    Emitter<InventoryStockState> emit,
  ) async {
    final stock = Stock.dirty(state.stock.value);

    final isValid = Formz.validate([
      stock,
    ]);

    if (!isValid) {
      emit(
        state.copyWith(
          stock: stock,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: LoadingStatus.loading,
      ),
    );

    try {
      final parsedQuantity = double.parse(stock.value);

      final batch = StockBatch(
        id: '',
        itemId: state.item.id,
        quantity: parsedQuantity,
        baseQuantity: parsedQuantity,
        expirationDate: state.expiration,
      );

      final newBatch = await _inventoryRepository.addBatch(batch);
      final updatedItem = state.item.copyWith(
        stockBatches: [...state.item.stockBatches, newBatch],
      );

      await _inventoryRepository.syncItem(updatedItem);

      emit(
        state.copyWith(
          status: LoadingStatus.success,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: LoadingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
