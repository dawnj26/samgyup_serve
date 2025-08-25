import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:samgyup_serve/shared/stream.dart';

part 'ingredient_select_event.dart';
part 'ingredient_select_state.dart';
part 'ingredient_select_bloc.freezed.dart';

class IngredientSelectBloc
    extends Bloc<IngredientSelectEvent, IngredientSelectState> {
  IngredientSelectBloc({
    required List<Ingredient> selectedIngredients,
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(
         IngredientSelectInitial(
           selectedIngredients: selectedIngredients,
         ),
       ) {
    on<_Started>(_onStarted);
    on<_LoadMore>(
      _onLoadMore,
      transformer: throttleDroppable(
        const Duration(milliseconds: 300),
      ),
    );
  }

  final InventoryRepository _inventoryRepository;
  final int _pageSize = 20;

  Future<void> _onStarted(
    _Started event,
    Emitter<IngredientSelectState> emit,
  ) async {
    try {
      emit(
        IngredientSelectLoading(
          selectedIngredients: state.selectedIngredients,
          items: state.items,
          hasReachedMax: state.hasReachedMax,
        ),
      );

      final items = await _inventoryRepository.fetchItems(
        limit: _pageSize,
      );

      emit(
        IngredientSelectLoaded(
          selectedIngredients: state.selectedIngredients,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        IngredientSelectFailure(
          selectedIngredients: state.selectedIngredients,
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          errorMessage: e.message,
        ),
      );
    } on Exception {
      emit(
        IngredientSelectFailure(
          selectedIngredients: state.selectedIngredients,
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          errorMessage: 'Failed to load ingredients.',
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    _LoadMore event,
    Emitter<IngredientSelectState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final lastDocumentId = state.items.isNotEmpty
          ? state.items.last.id
          : null;

      final items = await _inventoryRepository.fetchItems(
        lastDocumentId: lastDocumentId,
        limit: _pageSize,
      );

      emit(
        IngredientSelectLoaded(
          selectedIngredients: state.selectedIngredients,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        IngredientSelectFailure(
          selectedIngredients: state.selectedIngredients,
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          errorMessage: e.message,
        ),
      );
    } on Exception {
      emit(
        IngredientSelectFailure(
          selectedIngredients: state.selectedIngredients,
          items: state.items,
          hasReachedMax: state.hasReachedMax,
          errorMessage: 'Failed to load more ingredients.',
        ),
      );
    }
  }
}
