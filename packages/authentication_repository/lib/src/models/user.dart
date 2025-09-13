import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Represents a user in the authentication system.
@freezed
abstract class User with _$User {
  /// Creates a new User instance.
  ///
  /// The [id] is required, while [email] and [name] are optional
  factory User({
    required String id,
    String? email,
    String? name,
  }) = _User;

  const User._();

  /// Creates an empty User instance.
  factory User.empty() => User(id: '');

  /// Converts a JSON map to a User instance.
  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);

  /// Indicates whether the user is a guest (not logged in).
  bool get isGuest =>
      (email == null || email!.isEmpty) && (name == null || name!.isEmpty);
}
