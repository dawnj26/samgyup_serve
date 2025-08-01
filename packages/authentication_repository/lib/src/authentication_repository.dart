import 'package:authentication_repository/src/exceptions/exceptions.dart';
import 'package:authentication_repository/src/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// {@template authentication_repository}
/// Repository which manages user authentication.
/// {@endtemplate}
class AuthenticationRepository {
  /// {@macro authentication_repository}
  AuthenticationRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Stream that emits the user whenever the authentication state changes.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return User.empty();
      }
      return User(
        id: user.uid,
        email: user.email,
        name: user.displayName,
      );
    });
  }

  /// Returns the current user or an empty User if not authenticated.
  User get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      return User.empty();
    }
    return User(
      id: user.uid,
      email: user.email,
      name: user.displayName,
    );
  }

  /// Signs up a user with email and password.
  /// Throws a [SignUpWithEmailAndPasswordFailure] if the sign up fails.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
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
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Logs out the current user.
  /// Throws a [LogoutException] if the logout fails.
  Future<void> logOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (_) {
      throw LogoutException();
    }
  }
}
