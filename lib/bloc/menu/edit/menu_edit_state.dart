part of 'menu_edit_bloc.dart';

@freezed
abstract class MenuEditState with _$MenuEditState {
  const factory MenuEditState.initial({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    @Default(true) bool isDetailsValid,
    File? imageFile,
  }) = MenuEditInitial;

  const factory MenuEditState.changed({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required bool isDetailsValid,
    File? imageFile,
  }) = MenuEditChanged;

  const factory MenuEditState.submitting({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required bool isDetailsValid,
    File? imageFile,
  }) = MenuEditSubmitting;

  const factory MenuEditState.success({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required bool isDetailsValid,
    File? imageFile,
  }) = MenuEditSuccess;

  const factory MenuEditState.pure({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,
    required bool isDetailsValid,
    File? imageFile,
  }) = MenuEditPure;

  const factory MenuEditState.failure({
    required Name name,
    required MenuDescription description,
    required Price price,
    required MenuCategoryInput category,

    required bool isDetailsValid,
    File? imageFile,
    String? errorMessage,
  }) = MenuEditFailure;
}
