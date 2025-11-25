import 'dart:developer';

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
    List<TableStatus> statuses = const [],
  }) async {
    try {
      final response = await _appwrite.databases.listRows(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        queries: [
          Query.limit(limit),
          if (cursor != null) Query.cursorAfter(cursor),
          if (statuses.isNotEmpty)
            Query.equal('status', statuses.map((e) => e.name).toList()),
          Query.orderAsc('number'),
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

  /// Updates an existing table in the database.
  Future<Table> updateTable(Table table) async {
    try {
      final response = await _appwrite.databases.updateRow(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        rowId: table.id,
        data: table.toJson(),
      );

      return Table.fromJson(_appwrite.rowToJson(response));
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Updates only the status of a table in the database.
  Future<Table> updateTableStatus({
    required String tableId,
    required TableStatus status,
  }) async {
    try {
      final response = await _appwrite.databases.updateRow(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        rowId: tableId,
        data: {
          'status': status.name,
        },
      );

      return Table.fromJson(_appwrite.rowToJson(response));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'TableRepository.updateTableStatus');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Fetch a single table by its ID.
  Future<Table> fetchTable(String id) async {
    try {
      final response = await _appwrite.databases.getRow(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        rowId: id,
      );

      return Table.fromJson(_appwrite.rowToJson(response));
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Fetch a single table by its number.
  Future<Table> fetchTableByNumber(int number) async {
    try {
      final response = await _appwrite.databases.listRows(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        queries: [
          Query.equal('number', number),
          Query.limit(1),
        ],
      );

      if (response.total == 0) {
        throw const ResponseException('Table not found');
      }

      return Table.fromJson(_appwrite.rowToJson(response.rows.first));
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Deletes a table from the database.
  Future<void> deleteTable(String id) async {
    try {
      await _appwrite.databases.deleteRow(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        rowId: id,
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Gets the number of available tables in the database.
  Future<int> getAvailableTable() async {
    try {
      final response = await _appwrite.databases.listRows(
        databaseId: _appwrite.environment.databaseId,
        tableId: _collectionId,
        queries: [
          Query.equal('status', TableStatus.available.name),
          Query.limit(500),
        ],
      );
      return response.total;
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
