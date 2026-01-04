import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:samgyup_serve/shared/enums/loading_status.dart';

part 'subcategory_bloc.freezed.dart';
part 'subcategory_event.dart';
part 'subcategory_state.dart';

class SubcategoryBloc extends Bloc<SubcategoryEvent, SubcategoryState> {
  SubcategoryBloc({
    required String category,
    required InventoryRepository inventoryRepository,
  }) : _inventoryRepository = inventoryRepository,
       super(
         _Initial(
           category: category,
         ),
       ) {
    on<_Started>(_onStarted);
  }
  final InventoryRepository _inventoryRepository;

  Future<void> _onStarted(
    _Started event,
    Emitter<SubcategoryState> emit,
  ) async {
    try {
      emit(state.copyWith(status: LoadingStatus.loading));

      final subcategories = await _inventoryRepository.fetchSubcategories(
        category: state.category,
      );
      emit(
        state.copyWith(
          status: LoadingStatus.success,
          subcategories: subcategories,
          isDirty: event.isChanged,
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
