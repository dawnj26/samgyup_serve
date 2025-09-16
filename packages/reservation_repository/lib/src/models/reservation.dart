import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:reservation_repository/src/enums/enums.dart';

part 'reservation.freezed.dart';
part 'reservation.g.dart';

/// {@template reservation}
/// Represents a table reservation in the restaurant system.
///
/// Tracks table occupancy, timing, and billing information
/// for restaurant table management.
/// {@endtemplate}
@freezed
abstract class Reservation with _$Reservation {
  /// {@macro reservation}
  factory Reservation({
    /// The ID of the table being reserved
    required String tableId,

    /// When the reservation started
    required DateTime startTime,

    /// The invoice ID associated with this reservation
    required String invoiceId,

    /// Current status of the reservation
    @Default(ReservationStatus.active) ReservationStatus status,

    /// ID of the reservation
    @Default('') String id,

    /// When the reservation ended (if completed)
    DateTime? endTime,

    /// When the reservation was created
    DateTime? createdAt,

    /// When the reservation was last updated
    DateTime? updatedAt,
  }) = _Reservation;

  /// Creates a Reservation from a JSON map.
  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}
