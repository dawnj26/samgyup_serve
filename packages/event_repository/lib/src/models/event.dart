import 'package:event_repository/src/enums/enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

/// Represents an event in the restaurant system.
///
/// Events track various activities related to table reservations
/// and their current status in the workflow.
@freezed
abstract class Event with _$Event {
  /// Creates a new Event instance.
  ///
  /// [reservationId] - Unique identifier for the reservation
  /// [tableNumber] - Table number associated with this event
  /// [type] - Current status/type of the event
  /// [payload] - Additional data related to the event
  /// [id] - Unique event identifier (defaults to empty string)
  /// [createdAt] - Timestamp when the event was created
  /// [updatedAt] - Timestamp when the event was last updated
  const factory Event({
    required String reservationId,
    required int tableNumber,
    required String payload,
    required EventType type,
    @Default(EventStatus.pending) EventStatus status,
    @Default('') String id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Event;

  /// Returns an empty Event instance with default values.
  factory Event.empty() => const _Event(
    reservationId: '',
    tableNumber: 0,
    payload: '',
    type: EventType.orderCreated,
  );

  /// Creates an Event instance from a JSON map.
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
