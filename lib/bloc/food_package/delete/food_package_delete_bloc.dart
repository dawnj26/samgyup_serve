import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_repository/package_repository.dart';

part 'food_package_delete_event.dart';
part 'food_package_delete_state.dart';
part 'food_package_delete_bloc.freezed.dart';

class FoodPackageDeleteBloc
    extends Bloc<FoodPackageDeleteEvent, FoodPackageDeleteState> {
  FoodPackageDeleteBloc({
    required PackageRepository packageRepository,
  }) : _repo = packageRepository,
       super(const FoodPackageDeleteInitial()) {
    on<_Started>(_onStarted);
  }

  final PackageRepository _repo;

  Future<void> _onStarted(
    _Started event,
    Emitter<FoodPackageDeleteState> emit,
  ) async {
    emit(const FoodPackageDeleteDeleting());

    try {
      await _repo.deletePackage(event.packageId);
      emit(const FoodPackageDeleteSuccess());
    } on ResponseException catch (e) {
      emit(FoodPackageDeleteFailure(errorMessage: e.message));
    } on Exception catch (e) {
      emit(FoodPackageDeleteFailure(errorMessage: e.toString()));
    }
  }
}
