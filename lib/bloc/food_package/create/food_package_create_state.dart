part of 'food_package_create_bloc.dart';

@freezed
abstract class FoodPackageCreateState with _$FoodPackageCreateState {
  const factory FoodPackageCreateState.initial({
    @Default(Name.pure()) Name name,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    @Default(TimeLimit.pure()) TimeLimit timeLimit,
    File? image,
  }) = FoodPackageCreateInitial;

  const factory FoodPackageCreateState.changed({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    File? image,
  }) = FoodPackageCreateChanged;

  const factory FoodPackageCreateState.creating({
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    File? image,
  }) = FoodPackageCreateCreating;

  const factory FoodPackageCreateState.success({
    required FoodPackage foodPackage,
    @Default(Name.pure()) Name name,
    @Default(Description.pure()) Description description,
    @Default(Price.pure()) Price price,
    @Default(TimeLimit.pure()) TimeLimit timeLimit,
    File? image,
  }) = FoodPackageCreateSuccess;

  const factory FoodPackageCreateState.failure({
    required String errorMessage,
    required Name name,
    required Description description,
    required Price price,
    required TimeLimit timeLimit,
    File? image,
  }) = FoodPackageCreateFailure;
}
