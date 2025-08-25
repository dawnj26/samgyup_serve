part of 'menu_create_bloc.dart';

@freezed
abstract class MenuCreateState with _$MenuCreateState {
  const factory MenuCreateState.initial({
    @Default(Name.pure()) Name name,
    @Default(MenuDescription.pure()) MenuDescription description,
    @Default(Price.pure()) Price price,
    @Default(MenuCategoryInput.pure()) MenuCategoryInput category,
    @Default([]) List<Ingredient> ingredients,
    @Default(false) bool isDetailsValid,
  }) = MenuCreateInitial;

  const factory MenuCreateState.changed({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required List<Ingredient> ingredients,
    required bool isDetailsValid,
  }) = MenuCreateChanged;

  const factory MenuCreateState.submitting({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required List<Ingredient> ingredients,
    required bool isDetailsValid,
  }) = MenuCreateSubmitting;

  const factory MenuCreateState.success({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required List<Ingredient> ingredients,
    required bool isDetailsValid,
  }) = MenuCreateSuccess;

  const factory MenuCreateState.failure({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required List<Ingredient> ingredients,
    required bool isDetailsValid,
    String? errorMessage,
  }) = MenuCreateFailure;
}
