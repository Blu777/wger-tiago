import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_item.dart';

part 'coach_state.freezed.dart';

/// Detected training phase based on accumulated stress and progression signals.
enum TrainingPhase {
  accumulation,
  intensification,
  deload,
  recovery,
}

/// Immutable snapshot of coaching context persisted between analysis runs.
/// Passed back into the next [AnalyzeTraining] call to avoid repetitive decisions.
@freezed
sealed class CoachState with _$CoachState {
  const factory CoachState({
    /// Phase from the previous analysis cycle.
    TrainingPhase? lastPhase,

    /// The two most recent action items (most recent first).
    @Default([]) List<ActionItem> lastActions,

    /// ISO week number of the last deload (to prevent back-to-back deloads).
    int? lastDeloadWeek,
  }) = _CoachState;
}
