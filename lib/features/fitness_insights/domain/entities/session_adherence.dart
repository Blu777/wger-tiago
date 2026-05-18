import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_adherence.freezed.dart';

/// Per-exercise adherence record: planned (adapted) vs actually executed.
@freezed
sealed class ExerciseAdherence with _$ExerciseAdherence {
  const factory ExerciseAdherence({
    required String exerciseName,

    /// Weight the coach recommended for this exercise.
    required num plannedWeight,

    /// Weight the user actually logged.
    required num executedWeight,

    /// Reps the coach recommended.
    required num plannedReps,

    /// Reps the user actually logged.
    required num executedReps,

    /// Whether the user overrode the coach recommendation.
    @Default(false) bool wasOverridden,
  }) = _ExerciseAdherence;
}

/// Adherence summary for a complete workout session.
@freezed
sealed class SessionAdherence with _$SessionAdherence {
  const factory SessionAdherence({
    /// Date of the session.
    required DateTime date,

    /// Whether the session was coach-adapted.
    required bool wasAdapted,

    /// Per-exercise adherence details.
    @Default([]) List<ExerciseAdherence> exercises,

    /// Overall adherence score (0-100).
    /// 100 = user followed every recommendation exactly.
    required num overallScore,

    /// How many exercises the user overrode vs total.
    @Default(0) int overrideCount,

    /// Total number of tracked exercises.
    @Default(0) int totalExercises,
  }) = _SessionAdherence;
}
