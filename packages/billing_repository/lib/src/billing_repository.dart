import 'package:appwrite_repository/appwrite_repository.dart';

/// {@template billing_repository}
/// Repository for managing billing operations.
/// {@endtemplate}
class BillingRepository {
  /// {@macro billing_repository}
  BillingRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

  String get _collectionId => _appwrite.environment.invoiceCollectionId;
  String get _databaseId => _appwrite.environment.databaseId;
}
