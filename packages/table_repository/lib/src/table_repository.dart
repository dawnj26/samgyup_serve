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

}
