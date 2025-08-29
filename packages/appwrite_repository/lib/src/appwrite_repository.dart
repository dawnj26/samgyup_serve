import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:appwrite_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
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
    _databases = TablesDB(_client);
    _storage = Storage(_client);
    _functions = Functions(_client);
  }

  /// Whether the repository has been initialized.
  static bool get isInitialized => _instance != null;
  final String _pingPath = '/ping';

  static AppwriteRepository? _instance;

  /// The environment configuration for Appwrite.
  final Environment environment;

  late final Client _client;
  late final Account _account;
  late final TablesDB _databases;
  late final Storage _storage;
  late final Functions _functions;

  /// Returns the [Client] instance used for making requests to Appwrite.
  Client get client => _client;

  /// Returns the [Account] service for user management.
  Account get account => _account;

  /// Returns the [Databases] service for database operations.
  TablesDB get databases => _databases;

  /// Returns the [Storage] service for file storage operations.
  Storage get storage => _storage;

  /// Returns the [Functions] service for executing server-side functions.
  Functions get functions => _functions;

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
      inventoryCollectionId: environment.inventoryCollectionId,
      databaseId: environment.databaseId,
      menuCollectionId: environment.menuCollectionId,
      menuIngredientsCollectionId: environment.menuIngredientsCollectionId,
      storageBucketId: environment.storageBucketId,
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

  /// Converts an Appwrite Row to a JSON map.
  Map<String, dynamic> rowToJson(appwrite_models.Row row) {
    return {
      ...row.data,
      'updatedAt': row.$updatedAt,
    };
  }

  /// Converts a model's data and ID to a map suitable for Appwrite Document.
  Map<String, dynamic> modeltoDocumentMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return {
      ...data,
      r'$id': id,
    };
  }

  /// Fetches metadata for a file stored in Appwrite by its unique ID.
  Future<appwrite_models.File> getFileMetadata(String fileId) async {
    final response = await _storage.getFile(
      bucketId: environment.storageBucketId,
      fileId: fileId,
    );

    return response;
  }

  /// Retrieves a specific file and returns its data as a byte array.
  Future<Uint8List> downloadFile(String fileId) async {
    final response = await _storage.getFileDownload(
      bucketId: environment.storageBucketId,
      fileId: fileId,
    );

    return response;
  }

  /// Uploads a file to Appwrite Storage and returns its unique file ID.
  Future<String> uploadFile(File file) async {
    final filename = _getFilename(file);
    final fileExtension = _getFileExtension(filename);
    final response = await _storage.createFile(
      bucketId: environment.storageBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: file.path, filename: filename),
    );

    return '${response.$id}.$fileExtension';
  }

  /// Creates a JSON Web Token (JWT) for the current user session.
  Future<String?> createJWT() async {
    try {
      await _account.get();

      final jwt = await _account.createJWT();
      return jwt.jwt;
    } on AppwriteException catch (e) {
      log(e.toString());
      return null;
    }
  }

  /// Executes a server-side function with optional data payload.
  Future<void> executeFunction({
    required String endpoint,
    Map<String, dynamic>? data,
  }) async {
    final jwt = await createJWT();
    if (jwt == null) {
      throw Exception('User is not authenticated.');
    }

    final uri = Uri.parse(endpoint);
    final headers = {
      'Content-Type': 'application/json',
      'x-appwrite-user-jwt': jwt,
    };

    final response = await http.post(
      uri,
      headers: headers,
      body: data != null ? jsonEncode(data) : null,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Function execution failed: ${response.statusCode}: ${response.body}',
      );
    }
  }

  String _getFilename(File file) {
    return file.path.split(Platform.pathSeparator).last;
  }

  String _getFileExtension(String filename) {
    return filename.split('.').last;
  }
}
