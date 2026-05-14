import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise_set.freezed.dart';

/// A single set within an exercise performance.
/// Immutable value object from the domain layer.
@freezed
sealed class ExerciseSet with _$ExerciseSet {
  const factory ExerciseSet({
    /// Weight lifted in this set (kg or lb).
    required num weight,

    /// Repetitions performed in this set.
    required num repetitions,
  }) = _ExerciseSet;
}
