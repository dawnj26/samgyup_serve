part of 'food_package_edit_bloc.dart';

@freezed
class FoodPackageEditEvent with _$FoodPackageEditEvent {
  const factory FoodPackageEditEvent.nameChanged(String name) = _NameChanged;
  const factory FoodPackageEditEvent.descriptionChanged(String description) =
      _DescriptionChanged;
  const factory FoodPackageEditEvent.priceChanged(String price) = _PriceChanged;
  const factory FoodPackageEditEvent.timeLimitChanged(String timeLimit) =
      _TimeLimitChanged;
  const factory FoodPackageEditEvent.imageChanged(PlatformFile? image) =
      _ImageChanged;
  const factory FoodPackageEditEvent.submitted() = _Submitted;
}
