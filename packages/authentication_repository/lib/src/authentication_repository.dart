import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:authentication_repository/src/exceptions/exceptions.dart';
import 'package:authentication_repository/src/models/models.dart';

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    AppwriteRepository? firebaseAuth,
  }) : _appwrite = firebaseAuth ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

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
    } on Exception catch (_) {
      throw const SignUpWithEmailAndPasswordFailure('Something went wrong.');
    }
  }

  /// Logs in a user with email and password.
  /// Throws a [LogInWithEmailAndPasswordFailure] if the login fails.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _appwrite.account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } on Exception catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Logs out the current user.
  /// Throws a [LogoutException] if the logout fails.
  Future<void> logOut() async {
    try {
      await _appwrite.account.deleteSession(sessionId: 'current');
    } on Exception catch (_) {
      throw LogoutException();
    }
  }
}
