import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:table_repository/src/models/table.dart';

/// {@template table_repository}
/// A Dart package which manages tables.
/// {@endtemplate}
class TableRepository {
  /// {@macro table_repository}
  TableRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance,
       _collectionId =
           appwrite?.environment.tableCollectionId ??
           AppwriteRepository.instance.environment.tableCollectionId;

  final AppwriteRepository _appwrite;
  final String _collectionId;

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
      print(e);
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
