part of 'activity_bloc.dart';

enum ActivityStatus { initial, active, inactive }

@freezed
abstract class ActivityState with _$ActivityState {
  const factory ActivityState.initial({
    @Default(ActivityStatus.initial) ActivityStatus status,
  }) = _Initial;
}
