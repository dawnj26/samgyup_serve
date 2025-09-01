import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:package_repository/src/models/models.dart';

/// {@template package_repository}
/// Repository for managing packages.
/// {@endtemplate}
class PackageRepository {
  /// {@macro package_repository}
  PackageRepository({
    AppwriteRepository? appwriteRepository,
  }) : _appwrite = appwriteRepository ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

  ProjectInfo get _projectInfo => _appwrite.getProjectInfo();

  /// Creates a new food package.
  Future<FoodPackage> createPackage({
    required FoodPackage package,
    File? image,
  }) async {
    try {
      String? imageFileName;
      if (image != null) {
        imageFileName = await _appwrite.uploadFile(image);
      }

      final p = package.copyWith(
        id: ID.unique(),
        imageFilename: imageFileName,
      );
      final row = await _appwrite.databases.createRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.packageCollectionId,
        rowId: p.id,
        data: p.toJson(),
      );
      return FoodPackage.fromJson(_appwrite.rowToJson(row));
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }
}
