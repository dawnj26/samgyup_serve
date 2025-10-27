import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';
import 'package:samgyup_serve/shared/form/inventory/low_stock_threshold.dart';
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
    on<_LowStockThresholdChanged>(_onLowStockThresholdChanged);
    on<_ExpirationChanged>(_onExpirationChanged);
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

  Future<void> _onLowStockThresholdChanged(
    _LowStockThresholdChanged event,
    Emitter<InventoryStockState> emit,
  ) async {
    final lowStockThreshold = LowStockThreshold.dirty(event.lowStockThreshold);

    emit(
      state.copyWith(
        lowStockThreshold: lowStockThreshold,
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
}
