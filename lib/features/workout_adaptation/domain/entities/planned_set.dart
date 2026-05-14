import 'package:freezed_annotation/freezed_annotation.dart';

part 'planned_set.freezed.dart';

/// A single set configuration within a planned exercise.
@freezed
sealed class PlannedSet with _$PlannedSet {
  const factory PlannedSet({
    /// Planned weight for this set.
    required num weight,

    /// Planned repetitions for this set.
    required num repetitions,

    /// Number of sets at this configuration.
    required num sets,
  }) = _PlannedSet;
}
