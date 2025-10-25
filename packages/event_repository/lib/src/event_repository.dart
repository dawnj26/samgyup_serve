import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:event_repository/event_repository.dart';

/// {@template event_repository}
/// Repository for managing events.
/// {@endtemplate}
class EventRepository {
  /// {@macro event_repository}
  EventRepository({
    AppwriteRepository? appwrite,
  }) : _appwrite = appwrite ?? AppwriteRepository.instance;

  final AppwriteRepository _appwrite;

  String get _collectionId => _appwrite.environment.eventCollectionId;
  String get _databaseId => _appwrite.environment.databaseId;
  String get _event => 'databases.$_databaseId.tables.$_collectionId.rows';

  /// Subscribes to real-time event updates.
  RealtimeSubscription get eventState => _appwrite.realtime.subscribe([_event]);

  /// Creates a new event.
  Future<Event> createEvent(Event event) async {
    try {
      final e = event.copyWith(
        id: ID.unique(),
      );

      final response = await _appwrite.databases.createRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: e.id,
        data: e.toJson(),
      );
      return Event.fromJson(_appwrite.rowToJson(response));
    } on AppwriteException catch (e) {
      log('Failed to create event: $e', name: 'EventRepository.createEvent');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Retrieves a list of events.
  Future<List<Event>> getEvents({
    List<EventStatus>? statuses,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final startOfDay = DateTime.utc(now.year, now.month, now.day);

      final queries = <String>[
        Query.orderAsc(r'$createdAt'),
        if (statuses != null && statuses.isNotEmpty)
          Query.equal('status', statuses.map((e) => e.name).toList()),
        Query.greaterThanEqual(r'$createdAt', startOfDay.toIso8601String()),
      ];

      final response = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: queries,
      );
      return response.rows
          .map((row) => Event.fromJson(_appwrite.rowToJson(row)))
          .toList();
    } on AppwriteException catch (e) {
      log('Failed to get events: $e', name: 'EventRepository.getEvents');
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Marks an event as completed.
  Future<void> completeEvent(String eventId) async {
    try {
      await _appwrite.databases.updateRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: eventId,
        data: {
          'status': EventStatus.completed.name,
        },
      );
    } on AppwriteException catch (e) {
      log(
        'Failed to complete event: $e',
        name: 'EventRepository.completeEvent',
      );
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Cancels an event.
  Future<void> cancelEvent(String eventId) async {
    try {
      await _appwrite.databases.updateRow(
        databaseId: _databaseId,
        tableId: _collectionId,
        rowId: eventId,
        data: {
          'status': EventStatus.cancelled.name,
        },
      );
    } on AppwriteException catch (e) {
      log(
        'Failed to cancel event: $e',
        name: 'EventRepository.cancelEvent',
      );
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Retrieves the current cancel event for a given table number.
  Future<Event?> getCurrentCancelEvent(int tableNumber) async {
    try {
      final now = DateTime.now().toUtc();
      final startOfDay = DateTime.utc(now.year, now.month, now.day);

      final queries = <String>[
        Query.equal('tableNumber', tableNumber),
        Query.equal('status', EventStatus.pending.name),
        Query.equal('type', EventType.orderCancelled.name),
        Query.greaterThanEqual(r'$createdAt', startOfDay.toIso8601String()),
        Query.limit(1),
      ];

      final response = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: queries,
      );

      if (response.total == 0) {
        return null;
      }

      return Event.fromJson(_appwrite.rowToJson(response.rows.first));
    } on AppwriteException catch (e) {
      log(
        'Failed to get current cancel event: $e',
        name: 'EventRepository.getCurrentCancelEvent',
      );
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Retrieves the current payment event for a given table number.
  Future<Event?> getCurrentPaymentEvent(int tableNumber) async {
    try {
      final now = DateTime.now().toUtc();
      final startOfDay = DateTime.utc(now.year, now.month, now.day);

      final queries = <String>[
        Query.equal('tableNumber', tableNumber),
        Query.equal('status', EventStatus.pending.name),
        Query.equal('type', EventType.paymentRequested.name),
        Query.greaterThanEqual(r'$createdAt', startOfDay.toIso8601String()),
        Query.limit(1),
      ];

      final response = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: queries,
      );

      if (response.total == 0) {
        return null;
      }

      return Event.fromJson(_appwrite.rowToJson(response.rows.first));
    } on AppwriteException catch (e) {
      log(
        'Failed to get current payment event: $e',
        name: 'EventRepository.getCurrentPaymentEvent',
      );
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }

  /// Retrieves events by reservation ID.
  Future<List<Event>> getEventsByReservationId(
    String reservationId,
  ) async {
    try {
      final response = await _appwrite.databases.listRows(
        databaseId: _databaseId,
        tableId: _collectionId,
        queries: [
          Query.equal('reservationId', reservationId),
          Query.orderAsc(r'$createdAt'),
        ],
      );

      return response.rows
          .map((row) => Event.fromJson(_appwrite.rowToJson(row)))
          .toList();
    } on AppwriteException catch (e) {
      log(
        'Failed to get events by reservation ID: $e',
        name: 'EventRepository.getEventsByReservationId',
      );
      throw ResponseException.fromCode(e.code ?? 500);
    }
  }
}
