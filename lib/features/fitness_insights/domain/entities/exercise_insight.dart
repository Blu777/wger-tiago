import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_insight.freezed.dart';

/// Status of an individual exercise's progression.
enum ExerciseProgressStatus {
  progressing,
  stalled,
  regression,
}

/// Detailed insight for a single exercise.
@freezed
sealed class ExerciseInsight with _$ExerciseInsight {
  const factory ExerciseInsight({
    /// Exercise name.
    required String exerciseName,

    /// Current estimated 1RM (average of last 2 weeks).
    required num currentE1rm,

    /// Previous estimated 1RM (average of prior 2 weeks).
    required num previousE1rm,

    /// Percentage change between current and previous e1RM.
    required num e1rmChangePercent,

    /// Total volume (weight × reps) over the analysis period.
    required num totalVolume,

    /// Number of sessions this exercise was performed in.
    required int sessionCount,

    /// Progression status.
    required ExerciseProgressStatus progressStatus,

    /// Specific recommendation for this exercise.
    required String recommendation,
  }) = _ExerciseInsight;
}
