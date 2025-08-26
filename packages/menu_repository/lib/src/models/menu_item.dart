import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:menu_repository/src/enums/enums.dart';

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
    required MenuCategory category,
    required DateTime createdAt,
    @Default(true) bool isAvailable,
    @Default('') String id,
    DateTime? updatedAt,
    String? imageId,
  }) = _MenuItem;

  /// Creates an empty [MenuItem] instance.
  factory MenuItem.empty() => MenuItem(
    name: '',
    description: '',
    price: 0,
    category: MenuCategory.aLaCarteMeats,
    createdAt: DateTime.now(),
  );

  /// Creates a [MenuItem] from a JSON map.
  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
}
