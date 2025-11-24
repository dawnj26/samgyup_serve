import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:authentication_repository/src/exceptions/exceptions.dart';
import 'package:authentication_repository/src/models/models.dart';

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({AppwriteRepository? appwrite})
    : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;
  String get _methodId => 'https://691dd426001505f25fa9.syd.appwrite.run';

  /// Returns the current user or an empty User if not authenticated.
  Future<User> get currentUser async {
    try {
      final user = await _appwrite.account.get();

      return User(
        id: user.$id,
        email: user.email,
        name: user.name,
      );
    } on Exception catch (_) {
      return User.empty();
    }
  }

  /// Signs up a user with email and password.
  /// Throws a [SignUpWithEmailAndPasswordFailure] if the sign up fails.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _appwrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    } on Exception catch (_) {
      throw const ResponseException('Unknown error occurred during sign up.');
    }
  }

  /// Logs in a user with email and password.
  /// Throws a [LogInWithEmailAndPasswordFailure] if the login fails.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (await currentUser != User.empty()) {
        await _appwrite.account.deleteSession(sessionId: 'current');
      }

      await _appwrite.account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      log(
        'AppwriteException: ${e.message}, Code: ${e.code}',
        name: 'AuthenticationRepository',
      );
      throw ResponseException.fromCode(e.code ?? -1);
    } on Exception catch (_) {
      throw const ResponseException('Unknown error occurred during login.');
    }
  }

  /// Logs out the current user.
  /// Throws a [LogoutException] if the logout fails.
  Future<void> logOut() async {
    try {
      await _appwrite.account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    } on Exception catch (_) {
      throw const ResponseException('Unknown error occurred during logout.');
    }
  }

  /// Updates the given user.
  Future<User> updateUser(
    User user, {
    String? password,
  }) async {
    try {
      final response = await _appwrite.executeFunction(
        endpoint: _methodId,
        data: {
          'method': 'update',
          'data': user.toJson(),
          'password': password,
        },
      );

      final data = response != null
          ? jsonDecode(response)
          : <String, dynamic>{};

      return User.fromJson(data as Map<String, dynamic>);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Creates a new user with the given email, password, and name.
  Future<User> createUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final user = await _appwrite.account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      return User(
        id: user.$id,
        email: user.email,
        name: user.name,
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    } on Exception catch (_) {
      throw const ResponseException(
        'Unknown error occurred during user creation.',
      );
    }
  }

  /// Fetches a list of users.
  Future<List<User>> fetchUsers() async {
    try {
      final result = await _appwrite.executeFunction(
        endpoint: _methodId,
        data: {
          'method': 'list',
        },
      );

      final data = result != null
          ? jsonDecode(result)
          : <Map<String, dynamic>>[];
      final users = (data as List)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();

      return users;
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Fetches a user by their unique ID.
  Future<User> fetchUserById(String id) async {
    try {
      final result = await _appwrite.executeFunction(
        endpoint: _methodId,
        data: {
          'method': 'get',
          'data': {
            'id': id,
          },
        },
      );

      final data = result != null ? jsonDecode(result) : <String, dynamic>{};

      return User.fromJson(data as Map<String, dynamic>);
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Deletes a user by their unique ID.
  Future<void> deleteUser(String id) async {
    try {
      await _appwrite.executeFunction(
        endpoint: _methodId,
        data: {
          'method': 'delete',
          'data': {
            'id': id,
          },
        },
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Creates a guest session (anonymous session).
  Future<void> createGuestSession() async {
    try {
      await _appwrite.account.createAnonymousSession();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }
}
