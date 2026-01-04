import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
/// {@template category}
/// A model representing a category.
/// {@endtemplate}
abstract class Category with _$Category {
  /// Creates a [Category] instance.
  const factory Category({
    required String id,
    required String name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Category;

  /// Creates an instance of [Category] from a JSON map.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
