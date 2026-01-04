import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/src/enums/enums.dart';

part 'subcategory.freezed.dart';
part 'subcategory.g.dart';

/// {@template subcategory}
/// A model representing a product subcategory.
///
/// Subcategories are nested under a parent category and are used to
/// organize products in the inventory system.
/// {@endtemplate}
@freezed
abstract class Subcategory with _$Subcategory {
  ///  {@macro subcategory}
  factory Subcategory({
    /// Unique identifier for the subcategory.
    required String id,

    /// Display name of the subcategory.
    required String name,

    /// ID of the parent category this subcategory belongs to.
    required String parent,
  }) = _Subcategory;

  /// Converts a JSON map to a [Subcategory] instance.
  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);

  const Subcategory._();

  /// Returns the human-readable label of the parent category.
  String get parentLabel {
    for (final category in InventoryCategory.values) {
      if (category.name == parent) {
        return category.label;
      }
    }

    return parent;
  }
}
