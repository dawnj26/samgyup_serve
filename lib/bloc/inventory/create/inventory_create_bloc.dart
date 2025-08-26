import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart' as i;
import 'package:samgyup_serve/shared/form/inventory/category.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/inventory/low_stock_threshold.dart';
import 'package:samgyup_serve/shared/form/inventory/measurement_unit.dart';
import 'package:samgyup_serve/shared/form/inventory/stock.dart';
import 'package:samgyup_serve/shared/form/name.dart';

part 'inventory_create_bloc.freezed.dart';
part 'inventory_create_event.dart';
part 'inventory_create_state.dart';

class InventoryCreateBloc
    extends Bloc<InventoryCreateEvent, InventoryCreateState> {
  InventoryCreateBloc({
    required i.InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(const InventoryCreateInitial()) {
    on<_NameChanged>(_onNameChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_CategoryChanged>(_onCategoryChanged);
    on<_StockChanged>(_onStockChanged);
    on<_LowStockThresholdChanged>(_onLowStockThresholdChanged);
    on<_MeasurementUnitChanged>(_onMeasurementUnitChanged);
    on<_ExpirationChanged>(_onExpirationChanged);
    on<_Saved>(_onSaved);
  }

  final i.InventoryRepository _inventoryRepository;

  Future<void> _onSaved(
    _Saved event,
    Emitter<InventoryCreateState> emit,
  ) async {
    final name = Name.dirty(state.name.value);
    final description = Description.dirty(state.description.value);
    final category = Category.dirty(state.category.value);
    final stock = Stock.dirty(state.stock.value);
    final lowStockThreshold = LowStockThreshold.dirty(
      state.lowStockThreshold.value,
    );
    final measurementUnit = MeasurementUnit.dirty(state.measurementUnit.value);

    final isValid = Formz.validate([
      name,
      description,
      category,
      stock,
      lowStockThreshold,
      measurementUnit,
    ]);

    if (!isValid) {
      emit(
        InventoryCreateDirty(
          expiration: state.expiration,
          measurementUnit: measurementUnit,
          category: category,
          name: name,
          stock: stock,
          lowStockThreshold: lowStockThreshold,
          description: description,
        ),
      );
      return;
    }

    emit(
      InventoryCreateLoading(
        expiration: state.expiration,
        measurementUnit: measurementUnit,
        category: category,
        name: name,
        stock: stock,
        lowStockThreshold: lowStockThreshold,
        description: description,
      ),
    );

    try {
      final parsedStock = double.tryParse(stock.value);
      final parsedLowStockThreshold = double.tryParse(lowStockThreshold.value);

      await _inventoryRepository.addItem(
        i.InventoryItem(
          id: '',
          name: name.value,
          description: description.value,
          category: category.value!,
          stock: parsedStock ?? 0,
          lowStockThreshold: parsedLowStockThreshold ?? 0,
          unit: measurementUnit.value!,
          expirationDate: state.expiration,
          createdAt: DateTime.now(),
        ),
      );
      emit(
        const InventoryCreateSuccess(),
      );
    } on Exception catch (e) {
      emit(
        InventoryCreateFailure(
          expiration: state.expiration,
          measurementUnit: measurementUnit,
          category: category,
          name: name,
          stock: stock,
          lowStockThreshold: lowStockThreshold,
          description: description,
          message: e.toString(),
        ),
      );
    }
  }

  void _onNameChanged(_NameChanged event, Emitter<InventoryCreateState> emit) {
    final name = Name.dirty(event.name);
    emit(
      InventoryCreateDirty(
        expiration: state.expiration,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: name,
        stock: state.stock,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
      ),
    );
  }

  void _onDescriptionChanged(
    _DescriptionChanged event,
    Emitter<InventoryCreateState> emit,
  ) {
    final description = Description.dirty(event.description);
    emit(
      InventoryCreateDirty(
        expiration: state.expiration,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        stock: state.stock,
        lowStockThreshold: state.lowStockThreshold,
        description: description,
      ),
    );
  }

  void _onCategoryChanged(
    _CategoryChanged event,
    Emitter<InventoryCreateState> emit,
  ) {
    final category = Category.dirty(event.category);
    emit(
      InventoryCreateDirty(
        expiration: state.expiration,
        measurementUnit: state.measurementUnit,
        category: category,
        name: state.name,
        stock: state.stock,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
      ),
    );
  }

  void _onStockChanged(
    _StockChanged event,
    Emitter<InventoryCreateState> emit,
  ) {
    final stock = Stock.dirty(event.stock);
    emit(
      InventoryCreateDirty(
        expiration: state.expiration,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        stock: stock,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
      ),
    );
  }

  void _onLowStockThresholdChanged(
    _LowStockThresholdChanged event,
    Emitter<InventoryCreateState> emit,
  ) {
    final lowStockThreshold = LowStockThreshold.dirty(
      event.lowStockThreshold,
    );
    emit(
      InventoryCreateDirty(
        expiration: state.expiration,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        stock: state.stock,
        lowStockThreshold: lowStockThreshold,
        description: state.description,
      ),
    );
  }

  void _onMeasurementUnitChanged(
    _MeasurementUnitChanged event,
    Emitter<InventoryCreateState> emit,
  ) {
    final measurementUnit = MeasurementUnit.dirty(event.measurementUnit);
    emit(
      InventoryCreateDirty(
        expiration: state.expiration,
        measurementUnit: measurementUnit,
        category: state.category,
        name: state.name,
        stock: state.stock,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
      ),
    );
  }

  void _onExpirationChanged(
    _ExpirationChanged event,
    Emitter<InventoryCreateState> emit,
  ) {
    final expiration = event.expiration;
    emit(
      InventoryCreateDirty(
        expiration: expiration,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        stock: state.stock,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
      ),
    );
  }
}
