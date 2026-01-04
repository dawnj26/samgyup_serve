part of 'category_bloc.dart';

@freezed
abstract class CategoryState with _$CategoryState {
  const factory CategoryState.initial({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<MainCategory> categories,
    String? errorMessage,
  }) = _Initial;
}
