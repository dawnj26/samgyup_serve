import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/menu_repository.dart';

part 'menu_item.freezed.dart';
part 'menu_item.g.dart';

/// {@template menu_item}
/// A data model representing a menu item.
/// {@endtemplate}
@freezed
abstract class MenuItem with _$MenuItem {
  /// {@macro menu_item}
  factory MenuItem({
    required String name,
    required String description,
    required double price,
    required String category,
    required List<Ingredient> ingredients,
    required DateTime createdAt,
    @Default(true) bool isAvailable,
    @Default('') String id,
    DateTime? updatedAt,
  }) = _MenuItem;

  /// Creates an empty [MenuItem] instance.
  factory MenuItem.empty() => MenuItem(
    name: '',
    description: '',
    price: 0,
    category: '',
    ingredients: [],
    createdAt: DateTime.now(),
  );

  /// Creates a [MenuItem] from a JSON map.
  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}
