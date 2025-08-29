part of 'menu_edit_bloc.dart';

@freezed
class MenuEditEvent with _$MenuEditEvent {
  const factory MenuEditEvent.nameChanged(String name) = _NameChanged;
  const factory MenuEditEvent.descriptionChanged(String description) =
      _DescriptionChanged;
  const factory MenuEditEvent.priceChanged(String price) = _PriceChanged;
  const factory MenuEditEvent.categoryChanged(MenuCategory? category) =
      _CategoryChanged;
  const factory MenuEditEvent.submitted() = _Submitted;
  const factory MenuEditEvent.imageChanged(File? imageFile) = _ImageChanged;
}
