import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_plan.dart';
import 'package:wger/features/fitness_insights/domain/entities/adherence_metrics.dart';
import 'package:wger/features/fitness_insights/domain/entities/coach_state.dart';
import 'package:wger/features/fitness_insights/domain/entities/coach_summary.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/muscle_analysis.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_score_breakdown.dart';

part 'fitness_insight.freezed.dart';

/// Possible fitness statuses resulting from the analysis.
enum FitnessStatus {
  goodProgress,
  stalled,
  overtraining,
  inconsistent,
}

/// Consolidated insight produced by the [AnalyzeTraining] use case.
@freezed
sealed class FitnessInsight with _$FitnessInsight {
  const factory FitnessInsight({
    /// Overall fitness status determined by deterministic rules.
    required FitnessStatus status,

    /// Average weekly weight change over the analysis period.
    num? weeklyWeightChange,

    /// Whether strength is progressing across the majority of tracked exercises.
    required bool isStrengthProgressing,

    /// Estimated fatigue level (1–10 scale).
    num? fatigueLevel,

    /// Names of exercises that have stalled (no improvement for 2+ weeks).
    @Default([]) List<String> stalledExercises,

    /// Names of exercises with a significant performance drop (>5%).
    @Default([]) List<String> droppedExercises,

    /// Training adherence metrics.
    required AdherenceMetrics adherenceMetrics,

    /// Fatigue trend: negative = decreasing, positive = increasing, 0/null = stable.
    num? fatigueTrend,

    /// Data quality score (0–100) based on session/exercise coverage.
    required num dataQualityScore,

    /// Total volume (weight × reps) per exercise over the analysis period.
    @Default({}) Map<String, num> exerciseVolumes,

    /// Detailed insights for each tracked exercise.
    @Default([]) List<ExerciseInsight> exerciseInsights,

    /// Analysis per muscle group (key = muscle name).
    @Default({}) Map<String, MuscleAnalysis> muscleAnalysis,

    /// Overall training effectiveness score (0–100).
    required num trainingScore,

    /// Detailed breakdown of how the training score was computed.
    TrainingScoreBreakdown? trainingScoreBreakdown,

    /// Weekly action plan with specific coaching directives.
    @Default(ActionPlan()) ActionPlan actionPlan,

    /// Detected training phase for temporal context.
    TrainingPhase? trainingPhase,

    /// Human-readable coaching summary.
    CoachSummary? coachSummary,

    /// Persisted coaching state for the next analysis cycle.
    CoachState? coachState,

    /// Actionable recommendations derived from the analysis.
    @Default([]) List<String> recommendations,

    /// Optional human-readable summary (populated by a formatter service).
    String? summaryText,
  }) = _FitnessInsight;
}
