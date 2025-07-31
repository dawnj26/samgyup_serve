import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  factory User({
    required String id,
    String? email,
    String? name,
  }) = _User;

  factory User.empty() => User(id: '');

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
