import 'package:authentication_repository/authentication_repository.dart'
    show $UserCopyWith, User;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:log_repository/src/enums/enums.dart';

part 'log.freezed.dart';
part 'log.g.dart';

/// Represents a log entry for tracking user actions on resources.
@freezed
abstract class Log with _$Log {
  /// Creates a new Log instance.
  const factory Log.base({
    /// Unique identifier for the log entry.
    required String id,

    /// ID of the user who performed the action.
    required String userId,

    /// ID of the resource being acted upon.
    required String resourceId,

    /// The action that was performed.
    required LogAction action,

    /// Timestamp when the log entry was created.
    required DateTime createdAt,

    /// Human-readable description of the action.
    required String message,

    /// Additional details about the action.
    String? details,

    /// Timestamp when the log entry was last updated.
    DateTime? updatedAt,
  }) = LogBase;

  /// Creates a new Log instance.
  factory Log.full({
    /// Unique identifier for the log entry.
    required String id,

    /// ID of the user who performed the action.
    required String userId,

    /// ID of the resource being acted upon.
    required String resourceId,

    /// The action that was performed.
    required LogAction action,

    /// Timestamp when the log entry was created.
    required DateTime createdAt,

    /// Human-readable description of the action.
    required String message,

    /// The user who performed the action.
    required User user,

    /// Additional details about the action.
    String? details,

    /// Timestamp when the log entry was last updated.
    DateTime? updatedAt,
  }) = LogFull;

  /// Creates a Log instance from a JSON map.
  factory Log.fromJson(Map<String, dynamic> json) => _$LogFromJson(json);
}
