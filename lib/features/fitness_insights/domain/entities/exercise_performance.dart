import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_set.dart';

part 'exercise_performance.freezed.dart';

/// Aggregated performance of a single exercise within a training session.
@freezed
sealed class ExercisePerformance with _$ExercisePerformance {
  const factory ExercisePerformance({
    /// Internal exercise ID from wger.
    required int exerciseId,

    /// Human-readable exercise name.
    required String exerciseName,

    /// Individual sets performed for this exercise.
    required List<ExerciseSet> sets,

    /// Muscle groups targeted by this exercise (primary + secondary).
    @Default([]) List<String> muscleNames,
  }) = _ExercisePerformance;
}
