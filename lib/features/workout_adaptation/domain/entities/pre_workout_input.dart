import 'package:freezed_annotation/freezed_annotation.dart';

part 'pre_workout_input.freezed.dart';

/// Pre-workout subjective check-in used to adapt the planned session.
@freezed
sealed class PreWorkoutInput with _$PreWorkoutInput {
  const factory PreWorkoutInput({
    /// Per-muscle pain level (0–10). Key = muscle name, Value = pain score.
    @Default({}) Map<String, int> painByMuscle,

    /// Overall subjective fatigue (0–10).
    @Default(0) num fatigue,
  }) = _PreWorkoutInput;
}
