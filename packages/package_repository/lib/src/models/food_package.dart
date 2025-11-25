import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';

part 'food_package.freezed.dart';

part 'food_package.g.dart';

/// A food package that contains multiple menu items bundled together.
///
/// Food packages allow restaurants to offer curated collections of menu items
/// at a potentially discounted price with a time limit for ordering.
@freezed
abstract class FoodPackage with _$FoodPackage {
  /// Creates a new [FoodPackage] instance.
  ///
  /// All required fields must be provided. The [timeLimit] represents the
  /// number of minutes customers have to complete their order once started.
  const factory FoodPackage.item({
    /// The display name of the food package
    required String name,

    /// A detailed description of what's included in the package
    required String description,

    /// The total price of the package in the restaurant's currency
    required double price,

    /// Time limit in minutes for customers to complete their order
    required int timeLimit,

    /// When this package was first created
    required DateTime createdAt,

    /// List of menu item IDs included in this package
    required List<String> menuIds,

    /// Unique identifier for the package, defaults to empty string
    @Default('') String id,

    /// Optional filename for the package's promotional image
    String? imageFilename,

    /// When this package was last modified
    DateTime? updatedAt,
  }) = FoodPackageItem;

  /// full model
  const factory FoodPackage.full({
    /// The display name of the food package
    required String name,

    /// A detailed description of what's included in the package
    required String description,

    /// The total price of the package in the restaurant's currency
    required double price,

    /// Time limit in minutes for customers to complete their order
    required int timeLimit,

    /// When this package was first created
    required DateTime createdAt,

    /// List of menu item IDs included in this package
    required List<String> menuIds,

    required List<InventoryItem> items,

    /// Unique identifier for the package, defaults to empty string
    @Default('') String id,

    /// Optional filename for the package's promotional image
    String? imageFilename,

    /// When this package was last modified
    DateTime? updatedAt,
  }) = FoodPackageFull;

  /// Creates a [FoodPackage] from a JSON map.
  ///
  /// Used for deserializing package data from API responses or local storage.
  factory FoodPackage.fromJson(Map<String, dynamic> json) =>
      _$FoodPackageFromJson(json);
}
