part of 'subcategory_action_bloc.dart';

enum SubcategoryActionType {
  create,
  remove,
}

@freezed
abstract class SubcategoryActionState with _$SubcategoryActionState {
  const factory SubcategoryActionState.initial({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(SubcategoryActionType.create) SubcategoryActionType actionType,
    String? errorMessage,
  }) = _Initial;
}
