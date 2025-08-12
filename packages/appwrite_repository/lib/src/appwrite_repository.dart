import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/src/models/models.dart';
import 'package:intl/intl.dart';

/// {@template appwrite_repository}
/// A repository that provides access to Appwrite services.
/// {@endtemplate}
class AppwriteRepository {
  /// {@macro appwrite_repository}
  AppwriteRepository._({required this.environment}) {
    _client = Client()
        .setProject(environment.appwriteProjectId)
        .setEndpoint(environment.appwritePublicEndpoint);
    _account = Account(_client);
    _databases = Databases(_client);
  }

  /// Whether the repository has been initialized.
  static bool get isInitialized => _instance != null;
  final String _pingPath = '/ping';

  static AppwriteRepository? _instance;

  /// The environment configuration for Appwrite.
  final Environment environment;

  late final Client _client;
  late final Account _account;
  late final Databases _databases;

  /// Returns the [Client] instance used for making requests to Appwrite.
  Client get client => _client;

  /// Returns the [Account] service for user management.
  Account get account => _account;

  /// Returns the [Databases] service for database operations.
  Databases get databases => _databases;

  /// Initialize the singleton. Call once (e.g., in main()).
  static Future<AppwriteRepository> initialize({
    required Environment environment,
  }) async {
    if (_instance != null) return _instance!;
    _instance = AppwriteRepository._(environment: environment);
    return _instance!;
  }

  /// Global singleton instance. Throws if not initialized.
  static AppwriteRepository get instance {
    final inst = _instance;
    if (inst == null) {
      throw StateError(
        'AppwriteRepository has not been initialized.',
      );
    }
    return inst;
  }

  /// Returns the project information from the environment.
  ProjectInfo getProjectInfo() {
    return ProjectInfo(
      endpoint: environment.appwritePublicEndpoint,
      projectId: environment.appwriteProjectId,
      projectName: environment.appwriteProjectName,
    );
  }

  /// Pings the Appwrite server and captures the response.
  ///
  /// @return [Log] containing request and response details.
  Future<Log> ping() async {
    try {
      final response = await _client.ping();

      return Log(
        date: _getCurrentDate(),
        status: 200,
        method: 'GET',
        path: _pingPath,
        response: response,
      );
    } on AppwriteException catch (error) {
      return Log(
        date: _getCurrentDate(),
        status: error.code ?? 500,
        method: 'GET',
        path: _pingPath,
        response: error.message ?? 'Unknown error',
      );
    }
  }

  /// Retrieves the current date in the format "MMM dd, HH:mm".
  ///
  /// @return [String] A formatted date.
  String _getCurrentDate() {
    return DateFormat('MMM dd, HH:mm').format(DateTime.now());
  }
}
