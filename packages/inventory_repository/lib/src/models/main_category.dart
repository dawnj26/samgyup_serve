import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_category.freezed.dart';
part 'main_category.g.dart';

@freezed
/// {@template category}
/// A model representing a category.
/// {@endtemplate}
abstract class MainCategory with _$MainCategory {
  /// Creates a [MainCategory] instance.
  const factory MainCategory({
    required String id,
    required String name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MainCategory;

  /// Creates an instance of [MainCategory] from a JSON map.
  factory MainCategory.fromJson(Map<String, dynamic> json) =>
      _$MainCategoryFromJson(json);
}
