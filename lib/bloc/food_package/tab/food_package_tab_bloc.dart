import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';
import 'package:package_repository/package_repository.dart';

part 'food_package_tab_event.dart';
part 'food_package_tab_state.dart';
part 'food_package_tab_bloc.freezed.dart';

class FoodPackageTabBloc
    extends Bloc<FoodPackageTabEvent, FoodPackageTabState> {
  FoodPackageTabBloc({
    required PackageRepository packageRepository,
    required InventoryRepository inventoryRepository,
  }) : _repo = packageRepository,
       _inventoryRepository = inventoryRepository,
       super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_FetchMore>(_onFetchMore);
    on<_Refresh>(_onRefreshed);
  }

  final PackageRepository _repo;
  final InventoryRepository _inventoryRepository;
  final int _pageSize = 20;

  Future<void> _onRefreshed(
    _Refresh event,
    Emitter<FoodPackageTabState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FoodPackageTabStatus.refreshing));
      final items = await _repo.fetchPackages(
        limit: _pageSize,
      );

      emit(
        state.copyWith(
          status: FoodPackageTabStatus.success,
          items: await _mapToFoodPackageFullList(items),
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
          items: await _mapToFoodPackageFullList(items),
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
          items: List.of(state.items)
            ..addAll(await _mapToFoodPackageFullList(items)),
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

  Future<List<FoodPackageFull>> _mapToFoodPackageFullList(
    List<FoodPackage> packages,
  ) async {
    final iItems = <FoodPackageFull>[];

    for (final i in packages) {
      final item = await _inventoryRepository.fetchItems(
        itemIds: i.menuIds,
        includeBatches: true,
      );

      iItems.add(
        FoodPackageFull(
          id: i.id,
          name: i.name,
          description: i.description,
          price: i.price,
          timeLimit: i.timeLimit,
          createdAt: i.createdAt,
          menuIds: i.menuIds,
          items: item,
          imageFilename: i.imageFilename,
        ),
      );
    }

    return iItems;
  }
}
