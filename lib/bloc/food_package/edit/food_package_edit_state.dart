part of 'food_package_edit_bloc.dart';

@freezed
abstract class FoodPackageEditState with _$FoodPackageEditState {
  const factory FoodPackageEditState.initial({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    File? image,
  }) = FoodPackageEditInitial;
  const factory FoodPackageEditState.loading({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    File? image,
  }) = FoodPackageEditLoading;
  const factory FoodPackageEditState.changed({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    File? image,
  }) = FoodPackageEditChanged;
  const factory FoodPackageEditState.noChanges({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    File? image,
  }) = FoodPackageEditNoChanges;
  const factory FoodPackageEditState.success({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    required FoodPackage package,
    File? image,
  }) = FoodPackageEditSuccess;
  const factory FoodPackageEditState.failure({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    File? image,
    String? errorMessage,
  }) = FoodPackageEditFailure;
}
