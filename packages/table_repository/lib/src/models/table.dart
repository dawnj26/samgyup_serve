import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_repository/src/enums/enums.dart';

part 'table.freezed.dart';
part 'table.g.dart';

/// Represents a restaurant table with its properties and metadata.
///
/// This model contains information about table capacity, unique identifiers,
/// reservation status, and timestamps for tracking creation and updates.
@freezed
abstract class Table with _$Table {
  /// Creates a new [Table] instance.
  ///
  /// [number] is the table's display number used for identification.
  /// [capacity] indicates the maximum number of guests the table can seat.
  /// [id] is a unique identifier, defaults to empty string if not provided.
  /// [reservationId] links to a reservation if the table is reserved.
  /// [createdAt] timestamp when the table record was created.
  /// [updatedAt] timestamp when the table record was last modified.
  const factory Table({
    /// The table number displayed to staff and customers
    required int number,

    /// Maximum number of guests this table can accommodate
    required int capacity,

    /// Current operational status of the table
    required TableStatus status,

    /// Unique identifier for the table
    @Default('') String id,

    /// ID of the reservation if table is reserved, null if available
    String? reservationId,

    /// Timestamp when this table record was created
    DateTime? createdAt,

    /// Timestamp when this table record was last updated
    DateTime? updatedAt,
  }) = _Table;

  /// Creates an empty [Table] instance with default values.
  factory Table.empty() => const _Table(
    number: 0,
    capacity: 0,
    status: TableStatus.available,
  );

  /// Creates a [Table] instance from a JSON map.
  factory Table.fromJson(Map<String, dynamic> json) => _$TableFromJson(json);
}
