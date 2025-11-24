import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:reservation_repository/src/enums/enums.dart';
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
        startTime: startTime.toUtc(),
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

  /// Retrieves the current active reservation for a given table.
  Future<Reservation?> getCurrentReservation(String tableId) async {
    try {
      final result = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: [
          Query.equal('tableId', tableId),
          Query.or(
            [
              Query.equal('status', ReservationStatus.active.name),
              Query.equal('status', ReservationStatus.cancelling.name),
            ],
          ),
          Query.limit(1),
        ],
      );

      if (result.total == 0) {
        return null;
      }

      final doc = result.rows.first;
      return Reservation.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'ReservationRepository.getCurrentReservation');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Retrieves a reservation by its ID.
  Future<Reservation> getReservationById(String reservationId) async {
    try {
      final doc = await _appwrite.databases.getRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: reservationId,
      );

      return Reservation.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'ReservationRepository.getReservationById');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Retrieves a reservation by its associated invoice ID.
  Future<Reservation> getReservationByInvoiceId(String invoiceId) async {
    try {
      final result = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: [
          Query.equal('invoiceId', invoiceId),
          Query.limit(1),
        ],
      );

      if (result.total == 0) {
        throw const ResponseException('Reservation not found');
      }

      final doc = result.rows.first;
      return Reservation.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(
        e.toString(),
        name: 'ReservationRepository.getReservationByInvoiceId',
      );
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Updates an existing reservation in the database.
  Future<Reservation> updateReservation({
    required Reservation reservation,
  }) async {
    try {
      final doc = await _appwrite.databases.updateRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: reservation.id,
        data: reservation.toJson(),
      );

      return Reservation.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'ReservationRepository.updateReservation');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Gets the total number of reservations made today.
  Future<int> getTodayTotalReservations() async {
    try {
      final now = DateTime.now().toUtc();
      final startOfDay = DateTime.utc(now.year, now.month, now.day);
      final endOfDay = DateTime.utc(now.year, now.month, now.day, 23, 59, 59);

      final result = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: [
          Query.greaterThanEqual('startTime', startOfDay.toIso8601String()),
          Query.lessThanEqual('startTime', endOfDay.toIso8601String()),
        ],
      );

      return result.total;
    } on AppwriteException catch (e) {
      log(
        e.toString(),
        name: 'ReservationRepository.getTodayTotalReservations',
      );
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Gets the reservation counts per hour
  /// for a specific date (defaults to today).
  ///
  /// Returns a list of 24 integers representing counts for each hour (0-23)
  /// in local time.
  Future<List<int>> getHourlyReservationCounts([DateTime? date]) async {
    try {
      final targetDate = date ?? DateTime.now();
      final startOfDay = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
      );
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1));

      final result = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: [
          Query.greaterThanEqual(
            'startTime',
            startOfDay.toUtc().toIso8601String(),
          ),
          Query.lessThanEqual(
            'startTime',
            endOfDay.toUtc().toIso8601String(),
          ),
          Query.limit(1000),
        ],
      );

      final hourlyCounts = List<int>.filled(24, 0);

      for (final doc in result.rows) {
        final data = _appwrite.rowToJson(doc);
        final reservation = Reservation.fromJson(data);
        final localHour = reservation.startTime.toLocal().hour;
        if (localHour >= 0 && localHour < 24) {
          hourlyCounts[localHour]++;
        }
      }

      return hourlyCounts;
    } on AppwriteException catch (e) {
      log(
        e.toString(),
        name: 'ReservationRepository.getHourlyReservationCounts',
      );
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Cancels a reservation by updating its status and end time.
  Future<Reservation> cancelReservation(
    String reservationId, {
    bool accepted = true,
  }) async {
    try {
      final doc = await _appwrite.databases.updateRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: reservationId,
        data: {
          'status': accepted
              ? ReservationStatus.cancelled.name
              : ReservationStatus.active.name,
          'endTime': DateTime.now().toUtc().toIso8601String(),
        },
      );

      return Reservation.fromJson(_appwrite.rowToJson(doc));
    } on AppwriteException catch (e) {
      log(e.toString(), name: 'ReservationRepository.cancelReservation');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Subscribes to real-time updates for a specific reservation.
  RealtimeSubscription reservationState(String reservationId) {
    return _appwrite.realtime.subscribe([
      'databases.$_databaseId.tables.$_collectionId.rows.$reservationId',
    ]);
  }
}
