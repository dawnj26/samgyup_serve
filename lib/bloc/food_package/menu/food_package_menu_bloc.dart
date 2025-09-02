import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_repository/package_repository.dart';

part 'food_package_menu_bloc.freezed.dart';
part 'food_package_menu_event.dart';
part 'food_package_menu_state.dart';

class FoodPackageMenuBloc
    extends Bloc<FoodPackageMenuEvent, FoodPackageMenuState> {
  FoodPackageMenuBloc({
    required PackageRepository packageRepository,
    required String packageId,
  }) : _packageRepository = packageRepository,
       _packageId = packageId,
       super(const FoodPackageMenuState.initial()) {
    on<_Started>(_onStarted);
  }

  final PackageRepository _packageRepository;
  final String _packageId;

  Future<void> _onStarted(
    _Started event,
    Emitter<FoodPackageMenuState> emit,
  ) async {
    emit(const FoodPackageMenuLoading());

    try {
      await _packageRepository.updateMenuIds(
        packageId: _packageId,
        menuIds: event.menuIds,
      );
      emit(const FoodPackageMenuSuccess());
    } on ResponseException catch (e) {
      emit(FoodPackageMenuFailure(errorMessage: e.message));
    } on Exception catch (e) {
      emit(FoodPackageMenuFailure(errorMessage: e.toString()));
    }
  }
}
