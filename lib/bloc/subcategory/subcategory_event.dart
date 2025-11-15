part of 'subcategory_bloc.dart';

@freezed
abstract class SubcategoryEvent with _$SubcategoryEvent {
  const factory SubcategoryEvent.started({
    @Default(false) bool isChanged,
  }) = _Started;
}
