part of 'category_delete_bloc.dart';

@freezed
abstract class CategoryDeleteState with _$CategoryDeleteState {
  const factory CategoryDeleteState.initial({
    @Default(LoadingStatus.initial) LoadingStatus status,
    String? errorMessage,
  }) = _Initial;
}
