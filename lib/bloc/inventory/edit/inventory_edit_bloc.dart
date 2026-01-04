import 'dart:async';

import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:log_repository/log_repository.dart';
import 'package:samgyup_serve/shared/form/inventory/category.dart';
import 'package:samgyup_serve/shared/form/inventory/description.dart';
import 'package:samgyup_serve/shared/form/inventory/low_stock_threshold.dart';
import 'package:samgyup_serve/shared/form/inventory/measurement_unit.dart';
import 'package:samgyup_serve/shared/form/name.dart';
import 'package:samgyup_serve/shared/form/per_head.dart';
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
           perHead: PerHead.pure(item.perHead.toString()),
           measurementUnit: MeasurementUnitInput.pure(item.unit),
           category: Category.pure(item.category),
           name: Name.pure(item.name),
           lowStockThreshold: LowStockThreshold.pure(
             item.lowStockThreshold.toString(),
           ),
           description: Description.pure(item.description ?? ''),
           price: Price.pure(item.price.toString()),
           categories: const [],
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
    on<_SubcategoryChanged>(_onSubcategoryChanged);
    on<_Started>(_onStarted);
    on<_PerHeadChanged>(_onPerHeadChanged);
  }

  final InventoryRepository _inventoryRepository;
  final InventoryItem _item;

  void _onImageChanged(
    _ImageChanged event,
    Emitter<InventoryEditState> emit,
  ) {
    emit(
      InventoryEditDirty(
        perHead: state.perHead,
        subcategories: state.subcategories,
        subcategory: state.subcategory,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: event.imageFile,
        categories: state.categories,
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
        perHead: state.perHead,
        subcategories: state.subcategories,
        subcategory: state.subcategory,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: price,
        imageFile: state.imageFile,
        categories: state.categories,
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
    final measurementUnit = MeasurementUnitInput.dirty(
      state.measurementUnit.value,
    );
    final price = Price.dirty(state.price.value);
    final perHead = PerHead.dirty(state.perHead.value);

    final isValid = Formz.validate([
      name,
      description,
      category,
      lowStockThreshold,
      measurementUnit,
      price,
      perHead,
    ]);

    if (!isValid) {
      emit(
        InventoryEditDirty(
          perHead: perHead,
          subcategories: state.subcategories,
          subcategory: state.subcategory,
          measurementUnit: measurementUnit,
          category: category,
          name: name,
          lowStockThreshold: lowStockThreshold,
          description: description,
          price: price,
          imageFile: state.imageFile,
          categories: state.categories,
        ),
      );
      return;
    }

    emit(
      InventoryEditLoading(
        perHead: perHead,
        subcategories: state.subcategories,
        subcategory: state.subcategory,
        measurementUnit: measurementUnit,
        category: category,
        name: name,
        lowStockThreshold: lowStockThreshold,
        description: description,
        price: price,
        imageFile: state.imageFile,
        categories: state.categories,
      ),
    );

    try {
      final parsedLowStockThreshold = double.tryParse(lowStockThreshold.value);
      final parsedPerHead = double.parse(perHead.value);
      final imageId = state.imageFile != null
          ? await AppwriteRepository.instance.uploadFile(state.imageFile!)
          : _item.imageId;

      final updatedItem = _item.copyWith(
        perHead: parsedPerHead,
        name: name.value,
        description: description.value,
        category: category.value!,
        lowStockThreshold: parsedLowStockThreshold ?? 0,
        unit: measurementUnit.value!,
        price: double.parse(price.value),
        imageId: imageId,
        tagId: state.subcategory?.id,
      );

      if (updatedItem == _item && state.imageFile == null) {
        return emit(const InventoryEditNoChanges(categories: []));
      }

      await _inventoryRepository.updateItem(updatedItem);

      await LogRepository.instance.logAction(
        action: LogAction.update,
        message: 'Inventory item updated: ${updatedItem.name}',
        resourceId: updatedItem.id,
        details:
            'Inventory Item ID: ${updatedItem.id}, '
            'Name: ${updatedItem.name}',
      );

      emit(
        InventoryEditSuccess(item: updatedItem, categories: state.categories),
      );
    } on Exception catch (e) {
      emit(
        InventoryEditFailure(
          perHead: perHead,
          subcategories: state.subcategories,
          subcategory: state.subcategory,
          measurementUnit: measurementUnit,
          category: category,
          name: name,
          lowStockThreshold: lowStockThreshold,
          description: description,
          price: price,
          message: e.toString(),
          imageFile: state.imageFile,
          categories: state.categories,
        ),
      );
    }
  }

  void _onNameChanged(_NameChanged event, Emitter<InventoryEditState> emit) {
    final name = Name.dirty(event.name);
    emit(
      InventoryEditDirty(
        perHead: state.perHead,
        subcategories: state.subcategories,
        subcategory: state.subcategory,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
        categories: state.categories,
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
        perHead: state.perHead,
        subcategories: state.subcategories,
        subcategory: state.subcategory,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: description,
        price: state.price,
        imageFile: state.imageFile,
        categories: state.categories,
      ),
    );
  }

  Future<void> _onCategoryChanged(
    _CategoryChanged event,
    Emitter<InventoryEditState> emit,
  ) async {
    final category = Category.dirty(event.category);
    emit(
      InventoryEditLoadingSubcategories(
        perHead: state.perHead,
        subcategories: state.subcategories,
        measurementUnit: state.measurementUnit,
        category: category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
        categories: state.categories,
      ),
    );

    try {
      final subcategories = await _inventoryRepository.fetchSubcategories(
        category: event.category,
      );

      emit(
        InventoryEditLoadedSubcategories(
          perHead: state.perHead,
          subcategories: subcategories,
          measurementUnit: state.measurementUnit,
          category: category,
          name: state.name,
          lowStockThreshold: state.lowStockThreshold,
          description: state.description,
          price: state.price,
          imageFile: state.imageFile,
          categories: state.categories,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        InventoryEditFailure(
          perHead: state.perHead,
          subcategories: state.subcategories,
          subcategory: state.subcategory,
          measurementUnit: state.measurementUnit,
          category: category,
          name: state.name,
          lowStockThreshold: state.lowStockThreshold,
          description: state.description,
          price: state.price,
          message: e.message,
          imageFile: state.imageFile,
          categories: state.categories,
        ),
      );
    } on Exception catch (e) {
      emit(
        InventoryEditFailure(
          perHead: state.perHead,
          subcategories: state.subcategories,
          subcategory: state.subcategory,
          measurementUnit: state.measurementUnit,
          category: category,
          name: state.name,
          lowStockThreshold: state.lowStockThreshold,
          description: state.description,
          price: state.price,
          message: e.toString(),
          imageFile: state.imageFile,
          categories: state.categories,
        ),
      );
    }
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
        perHead: state.perHead,
        subcategories: state.subcategories,
        subcategory: state.subcategory,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
        categories: state.categories,
      ),
    );
  }

  void _onMeasurementUnitChanged(
    _MeasurementUnitChanged event,
    Emitter<InventoryEditState> emit,
  ) {
    final measurementUnit = MeasurementUnitInput.dirty(event.measurementUnit);
    emit(
      InventoryEditDirty(
        perHead: state.perHead,
        subcategories: state.subcategories,
        subcategory: state.subcategory,
        measurementUnit: measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
        categories: state.categories,
      ),
    );
  }

  FutureOr<void> _onSubcategoryChanged(
    _SubcategoryChanged event,
    Emitter<InventoryEditState> emit,
  ) {
    emit(
      InventoryEditDirty(
        perHead: state.perHead,
        subcategories: state.subcategories,
        subcategory: event.subcategory,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
        categories: state.categories,
      ),
    );
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<InventoryEditState> emit,
  ) async {
    try {
      emit(
        InventoryEditInitializing(
          perHead: state.perHead,
          subcategories: state.subcategories,
          measurementUnit: state.measurementUnit,
          category: state.category,
          name: state.name,
          lowStockThreshold: state.lowStockThreshold,
          description: state.description,
          price: state.price,
          imageFile: state.imageFile,
          categories: state.categories,
        ),
      );

      final subcategories = await _inventoryRepository.fetchSubcategories(
        category: _item.category,
      );
      final subcategory = _item.tagId == null
          ? null
          : await _inventoryRepository.fetchSubcategory(id: _item.tagId!);

      final categories = [
        ...InventoryCategory.values.map((e) => e.name),
        ...(await _inventoryRepository.fetchCategories()).map(
          (e) => e.name,
        ),
      ];

      emit(
        InventoryEditInitialized(
          perHead: state.perHead,
          subcategories: subcategories,
          subcategory: subcategory,
          measurementUnit: state.measurementUnit,
          category: state.category,
          name: state.name,
          lowStockThreshold: state.lowStockThreshold,
          description: state.description,
          price: state.price,
          imageFile: state.imageFile,
          categories: categories,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        InventoryEditFailure(
          perHead: state.perHead,
          subcategories: state.subcategories,
          subcategory: state.subcategory,
          measurementUnit: state.measurementUnit,
          category: state.category,
          name: state.name,
          lowStockThreshold: state.lowStockThreshold,
          description: state.description,
          price: state.price,
          message: e.message,
          imageFile: state.imageFile,
          categories: state.categories,
        ),
      );
    } on Exception catch (e) {
      emit(
        InventoryEditFailure(
          perHead: state.perHead,
          subcategories: state.subcategories,
          subcategory: state.subcategory,
          measurementUnit: state.measurementUnit,
          category: state.category,
          name: state.name,
          lowStockThreshold: state.lowStockThreshold,
          description: state.description,
          price: state.price,
          message: e.toString(),
          imageFile: state.imageFile,
          categories: state.categories,
        ),
      );
    }
  }

  FutureOr<void> _onPerHeadChanged(
    _PerHeadChanged event,
    Emitter<InventoryEditState> emit,
  ) async {
    final perHead = PerHead.dirty(event.perHead);
    emit(
      InventoryEditDirty(
        perHead: perHead,
        subcategories: state.subcategories,
        subcategory: state.subcategory,
        measurementUnit: state.measurementUnit,
        category: state.category,
        name: state.name,
        lowStockThreshold: state.lowStockThreshold,
        description: state.description,
        price: state.price,
        imageFile: state.imageFile,
        categories: state.categories,
      ),
    );
  }
}
