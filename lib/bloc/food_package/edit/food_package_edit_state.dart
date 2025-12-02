part of 'food_package_edit_bloc.dart';

@freezed
abstract class FoodPackageEditState with _$FoodPackageEditState {
  const factory FoodPackageEditState.initial({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    PlatformFile? image,
  }) = FoodPackageEditInitial;
  const factory FoodPackageEditState.loading({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    PlatformFile? image,
  }) = FoodPackageEditLoading;
  const factory FoodPackageEditState.changed({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    PlatformFile? image,
  }) = FoodPackageEditChanged;
  const factory FoodPackageEditState.noChanges({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    PlatformFile? image,
  }) = FoodPackageEditNoChanges;
  const factory FoodPackageEditState.success({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    required FoodPackageItem package,
    PlatformFile? image,
  }) = FoodPackageEditSuccess;
  const factory FoodPackageEditState.failure({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    PlatformFile? image,
    String? errorMessage,
  }) = FoodPackageEditFailure;
}
