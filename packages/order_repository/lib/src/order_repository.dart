import 'package:appwrite_repository/appwrite_repository.dart';

/// {@template order_repository}
/// Repository for managing orders.
/// {@endtemplate}
class OrderRepository {
  /// {@macro order_repository}
  OrderRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

  //
  // ignore: unused_element
  String get _collectionId => _appwrite.environment.orderCollectionId;
}
