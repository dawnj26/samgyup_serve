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
    File? imageFile,
  }) = MenuCreateInitial;

  const factory MenuCreateState.changed({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required List<Ingredient> ingredients,
    required bool isDetailsValid,
    File? imageFile,
  }) = MenuCreateChanged;

  const factory MenuCreateState.submitting({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required List<Ingredient> ingredients,
    required bool isDetailsValid,
    File? imageFile,
  }) = MenuCreateSubmitting;

  const factory MenuCreateState.success({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required List<Ingredient> ingredients,
    required bool isDetailsValid,
    File? imageFile,
  }) = MenuCreateSuccess;

  const factory MenuCreateState.failure({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required List<Ingredient> ingredients,
    required bool isDetailsValid,
    File? imageFile,
    String? errorMessage,
  }) = MenuCreateFailure;
}
