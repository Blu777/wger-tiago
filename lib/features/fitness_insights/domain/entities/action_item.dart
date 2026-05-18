import 'package:freezed_annotation/freezed_annotation.dart';

part 'action_item.freezed.dart';

/// Types of coaching actions.
enum ActionType {
  increaseWeight,
  addReps,
  addSets,
  reduceVolume,
  deload,
  maintain,
}

/// A single, actionable coaching directive.
@freezed
sealed class ActionItem with _$ActionItem {
  const factory ActionItem({
    /// Type of action.
    required ActionType type,

    /// Target entity name (exercise or muscle group).
    required String target,

    /// Numeric value associated with the action (kg, sets, %, etc.).
    required num value,

    /// Impact priority (1 = highest, 3 = lowest).
    @Default(2) int priority,

    /// Human-readable justification for the action.
    required String reason,

    /// Detailed explanation shown when the user taps the action.
    @Default('') String detailReason,
  }) = _ActionItem;
}
