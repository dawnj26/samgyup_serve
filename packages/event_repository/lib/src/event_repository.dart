import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite_repository/appwrite_repository.dart';
import 'package:event_repository/src/models/models.dart';

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
}
