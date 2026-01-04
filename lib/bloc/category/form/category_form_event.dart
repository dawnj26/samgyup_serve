part of 'category_form_bloc.dart';

@freezed
abstract class CategoryFormEvent with _$CategoryFormEvent {
  const factory CategoryFormEvent.created({
    required String name,
  }) = _Created;
  const factory CategoryFormEvent.updated({
    required String id,
    required String name,
  }) = _Updated;
}
