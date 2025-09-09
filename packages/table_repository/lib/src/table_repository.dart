import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:table_repository/src/enums/enums.dart';
import 'package:table_repository/src/models/table.dart';

/// {@template table_repository}
/// A Dart package which manages tables.
/// {@endtemplate}
class TableRepository {
  /// {@macro table_repository}
  TableRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;
  String get _collectionId => _appwrite.environment.tableCollectionId;

  /// Creates a new table in the database.
  Future<Table> createTable(Table table) async {
    try {
      final t = table.copyWith(
        id: ID.unique(),
        createdAt: DateTime.now(),
      );

      final response = await _appwrite.databases.createRow(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        rowId: t.id,
        data: t.toJson(),
      );

      return Table.fromJson(_appwrite.rowToJson(response));
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Fetches all tables from the database.
  Future<List<Table>> fetchTables({
    int limit = 20,
    String? cursor,
    TableStatus? status,
  }) async {
    try {
      final response = await _appwrite.databases.listRows(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        queries: [
          Query.limit(limit),
          if (cursor != null) Query.cursorAfter(cursor),
          if (status != null) Query.equal('status', status.name),
          Query.orderDesc(r'$createdAt'),
        ],
      );

      return response.rows
          .map((row) => Table.fromJson(_appwrite.rowToJson(row)))
          .toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Gets the total number of tables in the database.
  Future<int> getTotalTable() async {
    try {
      final response = await _appwrite.databases.listRows(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        queries: [
          Query.limit(500),
        ],
      );
      return response.total;
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
