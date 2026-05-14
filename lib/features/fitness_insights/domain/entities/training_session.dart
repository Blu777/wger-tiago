import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_performance.dart';

part 'training_session.freezed.dart';

/// Domain representation of a completed workout session.
/// Mapped from the wger [WorkoutSession] model.
@freezed
sealed class TrainingSession with _$TrainingSession {
  const factory TrainingSession({
    /// Date when the session was performed.
    required DateTime date,

    /// Exercises performed in this session.
    required List<ExercisePerformance> exercises,

    /// Optional subjective impression (1=bad, 2=neutral, 3=good).
    /// Sourced from [WorkoutSession.impression].
    int? impression,

    /// Optional session duration in minutes.
    int? durationMinutes,
  }) = _TrainingSession;
}
