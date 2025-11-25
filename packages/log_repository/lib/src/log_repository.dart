import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart'
    show AppwriteRepository, ResponseException;
import 'package:authentication_repository/authentication_repository.dart';
import 'package:log_repository/src/enums/enums.dart';
import 'package:log_repository/src/models/models.dart';

/// {@template log_repository}
/// Log repository
/// {@endtemplate}
class LogRepository {
  /// Initialize the singleton. Call once.
  LogRepository.initialize({
    required AuthenticationRepository auth,
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance,
       _auth = auth {
    if (_instance != null) return;
    _instance = LogRepository._(
      appwrite: _appwrite,
      auth: _auth,
    );
  }

  /// {@macro log_repository}
  LogRepository._({
    required AppwriteRepository appwrite,
    required AuthenticationRepository auth,
  }) : _appwrite = appwrite,
       _auth = auth;

  static LogRepository? _instance;

  /// Whether the repository has been initialized.
  static bool get isInitialized => _instance != null;

  /// Global singleton instance. Throws if not initialized.
  static LogRepository get instance {
    final inst = _instance;
    if (inst == null) {
      throw StateError(
        'LogRepository has not been initialized.',
      );
    }
    return inst;
  }

  final AppwriteRepository _appwrite;
  final AuthenticationRepository _auth;

  String get _logCollectionId => _appwrite.environment.logCollectionId;
  String get _databaseId => _appwrite.environment.databaseId;

  /// Logs an action performed by a user on a resource.
  Future<void> logAction({
    required String resourceId,
    required LogAction action,
    required String message,
    String? details,
  }) async {
    final user = await _auth.currentUser;

    if (user.isGuest) return;

    final log = LogBase(
      action: action,
      userId: user.id,
      message: message,
      resourceId: resourceId,
      id: ID.unique(),
      createdAt: DateTime.now(),
      details: details,
    );

    try {
      await _appwrite.databases.createRow(
        databaseId: _databaseId,
        tableId: _logCollectionId,
        rowId: log.id,
        data: log.toJson(),
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
