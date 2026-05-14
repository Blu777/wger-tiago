import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_modification.freezed.dart';

/// Type of modification applied to a planned exercise.
enum ModificationType {
  remove,
  reduceVolume,
  reduceWeight,
  maintain,
}

/// A single modification applied to one exercise in the planned workout.
@freezed
sealed class ExerciseModification with _$ExerciseModification {
  const factory ExerciseModification({
    /// Type of change.
    required ModificationType type,

    /// Target exercise name.
    required String exerciseName,

    /// Human-readable reason for the modification.
    required String reason,

    /// New weight after modification (null if unchanged).
    num? newWeight,

    /// New set count after modification (null if unchanged).
    num? newSets,
  }) = _ExerciseModification;
}
