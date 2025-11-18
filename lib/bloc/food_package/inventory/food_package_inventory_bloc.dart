import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_repository/package_repository.dart';

part 'food_package_inventory_bloc.freezed.dart';
part 'food_package_inventory_event.dart';
part 'food_package_inventory_state.dart';

class FoodPackageInventoryBloc
    extends Bloc<FoodPackageInventoryEvent, FoodPackageInventoryState> {
  FoodPackageInventoryBloc({
    required PackageRepository packageRepository,
    required String packageId,
  }) : _packageRepository = packageRepository,
       _packageId = packageId,
       super(const FoodPackageInventoryState.initial()) {
    on<_Started>(_onStarted);
  }

  final PackageRepository _packageRepository;
  final String _packageId;

  Future<void> _onStarted(
    _Started event,
    Emitter<FoodPackageInventoryState> emit,
  ) async {
    emit(const FoodPackageInventoryLoading());
    try {
      await _packageRepository.updateMenuIds(
        packageId: _packageId,
        menuIds: event.menuIds,
      );
      emit(const FoodPackageInventorySuccess());
    } on ResponseException catch (e) {
      emit(FoodPackageInventoryFailure(errorMessage: e.message));
    } on Exception catch (e) {
      emit(FoodPackageInventoryFailure(errorMessage: e.toString()));
    }
  }
}
