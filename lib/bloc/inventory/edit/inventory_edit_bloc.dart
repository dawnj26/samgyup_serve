import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/form/inventory/category.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/inventory/expiration.dart';
import 'package:samgyup_serve/shared/form/inventory/low_stock_threshold.dart';
import 'package:samgyup_serve/shared/form/inventory/measurement_unit.dart' as m;
import 'package:samgyup_serve/shared/form/inventory/name.dart';
import 'package:samgyup_serve/shared/form/inventory/stock.dart';

part 'inventory_edit_event.dart';
part 'inventory_edit_state.dart';
part 'inventory_edit_bloc.freezed.dart';

class InventoryEditBloc extends Bloc<InventoryEditEvent, InventoryEditState> {
  InventoryEditBloc({
    required InventoryRepository inventoryRepository,
    required InventoryItem item,
  }) : _inventoryRepository = inventoryRepository,
       _item = item,
       super(
         InventoryEditInitial(
           expiration: item.expirationDate,
           measurementUnit: m.MeasurementUnit.pure(item.unit),
           category: Category.pure(item.category),
           name: Name.pure(item.name),
           stock: Stock.pure(item.stock.toString()),
           lowStockThreshold: LowStockThreshold.pure(
             item.lowStockThreshold.toString(),
           ),
           description: Description.pure(item.description ?? ''),
         ),
       ) {
    on<_NameChanged>(_onNameChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_CategoryChanged>(_onCategoryChanged);
    on<_StockChanged>(_onStockChanged);
    on<_LowStockThresholdChanged>(_onLowStockThresholdChanged);
    on<_MeasurementUnitChanged>(_onMeasurementUnitChanged);
    on<_ExpirationChanged>(_onExpirationChanged);
    on<_Saved>(_onSaved);
  }

  final InventoryRepository _inventoryRepository;
  final InventoryItem _item;

  Future<void> _onSaved(
    _Saved event,
    Emitter<InventoryEditState> emit,
  ) async {
    final name = Name.dirty(state.name.value);
    final description = Description.dirty(state.description.value);
    final category = Category.dirty(state.category.value);
    final stock = Stock.dirty(state.stock.value);
    final lowStockThreshold = LowStockThreshold.dirty(
      double.tryParse(state.stock.value) ?? -1,
      state.lowStockThreshold.value,
    );
    final measurementUnit = m.MeasurementUnit.dirty(
      state.measurementUnit.value,
    );

    final isValid = Formz.validate([
      name,
      description,
      category,
      stock,
      lowStockThreshold,
      measurementUnit,
      expiration,
    ]);

    if (!isValid) {
      emit(
        InventoryEditDirty(
          expiration: expiration,
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
      InventoryEditLoading(
        expiration: expiration,
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
          expirationDate: expiration.value,
          createdAt: DateTime.now(),
        ),
      );
      emit(
        const InventoryEditSuccess(),
      );
    } on Exception catch (e) {
      emit(
        InventoryEditFailure(
          expiration: expiration,
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

  void _onNameChanged(_NameChanged event, Emitter<InventoryEditState> emit) {
    final name = Name.dirty(event.name);
    emit(
      InventoryEditDirty(
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
    Emitter<InventoryEditState> emit,
  ) {
    final description = Description.dirty(event.description);
    emit(
      InventoryEditDirty(
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
    Emitter<InventoryEditState> emit,
  ) {
    final category = Category.dirty(event.category);
    emit(
      InventoryEditDirty(
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
    Emitter<InventoryEditState> emit,
  ) {
    final stock = Stock.dirty(event.stock);
    emit(
      InventoryEditDirty(
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
    Emitter<InventoryEditState> emit,
  ) {
    final lowStockThreshold = LowStockThreshold.dirty(
      double.tryParse(state.stock.value) ?? -1,
      event.lowStockThreshold,
    );
    emit(
      InventoryEditDirty(
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
    Emitter<InventoryEditState> emit,
  ) {
    final measurementUnit = m.MeasurementUnit.dirty(event.measurementUnit);
    emit(
      InventoryEditDirty(
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
    Emitter<InventoryEditState> emit,
  ) {
    final expiration = Expiration.dirty(event.expiration);
    emit(
      InventoryEditDirty(
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
