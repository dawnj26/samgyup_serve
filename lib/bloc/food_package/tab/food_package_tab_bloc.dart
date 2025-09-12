import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_repository/package_repository.dart';

part 'food_package_tab_event.dart';
part 'food_package_tab_state.dart';
part 'food_package_tab_bloc.freezed.dart';

class FoodPackageTabBloc
    extends Bloc<FoodPackageTabEvent, FoodPackageTabState> {
  FoodPackageTabBloc({required PackageRepository packageRepository})
    : _repo = packageRepository,
      super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_FetchMore>(_onFetchMore);
  }

  final PackageRepository _repo;
  final int _pageSize = 20;

  Future<void> _onStarted(
    _Started event,
    Emitter<FoodPackageTabState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FoodPackageTabStatus.loading));
      final items = await _repo.fetchPackages(limit: _pageSize);
      emit(
        state.copyWith(
          status: FoodPackageTabStatus.success,
          items: items,
          hasReachedMax: items.length < _pageSize,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: FoodPackageTabStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: FoodPackageTabStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFetchMore(
    _FetchMore event,
    Emitter<FoodPackageTabState> emit,
  ) async {
    if (state.hasReachedMax) {
      return;
    }
    try {
      emit(state.copyWith(status: FoodPackageTabStatus.loading));
      final items = await _repo.fetchPackages(
        limit: _pageSize,
        cursor: state.items.isNotEmpty ? state.items.last.id : null,
      );
      emit(
        state.copyWith(
          status: FoodPackageTabStatus.success,
          items: List.of(state.items)..addAll(items),
          hasReachedMax: items.isEmpty,
        ),
      );
    } on ResponseException catch (e) {
      emit(
        state.copyWith(
          status: FoodPackageTabStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: FoodPackageTabStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
