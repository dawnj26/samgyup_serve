import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:menu_repository/menu_repository.dart';

part 'menu_details_event.dart';
part 'menu_details_state.dart';
part 'menu_details_bloc.freezed.dart';

class MenuDetailsBloc extends Bloc<MenuDetailsEvent, MenuDetailsState> {
  MenuDetailsBloc({
    required MenuRepository menuRepository,
    required MenuItem menuItem,
    required InventoryRepository inventoryRepository,
  }) : _menuRepository = menuRepository,
       _inventoryRepository = inventoryRepository,
       super(
         MenuDetailsInitial(
           menuItem: menuItem,
         ),
       ) {
    on<_Started>(_onStarted);
    on<_Reloaded>(_onIngredientsReloaded);
    on<_MenuReloaded>(_onMenuReloaded);
    on<_StockUpdated>(_onStockUpdated);
  }

  final MenuRepository _menuRepository;
  final InventoryRepository _inventoryRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<MenuDetailsState> emit,
  ) async {
    emit(
      MenuDetailsState.loading(
        menuItem: state.menuItem,
        ingredients: state.ingredients,
        isDirty: state.isDirty,
      ),
    );

    try {
      final ingredients = await _menuRepository.fetchIngredients(
        state.menuItem.id,
      );
      final inventoryIds = ingredients.map((e) => e.inventoryItemId).toList();
      final inventoryItems = await _inventoryRepository.fetchItems(
        itemIds: inventoryIds,
      );
      final inventoryItemsMap = {
        for (final item in inventoryItems) item.id: item,
      };

      emit(
        MenuDetailsState.loaded(
          menuItem: state.menuItem,
          ingredients: ingredients,
          inventoryItems: inventoryItemsMap,
          isDirty: state.isDirty,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.message,
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: state.isDirty,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.toString(),
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: state.isDirty,
        ),
      );
    }
  }

  Future<void> _onIngredientsReloaded(
    _Reloaded event,
    Emitter<MenuDetailsState> emit,
  ) async {
    emit(
      MenuDetailsState.loading(
        menuItem: state.menuItem,
        ingredients: state.ingredients,
        inventoryItems: state.inventoryItems,
        isDirty: state.isDirty,
      ),
    );

    try {
      final ingredients = await _menuRepository.fetchIngredients(
        state.menuItem.id,
      );
      final menuItem = await _menuRepository.fetchItem(
        state.menuItem.id,
      );
      final inventoryIds = ingredients.map((e) => e.inventoryItemId).toList();
      final inventoryItems = await _inventoryRepository.fetchItems(
        itemIds: inventoryIds,
      );
      final inventoryItemsMap = {
        for (final item in inventoryItems) item.id: item,
      };

      emit(
        MenuDetailsState.loaded(
          menuItem: menuItem,
          ingredients: ingredients,
          inventoryItems: inventoryItemsMap,
          isDirty: true,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.message,
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: state.isDirty,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.toString(),
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: state.isDirty,
        ),
      );
    }
  }

  Future<void> _onMenuReloaded(
    _MenuReloaded event,
    Emitter<MenuDetailsState> emit,
  ) async {
    try {
      final menuItem = await _menuRepository.fetchItem(
        state.menuItem.id,
      );

      emit(
        MenuDetailsState.loaded(
          menuItem: menuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: true,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.message,
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: state.isDirty,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.toString(),
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: state.isDirty,
        ),
      );
    }
  }

  Future<void> _onStockUpdated(
    _StockUpdated event,
    Emitter<MenuDetailsState> emit,
  ) async {
    emit(
      MenuDetailsState.updating(
        menuItem: state.menuItem,
        ingredients: state.ingredients,
        inventoryItems: state.inventoryItems,
        isDirty: state.isDirty,
      ),
    );

    try {
      final updatedMenuItem = await _menuRepository.updateMenu(
        menu: state.menuItem.copyWith(
          stock: event.newStock,
        ),
      );
      // Decrement stock of associated inventory items if stock is reduced
      for (final ingredient in state.ingredients) {
        final inventoryItem = state.inventoryItems[ingredient.inventoryItemId];
        if (inventoryItem == null) continue;

        final decrementValue = ingredient.quantity * event.newStock;
        if (decrementValue > 0) {
          await _inventoryRepository.decrementStock(
            itemId: inventoryItem.id,
            quantity: decrementValue.toInt(),
          );
        }
      }

      emit(
        MenuDetailsState.updated(
          menuItem: updatedMenuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: true,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.message,
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: state.isDirty,
        ),
      );
    } on Exception catch (e) {
      emit(
        MenuDetailsState.error(
          message: e.toString(),
          menuItem: state.menuItem,
          ingredients: state.ingredients,
          inventoryItems: state.inventoryItems,
          isDirty: state.isDirty,
        ),
      );
    }
  }
}
