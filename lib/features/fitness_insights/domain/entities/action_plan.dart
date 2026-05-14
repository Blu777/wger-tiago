import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_item.dart';

part 'action_plan.freezed.dart';

/// Consolidated weekly action plan generated from the analysis.
/// Contains at most 3 high-impact, non-conflicting actions.
@freezed
sealed class ActionPlan with _$ActionPlan {
  const factory ActionPlan({
    /// Ordered list of actions (already sorted by priority).
    @Default([]) List<ActionItem> actions,

    /// Overall coaching directive for the week.
    @Default('') String summary,
  }) = _ActionPlan;
}
