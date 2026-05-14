import 'package:freezed_annotation/freezed_annotation.dart';

part 'subjective_feedback.freezed.dart';

/// Subjective feedback entry provided by the user.
/// Independent entity; falls back to [TrainingSession.impression] when absent.
@freezed
sealed class SubjectiveFeedback with _$SubjectiveFeedback {
  const factory SubjectiveFeedback({
    /// Date of the feedback entry.
    required DateTime date,

    /// Fatigue level on a 1–10 scale (10 = extreme fatigue).
    required int fatigue,

    /// Energy level on a 1–10 scale (10 = peak energy).
    required int energy,
  }) = _SubjectiveFeedback;
}
