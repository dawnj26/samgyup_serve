import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_repository/package_repository.dart';

part 'food_package_bloc.freezed.dart';
part 'food_package_event.dart';
part 'food_package_state.dart';

class FoodPackageBloc extends Bloc<FoodPackageEvent, FoodPackageState> {
  FoodPackageBloc({
    required PackageRepository packageRepository,
  }) : _packageRepository = packageRepository,
       super(const FoodPackageInitial()) {
    on<_Started>(_onStarted);
  }

  final PackageRepository _packageRepository;
  final int _fetchLimit = 20;

  Future<void> _onStarted(
    _Started event,
    Emitter<FoodPackageState> emit,
  ) async {
    emit(
      FoodPackageLoading(
        packages: state.packages,
        hasReachedMax: state.hasReachedMax,
        totalPackages: state.totalPackages,
      ),
    );

    try {
      final packages = await _packageRepository.fetchPackages(
        limit: _fetchLimit,
        cursor: state.packages.isNotEmpty ? state.packages.last.id : null,
      );
      final hasReachedMax = packages.length < _fetchLimit;
      final total = await _packageRepository.fetchTotalPackages();

      emit(
        FoodPackageSuccess(
          packages: [...state.packages, ...packages],
          hasReachedMax: hasReachedMax,
          totalPackages: total,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        FoodPackageFailure(
          error: e.message,
          packages: state.packages,
          hasReachedMax: state.hasReachedMax,
          totalPackages: state.totalPackages,
        ),
      );
    } on Exception catch (e) {
      emit(
        FoodPackageFailure(
          error: e.toString(),
          packages: state.packages,
          hasReachedMax: state.hasReachedMax,
          totalPackages: state.totalPackages,
        ),
      );
    }
  }
}
