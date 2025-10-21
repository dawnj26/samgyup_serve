part of 'food_package_tab_bloc.dart';

@freezed
class FoodPackageTabEvent with _$FoodPackageTabEvent {
  const factory FoodPackageTabEvent.started() = _Started;
  const factory FoodPackageTabEvent.fetchMore() = _FetchMore;
  const factory FoodPackageTabEvent.refresh() = _Refresh;
}
