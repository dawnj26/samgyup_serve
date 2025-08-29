import 'package:appwrite_repository/appwrite_repository.dart';

/// {@template package_repository}
/// Repository for managing packages.
/// {@endtemplate}
class PackageRepository {
  /// {@macro package_repository}
  PackageRepository({
    AppwriteRepository? appwriteRepository,
  }) : _appwriteRepository = appwriteRepository ?? AppwriteRepository.instance;

  final AppwriteRepository _appwriteRepository;
}
