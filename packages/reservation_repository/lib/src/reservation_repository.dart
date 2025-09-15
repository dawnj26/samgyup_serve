import 'package:appwrite_repository/appwrite_repository.dart';

/// {@template reservation_repository}
/// Repository for managing reservations.
/// {@endtemplate}
class ReservationRepository {
  /// {@macro reservation_repository}
  ReservationRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

  String get _collectionId => _appwrite.environment.reservationCollectionId;
  String get _databaseId => _appwrite.environment.databaseId;
}
