import 'dart:io';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/form/inventory/category.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/inventory/low_stock_threshold.dart';
import 'package:samgyup_serve/shared/form/inventory/measurement_unit.dart' as m;
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';

part 'inventory_edit_bloc.freezed.dart';
part 'inventory_edit_event.dart';
part 'inventory_edit_state.dart';

class InventoryEditBloc extends Bloc<InventoryEditEvent, InventoryEditState> {
  InventoryEditBloc({
    required InventoryRepository inventoryRepository,
    required InventoryItem item,
  }) : _inventoryRepository = inventoryRepository,
       _item = item,
       super(
         InventoryEditInitial(
           measurementUnit: m.MeasurementUnit.pure(item.unit),
           category: Category.pure(item.category),
           name: Name.pure(item.name),
           lowStockThreshold: LowStockThreshold.pure(
             item.lowStockThreshold.toString(),
           ),
           description: Description.pure(item.description ?? ''),
           price: Price.pure(item.price.toString()),
         ),
       ) {
    on<_NameChanged>(_onNameChanged);
    on<_DescriptionChanged>(_onDescriptionChanged);
    on<_CategoryChanged>(_onCategoryChanged);
    on<_LowStockThresholdChanged>(_onLowStockThresholdChanged);
    on<_MeasurementUnitChanged>(_onMeasurementUnitChanged);
    on<_Saved>(_onSaved);
    on<_PriceChanged>(_onPriceChanged);
    on<_ImageChanged>(_onImageChanged);
  }

  final InventoryRepository _inventoryRepository;
  final InventoryItem _item;

  void _onImageChanged(
    _ImageChanged event,
    Emitter<InventoryEditState> emit,
  ) {
    emit(
      InventoryEditDirty(
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: event.imageFile,
      ),
    );
  }

  void _onPriceChanged(
    _PriceChanged event,
    Emitter<InventoryEditState> emit,
  ) {
    final price = Price.dirty(event.price);
    emit(
      InventoryEditDirty(
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: price,
        imageFile: state.imageFile,
      ),
    );
  }

  Future<void> _onSaved(
    _Saved event,
    Emitter<InventoryEditState> emit,
  ) async {
    final name = Name.dirty(state.name.value);
    final description = Description.dirty(state.description.value);
    final category = Category.dirty(state.category.value);
    final lowStockThreshold = LowStockThreshold.dirty(
      state.lowStockThreshold.value,
    );
    final measurementUnit = m.MeasurementUnit.dirty(
      state.measurementUnit.value,
    );
    final price = Price.dirty(state.price.value);

    final isValid = Formz.validate([
      name,
      description,
      category,
      lowStockThreshold,
      measurementUnit,
      price,
    ]);

    if (!isValid) {
      emit(
        InventoryEditDirty(
          measurementUnit: measurementUnit,
          category: category,
          name: name,
          lowStockThreshold: lowStockThreshold,
          description: description,
          price: price,
          imageFile: state.imageFile,
        ),
      );
      return;
    }

    emit(
      InventoryEditLoading(
        measurementUnit: measurementUnit,
        category: category,
        name: name,
        lowStockThreshold: lowStockThreshold,
        description: description,
        price: price,
        imageFile: state.imageFile,
      ),
    );

    try {
      final parsedLowStockThreshold = double.tryParse(lowStockThreshold.value);
      final imageId = state.imageFile != null
          ? await AppwriteRepository.instance.uploadFile(state.imageFile!)
          : _item.imageId;

      final updatedItem = _item.copyWith(
        name: name.value,
        description: description.value,
        category: category.value!,
        lowStockThreshold: parsedLowStockThreshold ?? 0,
        unit: measurementUnit.value!,
        price: double.parse(price.value),
        imageId: imageId,
      );

      if (updatedItem == _item && state.imageFile == null) {
        return emit(const InventoryEditNoChanges());
      }

      await _inventoryRepository.updateItem(updatedItem);
      emit(
        InventoryEditSuccess(item: updatedItem),
      );
    } on Exception catch (e) {
      emit(
        InventoryEditFailure(
          measurementUnit: measurementUnit,
          category: category,
          name: name,
          lowStockThreshold: lowStockThreshold,
          description: description,
          price: price,
          message: e.toString(),
          imageFile: state.imageFile,
        ),
      );
    }
  }

  void _onNameChanged(_NameChanged event, Emitter<InventoryEditState> emit) {
    final name = Name.dirty(event.name);
    emit(
      InventoryEditDirty(
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
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
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: description,
        price: state.price,
        imageFile: state.imageFile,
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
        measurementUnit: state.measurementUnit,
        category: category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
      ),
    );
  }

  void _onLowStockThresholdChanged(
    _LowStockThresholdChanged event,
    Emitter<InventoryEditState> emit,
  ) {
    final lowStockThreshold = LowStockThreshold.dirty(
      event.lowStockThreshold,
    );
    emit(
      InventoryEditDirty(
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
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
        measurementUnit: measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
      ),
    );
  }
}
