part of 'food_package_create_bloc.dart';

@freezed
class FoodPackageCreateEvent with _$FoodPackageCreateEvent {
  const factory FoodPackageCreateEvent.nameChanged(String name) = _NameChanged;
  const factory FoodPackageCreateEvent.descriptionChanged(String description) =
      _DescriptionChanged;
  const factory FoodPackageCreateEvent.priceChanged(String price) =
      _PriceChanged;
  const factory FoodPackageCreateEvent.timeLimitChanged(String timeLimit) =
      _TimeLimitChanged;
  const factory FoodPackageCreateEvent.imageChanged(PlatformFile? image) =
      _ImageChanged;
  const factory FoodPackageCreateEvent.submitted() = _Submitted;
}
