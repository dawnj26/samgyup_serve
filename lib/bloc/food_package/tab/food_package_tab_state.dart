part of 'food_package_tab_bloc.dart';

enum FoodPackageTabStatus { initial, loading, success, failure, refreshing }

@freezed
abstract class FoodPackageTabState with _$FoodPackageTabState {
  const factory FoodPackageTabState.initial({
    @Default(FoodPackageTabStatus.initial) FoodPackageTabStatus status,
    @Default([]) List<FoodPackage> items,
    @Default(false) bool hasReachedMax,
    String? errorMessage,
  }) = _Initial;
}
