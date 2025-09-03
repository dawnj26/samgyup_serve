import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';
import 'package:package_repository/package_repository.dart';

part 'food_package_details_bloc.freezed.dart';
part 'food_package_details_event.dart';
part 'food_package_details_state.dart';

class FoodPackageDetailsBloc
    extends Bloc<FoodPackageDetailsEvent, FoodPackageDetailsState> {
  FoodPackageDetailsBloc({
    required PackageRepository packageRepository,
    required MenuRepository menuRepository,
    required FoodPackage package,
  }) : _packageRepository = packageRepository,
       _menuRepository = menuRepository,
       super(FoodPackageDetailsInitial(package: package)) {
    on<_Started>(_onStarted);
    on<_Refreshed>(_onRefreshed);
    on<_Changed>(_onChanged);
  }

  final PackageRepository _packageRepository;
  final MenuRepository _menuRepository;

  void _onChanged(
    _Changed event,
    Emitter<FoodPackageDetailsState> emit,
  ) {
    emit(
      FoodPackageDetailsState.success(
        package: state.package,
        menuItems: state.menuItems,
        isDirty: true,
      ),
    );
  }

  Future<void> _onStarted(
    _Started event,
    Emitter<FoodPackageDetailsState> emit,
  ) async {
    emit(
      FoodPackageDetailsLoading(
        package: state.package,
        menuItems: state.menuItems,
        isDirty: state.isDirty,
      ),
    );
    try {
      final menuItems = await _menuRepository.fetchItemsByIds(
        state.package.menuIds,
      );

      emit(
        FoodPackageDetailsSuccess(
          package: state.package,
          menuItems: menuItems,
          isDirty: state.isDirty,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        FoodPackageDetailsFailure(
          package: state.package,
          menuItems: state.menuItems,
          isDirty: state.isDirty,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        FoodPackageDetailsFailure(
          package: state.package,
          menuItems: state.menuItems,
          isDirty: state.isDirty,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRefreshed(
    _Refreshed event,
    Emitter<FoodPackageDetailsState> emit,
  ) async {
    emit(
      FoodPackageDetailsLoading(
        package: state.package,
        menuItems: state.menuItems,
        isDirty: state.isDirty,
      ),
    );
    try {
      final updatedPackage = await _packageRepository.fetchPackage(
        state.package.id,
      );

      final menuItems = await _menuRepository.fetchItemsByIds(
        updatedPackage.menuIds,
      );

      emit(
        FoodPackageDetailsSuccess(
          package: updatedPackage,
          menuItems: menuItems,
          isDirty: true,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        FoodPackageDetailsFailure(
          package: state.package,
          menuItems: state.menuItems,
          errorMessage: e.message,
          isDirty: state.isDirty,
        ),
      );
    } on Exception catch (e) {
      emit(
        FoodPackageDetailsFailure(
          package: state.package,
          menuItems: state.menuItems,
          isDirty: state.isDirty,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
