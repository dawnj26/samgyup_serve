import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:reservation_repository/src/models/models.dart';

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

  /// Creates a new reservation in the database.
  Future<Reservation> createReservation({
    required String tableId,
    required DateTime startTime,
    required String invoiceId,
  }) async {
    try {
      final reservation = Reservation(
        id: ID.unique(),
        tableId: tableId,
        startTime: startTime,
        invoiceId: invoiceId,
      );

      final doc = await _appwrite.databases.createRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: reservation.id,
        data: reservation.toJson(),
      );

      return Reservation.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'ReservationRepository.createReservation');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
