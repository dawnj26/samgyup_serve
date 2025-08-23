import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_repository/inventory_repository.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

/// {@template ingredient}
/// A data model representing an ingredient used in menu items.
/// {@endtemplate}
@freezed
abstract class Ingredient with _$Ingredient {
  /// {@macro ingredient}
  factory Ingredient({
    required String name,
    required double quantity,
    required MeasurementUnit unit,
    required DateTime createdAt,
    required String menuItemId,
    required String inventoryItemId,
    @Default('') String id,
    DateTime? updatedAt,
  }) = _Ingredient;

  /// Creates an empty [Ingredient] instance.
  factory Ingredient.empty() => Ingredient(
    name: '',
    quantity: 0,
    unit: MeasurementUnit.unknown,
    createdAt: DateTime.now(),
    menuItemId: '',
    inventoryItemId: '',
  );

  /// Creates an [Ingredient] from a JSON map.
  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}
