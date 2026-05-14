import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wger/features/workout_adaptation/domain/entities/exercise_modification.dart';

part 'adapted_workout.freezed.dart';

/// Result of adapting a planned workout based on fitness insights and pre-workout input.
@freezed
sealed class AdaptedWorkout with _$AdaptedWorkout {
  const factory AdaptedWorkout({
    /// Ordered list of modifications per exercise.
    @Default([]) List<ExerciseModification> modifications,

    /// Human-readable summary of what changed and why.
    @Default('') String summary,
  }) = _AdaptedWorkout;
}
