part of 'category_delete_bloc.dart';

@freezed
abstract class CategoryDeleteEvent with _$CategoryDeleteEvent {
  const factory CategoryDeleteEvent.started({
    required String categoryId,
    required List<InventoryItem> items,
  }) = _Started;
}
