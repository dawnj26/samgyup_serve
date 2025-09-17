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

  /// Fetches a list of food packages with pagination support.
  Future<List<FoodPackage>> fetchPackages({
    int limit = 20,
    List<String>? ids,
    String? cursor,
  }) async {
    try {
      if (ids != null && ids.isEmpty) {
        return [];
      }

      final result = await _appwrite.databases.listRows(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.packageCollectionId,
        queries: [
          Query.limit(limit),
          if (cursor != null) Query.cursorAfter(cursor),
          if (ids != null && ids.isNotEmpty) Query.equal(r'$id', ids),
          Query.orderDesc(r'$createdAt'),
        ],
      );

      return result.rows
          .map((row) => FoodPackage.fromJson(_appwrite.rowToJson(row)))
          .toList();
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Fetches a specific food package by its ID.
  Future<FoodPackage> fetchPackage(String id) async {
    try {
      final row = await _appwrite.databases.getRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.packageCollectionId,
        rowId: id,
      );

      return FoodPackage.fromJson(_appwrite.rowToJson(row));
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Fetches the total number of food packages available.
  Future<int> fetchTotalPackages() async {
    try {
      final result = await _appwrite.databases.listRows(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.packageCollectionId,
        queries: [
          Query.limit(500),
        ],
      );

      return result.total;
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Updates the menu IDs associated with a specific food package.
  Future<void> updateMenuIds({
    required String packageId,
    required List<String> menuIds,
  }) async {
    try {
      await _appwrite.databases.updateRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.packageCollectionId,
        rowId: packageId,
        data: {
          'menuIds': menuIds,
        },
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Deletes a food package by its ID.
  Future<void> deletePackage(String id) async {
    try {
      await _appwrite.databases.deleteRow(
        databaseId: _projectInfo.databaseId,
        tableId: _projectInfo.packageCollectionId,
        rowId: id,
      );
    } on AppwriteException catch (e) {
      throw ResponseException.fromCode(e.code ?? -1);
    }
  }

  /// Updates an existing food package.
  Future<FoodPackage> updatePackage({
    required FoodPackage package,
    File? image,
  }) async {
    try {
      var imageFileName = package.imageFilename;
      if (image != null) {
        imageFileName = await _appwrite.uploadFile(image);
      }

      final p = package.copyWith(
        imageFilename: imageFileName,
      );

      final row = await _appwrite.databases.updateRow(
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
