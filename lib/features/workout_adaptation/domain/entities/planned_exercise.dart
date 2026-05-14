import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wger/features/workout_adaptation/domain/entities/planned_set.dart';

part 'planned_exercise.freezed.dart';

/// Simplified domain representation of a planned exercise for adaptation.
@freezed
sealed class PlannedExercise with _$PlannedExercise {
  const factory PlannedExercise({
    /// Exercise ID.
    required int exerciseId,

    /// Exercise display name.
    required String exerciseName,

    /// Muscle groups targeted (primary + secondary).
    @Default([]) List<String> muscleNames,

    /// Planned sets for this exercise.
    @Default([]) List<PlannedSet> plannedSets,
  }) = _PlannedExercise;
}
