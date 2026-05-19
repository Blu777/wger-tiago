import 'dart:math' as math;

import 'package:wger/features/fitness_insights/domain/entities/action_item.dart';
import 'package:wger/features/fitness_insights/domain/entities/coach_state.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/pre_workout_checkin.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_adaptation.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_modification.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/workouts/day_data.dart';
import 'package:wger/models/workouts/set_config_data.dart';
import 'package:wger/models/workouts/slot_data.dart';

/// Priority levels for adaptation decisions. Lower index = higher priority.
/// A field locked by a higher-priority layer cannot be overridden by a lower one.
enum _Priority {
  safety,   // P0: pain / extreme fatigue — always wins
  phase,    // P1: deload / intensification phase
  trend,    // P2: exercise progression trend (progressing, regressing)
  plan,     // P3: action plan fine-tuning
}

/// Tracks which priority level has locked each field for one exercise.
class _FieldLocks {
  _Priority? weightLock;
  _Priority? setsLock;

  /// Returns true if [field] can still be modified at [priority].
  /// Higher priority (lower index) always wins; same level is allowed
  /// (composable within a layer).
  bool canModify(String field, _Priority priority) {
    final lock = field == 'weight' ? weightLock : setsLock;
    if (lock == null) {
      return true;
    }
    return priority.index <= lock.index; // same or higher priority OK
  }

  void lock(String field, _Priority priority) {
    if (field == 'weight') {
      // Only upgrade lock, never downgrade
      if (weightLock == null || priority.index < weightLock!.index) {
        weightLock = priority;
      }
    } else {
      if (setsLock == null || priority.index < setsLock!.index) {
        setsLock = priority;
      }
    }
  }
}

/// V2 workout adaptation driven by [FitnessInsight] from the coaching system.
///
/// Priority order (highest → lowest):
///   1. **Safety** – pain / extreme fatigue caps or reduces intensity
///   2. **Phase** – deload / intensification global adjustments
///   3. **Trend** – per-exercise progression / regression signals
///   4. **ActionPlan** – fine-tuning from the coaching pipeline
///
/// Rules:
/// - Lower-priority layers CANNOT override a field locked by a higher layer.
/// - Layers are composable: safety can reduce sets AND phase can reduce weight.
/// - No adaptation when `dataQualityScore < 30`.
/// - Bodyweight exercises (no equipment) skip weight changes.
/// - All changes clamped to safe ranges (weight ±30%, sets ±2).
class AdaptWorkoutV2 {
  // Safety thresholds
  static const _painHighThreshold = 7;
  static const _painMediumThreshold = 5;
  static const _fatigueHighThreshold = 8;
  static const _fatigueMediumThreshold = 6;

  // Guardrails
  static const _minDataQuality = 30; // skip adaptation below this
  static const _maxWeightChangePct = 0.30; // ±30% cap
  static const _maxSetsDelta = 2; // ±2 sets cap

  WorkoutAdaptation call({
    required DayData originalWorkout,
    required PreWorkoutCheckin checkin,
    FitnessInsight? insight,
  }) {
    final modifications = <WorkoutModification>[];
    final adaptedSlots = <SlotData>[];

    // Guardrail: skip adaptation entirely when data quality is too low
    final lowQuality = insight != null && insight.dataQualityScore < _minDataQuality;

    // Pre-index insight data by exercise name for O(1) lookup
    final actionsByExercise = <String, ActionItem>{};
    final insightByExercise = <String, ExerciseInsight>{};
    final isDeload = insight?.trainingPhase == TrainingPhase.deload;
    final isIntensification =
        insight?.trainingPhase == TrainingPhase.intensification;

    if (insight != null && !lowQuality) {
      for (final action in insight.actionPlan.actions) {
        actionsByExercise[action.target] = action;
      }
      for (final ei in insight.exerciseInsights) {
        insightByExercise[ei.exerciseName] = ei;
      }
    }

    for (final slot in originalWorkout.slots) {
      final adaptedConfigs = <SetConfigData>[];

      for (final config in slot.setConfigs) {
        var adapted = config;
        final exercise = config.exercise;
        final exerciseName = _exerciseName(exercise);
        final originalWeight = config.weight;
        final originalSets = config.nrOfSets;
        final isBodyweight = _isBodyweightExercise(exercise);

        // Per-exercise lock tracker — enforces priority ordering
        final locks = _FieldLocks();

        // =============================================================
        // P0 — SAFETY: pain & extreme fatigue (highest priority)
        // =============================================================
        final maxPain = _maxPainForExercise(exercise, checkin);

        // Pain-based weight reduction
        if (maxPain >= _painHighThreshold &&
            adapted.weight != null &&
            !isBodyweight) {
          final reduction = maxPain >= 9 ? 0.20 : 0.10;
          adapted = _modifyWeight(
            adapted: adapted,
            factor: 1 - reduction,
            exerciseName: exerciseName,
            reason:
                '$exerciseName: dolor $maxPain/10 en '
                '${_painfulMuscles(exercise, checkin).join(", ")} '
                '→ reducir ${(reduction * 100).toInt()}% peso',
            priority: _Priority.safety,
            locks: locks,
            modifications: modifications,
            originalWeight: originalWeight,
          );
        }

        // Pain-based set reduction
        if (maxPain >= _painMediumThreshold &&
            adapted.nrOfSets != null &&
            adapted.nrOfSets! > 1) {
          adapted = _modifySets(
            adapted: adapted,
            delta: -1,
            exerciseName: exerciseName,
            reason: '$exerciseName: dolor muscular → quitar 1 serie',
            priority: _Priority.safety,
            locks: locks,
            modifications: modifications,
            originalSets: originalSets,
          );
        }

        // Extreme fatigue → reduce sets
        if (checkin.fatigue >= _fatigueHighThreshold &&
            adapted.nrOfSets != null &&
            adapted.nrOfSets! > 1) {
          adapted = _modifySets(
            adapted: adapted,
            delta: -1,
            exerciseName: exerciseName,
            reason: 'Fatiga extrema ${checkin.fatigue}/10 → quitar 1 serie',
            priority: _Priority.safety,
            locks: locks,
            modifications: modifications,
            originalSets: originalSets,
          );
        }

        // Medium fatigue → reduce weight 5%
        if (checkin.fatigue >= _fatigueMediumThreshold &&
            checkin.fatigue < _fatigueHighThreshold &&
            adapted.weight != null &&
            !isBodyweight) {
          adapted = _modifyWeight(
            adapted: adapted,
            factor: 0.95,
            exerciseName: exerciseName,
            reason: 'Fatiga ${checkin.fatigue}/10 → reducir 5% peso',
            priority: _Priority.safety,
            locks: locks,
            modifications: modifications,
            originalWeight: originalWeight,
          );
        }

        // =============================================================
        // P1 — PHASE: deload / intensification (only with valid insight)
        // =============================================================
        if (insight != null && !lowQuality) {
          if (isDeload && adapted.weight != null && !isBodyweight) {
            adapted = _modifyWeight(
              adapted: adapted,
              factor: 0.60,
              exerciseName: exerciseName,
              reason: 'Fase de deload → reducir peso 40%',
              priority: _Priority.phase,
              locks: locks,
              modifications: modifications,
              originalWeight: originalWeight,
            );
          }

          // Intensification: no additional weight, but prevent set reduction
          // from lower layers by locking sets at current value.
          if (isIntensification) {
            locks.lock('sets', _Priority.phase);
          }
        }

        // =============================================================
        // P2 — TREND: per-exercise progression signals
        // =============================================================
        if (insight != null && !lowQuality && !isBodyweight) {
          final ei = insightByExercise[exerciseName];
          if (ei != null && adapted.weight != null) {
            switch (ei.progressStatus) {
              case ExerciseProgressStatus.progressing:
                // Only increase if safety didn't cap weight
                adapted = _modifyWeight(
                  adapted: adapted,
                  factor: 1.025,
                  exerciseName: exerciseName,
                  reason: '$exerciseName progresando → +2.5% peso',
                  priority: _Priority.trend,
                  locks: locks,
                  modifications: modifications,
                  originalWeight: originalWeight,
                );

              case ExerciseProgressStatus.regression:
                adapted = _modifyWeight(
                  adapted: adapted,
                  factor: 0.90,
                  exerciseName: exerciseName,
                  reason: '$exerciseName en regresión → -10% peso',
                  priority: _Priority.trend,
                  locks: locks,
                  modifications: modifications,
                  originalWeight: originalWeight,
                );

              case ExerciseProgressStatus.stalled:
                // No weight change; volume handled by action plan
                break;
            }
          }
        }

        // =============================================================
        // P3 — ACTION PLAN: fine-tuning (lowest priority)
        // =============================================================
        if (insight != null && !lowQuality && !isDeload) {
          final action = actionsByExercise[exerciseName];
          if (action != null) {
            adapted = _applyAction(
              adapted: adapted,
              action: action,
              exerciseName: exerciseName,
              locks: locks,
              modifications: modifications,
              isBodyweight: isBodyweight,
              originalWeight: originalWeight,
              originalSets: originalSets,
            );
          }
        }

        adaptedConfigs.add(adapted);
      }

      adaptedSlots.add(SlotData(
        comment: slot.comment,
        isSuperset: slot.isSuperset,
        exerciseIds: slot.exerciseIds,
        setConfigs: adaptedConfigs,
      ));
    }

    return WorkoutAdaptation(
      originalSlots: originalWorkout.slots,
      adaptedSlots: adaptedSlots,
      modifications: modifications,
      checkin: checkin,
    );
  }

  // ------------------------------------------------------------------
  //  Priority-aware field modifiers with clamping
  // ------------------------------------------------------------------

  /// Modifies weight by [factor] (e.g. 0.90 = -10%, 1.025 = +2.5%).
  /// Respects priority locks and clamps total change to ±[_maxWeightChangePct].
  SetConfigData _modifyWeight({
    required SetConfigData adapted,
    required double factor,
    required String exerciseName,
    required String reason,
    required _Priority priority,
    required _FieldLocks locks,
    required List<WorkoutModification> modifications,
    required num? originalWeight,
  }) {
    if (adapted.weight == null || !locks.canModify('weight', priority)) {
      return adapted;
    }

    var newWeight = adapted.weight! * factor;

    // Clamp total deviation from original to ±_maxWeightChangePct
    if (originalWeight != null && originalWeight > 0) {
      final minAllowed = originalWeight * (1 - _maxWeightChangePct);
      final maxAllowed = originalWeight * (1 + _maxWeightChangePct);
      newWeight = newWeight.clamp(minAllowed, maxAllowed);
    }

    // Skip if effectively no change (< 0.5 kg difference)
    if ((newWeight - adapted.weight!).abs() < 0.5) {
      return adapted;
    }

    modifications.add(WorkoutModification(
      exerciseName: exerciseName,
      field: 'weight',
      originalValue: adapted.weight!,
      adaptedValue: newWeight,
      reason: reason,
    ));
    locks.lock('weight', priority);
    return adapted.copyWith(weight: newWeight);
  }

  /// Modifies sets by [delta] (positive = add, negative = remove).
  /// Respects priority locks and clamps total change to ±[_maxSetsDelta].
  SetConfigData _modifySets({
    required SetConfigData adapted,
    required int delta,
    required String exerciseName,
    required String reason,
    required _Priority priority,
    required _FieldLocks locks,
    required List<WorkoutModification> modifications,
    required num? originalSets,
  }) {
    if (adapted.nrOfSets == null || !locks.canModify('sets', priority)) {
      return adapted;
    }

    var newSets = adapted.nrOfSets! + delta;

    // Clamp total deviation from original to ±_maxSetsDelta
    if (originalSets != null) {
      final minAllowed = math.max(1, originalSets - _maxSetsDelta);
      final maxAllowed = originalSets + _maxSetsDelta;
      newSets = newSets.clamp(minAllowed, maxAllowed);
    } else {
      newSets = math.max(1, newSets); // absolute floor: 1 set
    }

    // Skip if no effective change
    if (newSets == adapted.nrOfSets) {
      return adapted;
    }

    modifications.add(WorkoutModification(
      exerciseName: exerciseName,
      field: 'sets',
      originalValue: adapted.nrOfSets!,
      adaptedValue: newSets,
      reason: reason,
    ));
    locks.lock('sets', priority);
    return adapted.copyWith(nrOfSets: newSets);
  }

  // ------------------------------------------------------------------
  //  Action plan helper (P3)
  // ------------------------------------------------------------------

  SetConfigData _applyAction({
    required SetConfigData adapted,
    required ActionItem action,
    required String exerciseName,
    required _FieldLocks locks,
    required List<WorkoutModification> modifications,
    required bool isBodyweight,
    required num? originalWeight,
    required num? originalSets,
  }) {
    switch (action.type) {
      case ActionType.increaseWeight:
        if (isBodyweight) {
          break; // skip weight changes for bodyweight exercises
        }
        if (adapted.weight != null) {
          // Contradiction guard: don't increase weight if safety/phase already
          // reduced it (i.e., weight lock exists at higher priority).
          if (!locks.canModify('weight', _Priority.plan)) {
            break;
          }
          final increase = action.value.toDouble();
          final factor = (adapted.weight! + increase) / adapted.weight!;
          adapted = _modifyWeight(
            adapted: adapted,
            factor: factor,
            exerciseName: exerciseName,
            reason: 'Coach: ${action.reason}',
            priority: _Priority.plan,
            locks: locks,
            modifications: modifications,
            originalWeight: originalWeight,
          );
        }

      case ActionType.reduceVolume:
        if (adapted.nrOfSets != null && adapted.nrOfSets! > 1) {
          final reductionPct = action.value / 100;
          final setsToRemove =
              (adapted.nrOfSets! * reductionPct).ceil().clamp(1, _maxSetsDelta);
          adapted = _modifySets(
            adapted: adapted,
            delta: -setsToRemove,
            exerciseName: exerciseName,
            reason: 'Coach: ${action.reason}',
            priority: _Priority.plan,
            locks: locks,
            modifications: modifications,
            originalSets: originalSets,
          );
        }

      case ActionType.addSets:
        adapted = _modifySets(
          adapted: adapted,
          delta: action.value.toInt().clamp(1, _maxSetsDelta),
          exerciseName: exerciseName,
          reason: 'Coach: ${action.reason}',
          priority: _Priority.plan,
          locks: locks,
          modifications: modifications,
          originalSets: originalSets,
        );

      case ActionType.deload:
        if (isBodyweight) {
          break;
        }
        if (adapted.weight != null) {
          final factor = 1 - action.value / 100;
          adapted = _modifyWeight(
            adapted: adapted,
            factor: factor,
            exerciseName: exerciseName,
            reason: 'Coach: ${action.reason}',
            priority: _Priority.plan,
            locks: locks,
            modifications: modifications,
            originalWeight: originalWeight,
          );
        }

      case ActionType.addReps:
        // Reps are not modified in SetConfigData (the wger model doesn't support
        // per-session rep overrides). Instead, emit a display-only WorkoutModification
        // so the preview screen surfaces the recommendation to the user.
        if (adapted.repetitions != null) {
          modifications.add(WorkoutModification(
            exerciseName: exerciseName,
            field: 'reps',
            originalValue: adapted.repetitions!,
            adaptedValue: adapted.repetitions! + action.value,
            reason: 'Coach: ${action.reason}',
          ));
        }

      case ActionType.maintain:
        break;
    }

    return adapted;
  }

  // ------------------------------------------------------------------
  //  Checkin helpers
  // ------------------------------------------------------------------

  int _maxPainForExercise(Exercise? exercise, PreWorkoutCheckin checkin) {
    if (exercise == null) {
      return 0;
    }
    var maxPain = 0;
    for (final m in [...exercise.muscles, ...exercise.musclesSecondary]) {
      final pain = checkin.painForMuscle(m.name);
      if (pain > maxPain) {
        maxPain = pain;
      }
    }
    return maxPain;
  }

  List<String> _painfulMuscles(Exercise? exercise, PreWorkoutCheckin checkin) {
    if (exercise == null) {
      return [];
    }
    final names = <String>[];
    for (final m in [...exercise.muscles, ...exercise.musclesSecondary]) {
      if (checkin.painForMuscle(m.name) > 0) {
        names.add(m.name);
      }
    }
    return names;
  }

  /// True when the exercise uses no equipment (bodyweight only).
  bool _isBodyweightExercise(Exercise? exercise) {
    if (exercise == null) {
      return false;
    }
    return exercise.equipment.isEmpty;
  }

  String _exerciseName(Exercise? exercise) {
    if (exercise == null || exercise.translations.isEmpty) {
      return 'Ejercicio';
    }
    try {
      return exercise.getTranslation('es').name;
    } catch (_) {
      try {
        return exercise.getTranslation('en').name;
      } catch (_) {
        return exercise.translations.first.name;
      }
    }
  }
}
