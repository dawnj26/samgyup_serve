import 'dart:io';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart' as i;
import 'package:samgyup_serve/shared/form/inventory/category.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/inventory/low_stock_threshold.dart';
import 'package:samgyup_serve/shared/form/inventory/measurement_unit.dart';
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/price.dart';

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
    on<_LowStockThresholdChanged>(_onLowStockThresholdChanged);
    on<_MeasurementUnitChanged>(_onMeasurementUnitChanged);
    on<_Saved>(_onSaved);
    on<_PriceChanged>(_onPriceChanged);
    on<_ImageChanged>(_onImageChanged);
  }

  final i.InventoryRepository _inventoryRepository;

  void _onImageChanged(
    _ImageChanged event,
    Emitter<InventoryCreateState> emit,
  ) {
    emit(
      InventoryCreateDirty(
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
    Emitter<InventoryCreateState> emit,
  ) {
    final price = Price.dirty(event.price);
    emit(
      InventoryCreateDirty(
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
    Emitter<InventoryCreateState> emit,
  ) async {
    final name = Name.dirty(state.name.value);
    final description = Description.dirty(state.description.value);
    final category = Category.dirty(state.category.value);
    final lowStockThreshold = LowStockThreshold.dirty(
      state.lowStockThreshold.value,
    );
    final measurementUnit = MeasurementUnit.dirty(state.measurementUnit.value);
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
        InventoryCreateDirty(
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
      InventoryCreateLoading(
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
          : null;

      await _inventoryRepository.addItem(
        i.InventoryItem(
          id: '',
          name: name.value,
          description: description.value,
          category: category.value!,
          lowStockThreshold: parsedLowStockThreshold ?? 0,
          unit: measurementUnit.value!,
          createdAt: DateTime.now(),
          price: double.parse(price.value),
          imageId: imageId,
        ),
      );
      emit(
        const InventoryCreateSuccess(),
      );
    } on Exception catch (e) {
      emit(
        InventoryCreateFailure(
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

  void _onNameChanged(_NameChanged event, Emitter<InventoryCreateState> emit) {
    final name = Name.dirty(event.name);
    emit(
      InventoryCreateDirty(
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
    Emitter<InventoryCreateState> emit,
  ) {
    final description = Description.dirty(event.description);
    emit(
      InventoryCreateDirty(
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
    Emitter<InventoryCreateState> emit,
  ) {
    final category = Category.dirty(event.category);
    emit(
      InventoryCreateDirty(
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
    Emitter<InventoryCreateState> emit,
  ) {
    final lowStockThreshold = LowStockThreshold.dirty(
      event.lowStockThreshold,
    );
    emit(
      InventoryCreateDirty(
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
    Emitter<InventoryCreateState> emit,
  ) {
    final measurementUnit = MeasurementUnit.dirty(event.measurementUnit);
    emit(
      InventoryCreateDirty(
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
