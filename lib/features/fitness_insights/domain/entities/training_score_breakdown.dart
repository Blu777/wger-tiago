import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_score_breakdown.freezed.dart';

/// Component-level breakdown of the training score (0-100).
@freezed
sealed class TrainingScoreBreakdown with _$TrainingScoreBreakdown {
  const factory TrainingScoreBreakdown({
    /// Score derived from exercise progression (0-40).
    required num progressScore,

    /// Score derived from training adherence (0-25).
    required num adherenceScore,

    /// Score derived from fatigue management (0-20).
    required num fatigueScore,

    /// Score derived from data quality (0-15).
    required num dataQualityScore,

    /// Total computed score.
    required num total,
  }) = _TrainingScoreBreakdown;
}
