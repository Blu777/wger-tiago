import 'dart:math' as math;

import 'package:wger/features/fitness_insights/domain/entities/action_item.dart';
import 'package:wger/features/fitness_insights/domain/entities/coach_state.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/pre_workout_checkin.dart';
import 'package:wger/features/fitness_insights/domain/entities/stress_state.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_adaptation.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_modification.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/workouts/day_data.dart';
import 'package:wger/models/workouts/set_config_data.dart';
import 'package:wger/models/workouts/slot_data.dart';

// ---------------------------------------------------------------------------
//  Decision model — pure data, no SetConfigData mutation
// ---------------------------------------------------------------------------

/// Encapsulates the complete adaptation decision for one exercise config.
///
/// Architecture:
///   Domain 1 — **Stress impact** (limits performance):
///     A single [StressState] is computed from pain + fatigue + externalLoad.
///     It produces one [stressWeightFactor] and one [stressSetsDelta].
///     These cannot be overridden by progression signals.
///
///   Domain 2 — **Performance trend** (drives progression):
///     e1RM trend + action plan contribute [trendWeightFactor] and [planSetsDelta].
///     These are only applied when [StressTier] permits.
///
///   Domain 3 — **Phase override** (deload / intensification):
///     Sits between stress and trend; can force deload regardless of trend.
///
/// Weight composition:
///   finalWeight = originalWeight
///                 × stressWeightFactor   (stress domain, always applied)
///                 × phaseWeightFactor    (phase domain)
///                 × trendWeightFactor    (trend domain; suppressed when stress high)
///                 + planWeightAbsoluteKg (plan kg increase; suppressed when stress reduces)
///
/// Sets composition:
///   Business rules gate the final delta:
///     • addSets suppressed when StressTier ≥ moderate
///     • reduceSets from stress + phase always respected
///     • plan addSets suppressed when stress-derived setsDelta is already negative
class _AdaptationDecision {
  /// Unified stress model for this exercise.
  final StressState stressState;

  /// Weight factor from the stress domain (≤ 1.0 always; never increases weight).
  final double stressWeightFactor;

  /// Weight factor from the phase domain (deload = 0.60; intensification = 1.0).
  final double phaseWeightFactor;

  /// Weight factor from the trend domain (progressing = 1.025; regression = 0.90).
  /// Only applied when stress tier permits progression.
  final double trendWeightFactor;

  /// Absolute kg increase from the action plan (applied additively after factors).
  /// For ActionType.deload sentinel: stored as a negative value (percentage).
  final double planWeightAbsoluteKg;

  /// Sets delta from the stress domain (always ≤ 0).
  final int stressSetsDelta;

  /// Sets delta from the phase domain (deload = −1; intensification = 0).
  final int phaseSetsDelta;

  /// Sets delta from the action plan (positive = add, negative = reduce).
  /// Business-rule gated: suppressed if stress domain already reduces sets
  /// and the plan also tries to add sets.
  final int planSetsDelta;

  /// Whether stress or phase has already reduced weight.
  /// Blocks trend increases and plan increases.
  final bool weightReducedByStressOrPhase;

  /// Whether intensification phase is active (blocks plan-level set reductions).
  final bool isIntensification;

  /// Explanation artefacts for the UI.
  final AdaptationExplanation explanation;

  const _AdaptationDecision({
    required this.stressState,
    this.stressWeightFactor = 1.0,
    this.phaseWeightFactor = 1.0,
    this.trendWeightFactor = 1.0,
    this.planWeightAbsoluteKg = 0.0,
    this.stressSetsDelta = 0,
    this.phaseSetsDelta = 0,
    this.planSetsDelta = 0,
    this.weightReducedByStressOrPhase = false,
    this.isIntensification = false,
    required this.explanation,
  });

  /// Combined weight factor from all domains.
  double get combinedWeightFactor =>
      stressWeightFactor * phaseWeightFactor * trendWeightFactor;

  /// Total sets delta after business-rule gating.
  ///
  /// Business rules:
  ///   • addSets from plan is suppressed if stress domain is already reducing sets
  ///     (contradictory signal — high stress overrides coach suggestion to add volume).
  ///   • plan set reductions are suppressed during intensification phase.
  int get totalSetsDelta {
    final stressDelta = stressSetsDelta + phaseSetsDelta;
    int effectivePlanDelta = planSetsDelta;

    // Rule: cannot add sets if stress is already pulling sets down.
    if (stressDelta < 0 && effectivePlanDelta > 0) {
      effectivePlanDelta = 0;
    }

    // Rule: plan cannot reduce sets during intensification.
    if (isIntensification && effectivePlanDelta < 0) {
      effectivePlanDelta = 0;
    }

    return stressDelta + effectivePlanDelta;
  }
}

// ---------------------------------------------------------------------------
//  V2 workout adaptation
// ---------------------------------------------------------------------------

/// V2 workout adaptation driven by [FitnessInsight] from the coaching system.
///
/// Architecture:
///   1. **Build StressState** — unify pain + fatigue + externalLoad into one
///      normalised stress score per exercise (avoids double-counting).
///   2. **Evaluate** — compute an [_AdaptationDecision] per exercise config
///      (pure functions, no mutation, order-independent).
///   3. **Apply** — materialise the decision into a new [SetConfigData]
///      (single mutation point, clamp once).
///
/// Domain separation:
///   Stress domain  → limits performance (can only reduce/cap)
///   Phase domain   → periodic override (deload / intensification)
///   Trend domain   → drives progression (only active when stress is low)
///   Plan domain    → fine-tuning from coaching pipeline (gated by stress)
///
/// Business rules (override pure math):
///   BR-1: Pain > 7 → no weight increase allowed (stress domain caps weight).
///   BR-2: StressTier ≥ moderate → addSets from plan suppressed.
///   BR-3: StressTier = critical → force deload weight factor regardless of phase.
///   BR-4: Trend increase only when StressTier = low.
///   BR-5: Plan increaseWeight only when no stress/phase reduction active.
///   BR-6: Plan addSets suppressed when stressSetsDelta < 0 (contradiction guard).
///   BR-7: Plan set reductions suppressed during intensification.
class AdaptWorkoutV2 {
  static const _defaultSets = 3;

  // Guardrails
  static const _minDataQuality = 30;
  static const _maxWeightChangePct = 0.30;
  static const _maxSetsDelta = 2;

  // Stress normalisation denominators
  static const _fatigueDenominator = 10.0;   // fatigue is 1–10
  static const _painDenominator = 10.0;      // pain is 0–10

  // Deload phase weight factor
  static const _deloadWeightFactor = 0.60;

  WorkoutAdaptation call({
    required DayData originalWorkout,
    required PreWorkoutCheckin checkin,
    FitnessInsight? insight,
  }) {
    final modifications = <WorkoutModification>[];
    final adaptedSlots = <SlotData>[];

    final lowQuality = insight != null && insight.dataQualityScore < _minDataQuality;
    final isDeload = insight?.trainingPhase == TrainingPhase.deload;
    final isIntensification = insight?.trainingPhase == TrainingPhase.intensification;

    // Confidence score — computed once per call, shared across all exercises.
    final confidenceScore = _computeConfidenceScore(insight, checkin);

    // Pre-index insight data by exercise name for O(1) lookup.
    final insightByExercise = <String, ExerciseInsight>{};
    if (insight != null && !lowQuality) {
      for (final ei in insight.exerciseInsights) {
        insightByExercise[ei.exerciseName] = ei;
      }
    }

    // Pre-index action plan actions.
    // 'Global' actions broadcast to every exercise.
    // All other targets (exercise name or muscle name) are stored in one map;
    // resolution happens per-config below.
    final actionByTarget = <String, ActionItem>{};
    ActionItem? globalAction;

    if (insight != null && !lowQuality) {
      for (final action in insight.actionPlan.actions) {
        if (action.target == 'Global') {
          globalAction = action;
        } else {
          actionByTarget[action.target] = action;
        }
      }
    }

    for (final slot in originalWorkout.slots) {
      final adaptedConfigs = <SetConfigData>[];

      for (final config in slot.setConfigs) {
        final exercise = config.exercise;
        final exerciseName = _exerciseName(exercise);
        final originalWeight = config.weight;
        final originalSets = config.nrOfSets;
        final isBodyweight = _isBodyweightExercise(exercise);
        final muscleNames = _muscleNames(exercise);

        // Resolve action plan target for this exercise.
        // Priority: exercise-name match > muscle-name match > Global fallback.
        ActionItem? resolvedAction = actionByTarget[exerciseName];
        if (resolvedAction == null && insight != null && !lowQuality) {
          for (final muscle in muscleNames) {
            final muscleAction = actionByTarget[muscle];
            if (muscleAction != null) {
              resolvedAction = muscleAction;
              break;
            }
          }
        }
        resolvedAction ??= globalAction;

        // ── Build per-exercise StressState ──────────────────────────────────
        final stressState = _buildStressState(
          exercise: exercise,
          checkin: checkin,
        );

        // ── EVALUATE — pure, no mutation ────────────────────────────────────
        final decision = _evaluate(
          exerciseName: exerciseName,
          isBodyweight: isBodyweight,
          originalSets: originalSets,
          stressState: stressState,
          insight: insight,
          lowQuality: lowQuality,
          isDeload: isDeload,
          isIntensification: isIntensification,
          insightByExercise: insightByExercise,
          resolvedAction: resolvedAction,
          confidenceScore: confidenceScore,
        );

        // ── APPLY — single mutation point ───────────────────────────────────
        final adapted = _applyDecision(
          config: config,
          decision: decision,
          exerciseName: exerciseName,
          originalWeight: originalWeight,
          originalSets: originalSets,
          isBodyweight: isBodyweight,
          modifications: modifications,
        );

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

  // ---------------------------------------------------------------------------
  //  STRESS STATE — unified readiness model per exercise
  // ---------------------------------------------------------------------------

  /// Builds a [StressState] for [exercise] from the pre-workout checkin.
  ///
  /// Pain is exercise-specific (max relevant muscle pain).
  /// Fatigue and external load are global (same for all exercises in a session).
  StressState _buildStressState({
    required Exercise? exercise,
    required PreWorkoutCheckin checkin,
  }) {
    // Normalise fatigue: checkin uses 1–10 scale; subtract 1 so 1→0, 10→1.
    final normFatigue = ((checkin.fatigue - 1) / (_fatigueDenominator - 1)).clamp(0.0, 1.0);

    // Normalise soreness: max relevant-muscle pain score for this exercise.
    final maxPain = _maxPainForExercise(exercise, checkin);
    final normSoreness = (maxPain / _painDenominator).clamp(0.0, 1.0);

    // Normalise external load: use the weight reduction factor as the canonical
    // proxy for how much this activity depletes the energy budget.
    // volumeReductionFactor is already in [0, 1].
    final sport = checkin.plannedSportActivity;
    final normExternal = sport.volumeReductionFactor.clamp(0.0, 1.0);

    return StressState(
      fatigue: normFatigue,
      soreness: normSoreness,
      externalLoad: normExternal,
    );
  }

  // ---------------------------------------------------------------------------
  //  EVALUATE — pure, no mutation
  // ---------------------------------------------------------------------------

  _AdaptationDecision _evaluate({
    required String exerciseName,
    required bool isBodyweight,
    required num? originalSets,
    required StressState stressState,
    required FitnessInsight? insight,
    required bool lowQuality,
    required bool isDeload,
    required bool isIntensification,
    required Map<String, ExerciseInsight> insightByExercise,
    required ActionItem? resolvedAction,
    required double confidenceScore,
  }) {
    final contributions = <FactorContribution>[];

    // ── DOMAIN 1: STRESS IMPACT ─────────────────────────────────────────────
    //
    // One stress score → one weight factor → one sets delta.
    // Replaces the per-signal (pain × fatigue × sport) multiplication that
    // previously double-counted overlapping signals.

    final stressTier = stressState.tier;
    final stressWeightFactor = isBodyweight ? 1.0 : stressState.weightRetentionFactor;

    // Business rule BR-3: critical stress forces deload weight regardless of phase.
    // weightRetentionFactor at critical (score ≥ 0.80) is already ≤ 0.76 by formula;
    // additional enforcement: cap at 0.70 (= −30%, the system guardrail).
    final effectiveStressWeightFactor = stressTier == StressTier.critical
        ? math.min(stressWeightFactor, 0.70)
        : stressWeightFactor;

    // Sets delta from stress: derived from StressState.maxSetsDelta.
    // Clamp so stress can never add sets (stress domain only reduces or holds).
    final rawStressSetsDelta = stressState.maxSetsDelta;
    final stressSetsDelta = math.min(0, rawStressSetsDelta);

    if (effectiveStressWeightFactor < 1.0 && !isBodyweight) {
      final pctReduction = ((1.0 - effectiveStressWeightFactor) * 100).round();
      contributions.add(FactorContribution(
        label: 'Estrés fisiológico',
        inputValue: stressState.stressScore,
        impact: -(1.0 - effectiveStressWeightFactor),
        explanation: 'Fatiga ${(stressState.fatigue * 10).round()}/10, '
            'dolor ${(stressState.soreness * 10).round()}/10, '
            'carga externa ${(stressState.externalLoad * 100).round()}% '
            '→ reducir peso $pctReduction%.',
      ));
    }

    if (stressSetsDelta < 0) {
      contributions.add(FactorContribution(
        label: 'Volumen por estrés',
        inputValue: stressState.stressScore,
        impact: stressSetsDelta.toDouble(),
        explanation: 'Nivel de estrés ${stressTier.name} '
            '(score ${stressState.stressScore.toStringAsFixed(2)}) '
            '→ $stressSetsDelta serie(s).',
      ));
    }

    final stressReducedWeight = effectiveStressWeightFactor < 1.0;

    // ── DOMAIN 2: PHASE OVERRIDE ────────────────────────────────────────────

    double phaseWeightFactor = 1.0;
    int phaseSetsDelta = 0;

    if (insight != null && !lowQuality) {
      if (isDeload && !isBodyweight) {
        phaseWeightFactor = _deloadWeightFactor;
        phaseSetsDelta = -1;
        contributions.add(const FactorContribution(
          label: 'Fase de deload',
          inputValue: 1.0,
          impact: -0.40,
          explanation: 'Semana de deload → reducir peso 40% y quitar 1 serie.',
        ));
      }
    }

    final phaseReducedWeight = phaseWeightFactor < 1.0;
    final weightReducedByStressOrPhase = stressReducedWeight || phaseReducedWeight;

    // ── DOMAIN 3: PERFORMANCE TREND ─────────────────────────────────────────
    //
    // Business rule BR-4: trend increases only when StressTier = low.
    // Regression reductions are always applied (they reduce, never conflict).

    double trendWeightFactor = 1.0;

    if (insight != null && !lowQuality && !isBodyweight) {
      final ei = insightByExercise[exerciseName];
      if (ei != null) {
        switch (ei.progressStatus) {
          case ExerciseProgressStatus.progressing:
            // BR-4: progression only when stress is genuinely low.
            if (stressTier == StressTier.low && !phaseReducedWeight) {
              // Scale increase by session count: more data = more confidence.
              // Minimum 3 sessions to apply full +2.5%; fewer → proportional.
              final sessionConfidence = math.min(1.0, ei.sessionCount / 3.0);
              final increase = 0.025 * sessionConfidence;
              if (increase > 0.005) {
                trendWeightFactor = 1.0 + increase;
                contributions.add(FactorContribution(
                  label: 'Progresión e1RM',
                  inputValue: ei.e1rmChangePercent.toDouble(),
                  impact: increase,
                  explanation: '$exerciseName progresando '
                      '(+${(ei.e1rmChangePercent * 100).toStringAsFixed(1)}%, '
                      '${ei.sessionCount} sesiones) → +${(increase * 100).toStringAsFixed(1)}% peso.',
                ));
              }
            }
          case ExerciseProgressStatus.regression:
            trendWeightFactor = 0.90;
            contributions.add(FactorContribution(
              label: 'Regresión e1RM',
              inputValue: ei.e1rmChangePercent.toDouble(),
              impact: -0.10,
              explanation: '$exerciseName en regresión '
                  '(${(ei.e1rmChangePercent * 100).toStringAsFixed(1)}%) → −10% peso.',
            ));
          case ExerciseProgressStatus.stalled:
            break;
        }
      }
    }

    // ── DOMAIN 4: ACTION PLAN ───────────────────────────────────────────────
    //
    // BR-5: increaseWeight blocked when weightReducedByStressOrPhase.
    // BR-6: addSets blocked when stressSetsDelta < 0 (enforced in totalSetsDelta).
    // BR-7: set reductions blocked during intensification (enforced in totalSetsDelta).

    double planWeightAbsoluteKg = 0.0;
    int planSetsDelta = 0;

    if (insight != null && !lowQuality && !isDeload && resolvedAction != null) {
      switch (resolvedAction.type) {
        case ActionType.increaseWeight:
          if (!isBodyweight && !weightReducedByStressOrPhase) {
            planWeightAbsoluteKg = resolvedAction.value.toDouble();
            contributions.add(FactorContribution(
              label: 'Plan del coach',
              inputValue: planWeightAbsoluteKg,
              impact: planWeightAbsoluteKg,
              explanation: 'Coach: ${resolvedAction.reason}',
            ));
          }

        case ActionType.reduceVolume:
          if (!isIntensification) {
            final reductionPct = resolvedAction.value / 100;
            final effectiveSets = originalSets?.toInt() ?? _defaultSets;
            final setsToRemove = (effectiveSets * reductionPct).ceil().clamp(1, _maxSetsDelta);
            planSetsDelta = -setsToRemove;
            contributions.add(FactorContribution(
              label: 'Plan del coach',
              inputValue: resolvedAction.value.toDouble(),
              impact: planSetsDelta.toDouble(),
              explanation: 'Coach: ${resolvedAction.reason}',
            ));
          }

        case ActionType.addSets:
          // Note: BR-6 (suppression when stressSetsDelta < 0) is enforced
          // in _AdaptationDecision.totalSetsDelta, not here, so the intent
          // is preserved in planSetsDelta for explanation purposes.
          planSetsDelta = resolvedAction.value.toInt().clamp(1, _maxSetsDelta);
          final willBeSuppressed = stressSetsDelta < 0;
          contributions.add(FactorContribution(
            label: willBeSuppressed ? 'Plan del coach (bloqueado)' : 'Plan del coach',
            inputValue: planSetsDelta.toDouble(),
            impact: willBeSuppressed ? 0.0 : planSetsDelta.toDouble(),
            explanation: willBeSuppressed
                ? 'Coach sugiere +$planSetsDelta series, pero el estrés elevado lo bloquea.'
                : 'Coach: ${resolvedAction.reason}',
          ));

        case ActionType.deload:
          if (!isBodyweight) {
            planWeightAbsoluteKg = -resolvedAction.value.toDouble();
            contributions.add(FactorContribution(
              label: 'Deload del coach',
              inputValue: resolvedAction.value.toDouble(),
              impact: -(resolvedAction.value / 100),
              explanation: 'Coach: ${resolvedAction.reason}',
            ));
          }

        case ActionType.addReps:
          // Reps are not mutated in SetConfigData (model limitation).
          // Intent surfaced via a display-only FactorContribution; the apply
          // phase reads this label to emit a WorkoutModification for the UI.
          contributions.add(FactorContribution(
            label: 'Reps recomendadas',
            inputValue: resolvedAction.value.toDouble(),
            impact: resolvedAction.value.toDouble(),
            explanation: 'Coach: ${resolvedAction.reason} (solo visualización).',
          ));

        case ActionType.maintain:
          break;
      }
    }

    // ── BUILD EXPLANATION ───────────────────────────────────────────────────

    final explanation = _buildExplanation(
      exerciseName: exerciseName,
      stressState: stressState,
      contributions: contributions,
      confidenceScore: confidenceScore,
      isDeload: isDeload,
      isIntensification: isIntensification,
      weightReducedByStressOrPhase: weightReducedByStressOrPhase,
    );

    return _AdaptationDecision(
      stressState: stressState,
      stressWeightFactor: effectiveStressWeightFactor,
      phaseWeightFactor: phaseWeightFactor,
      trendWeightFactor: trendWeightFactor,
      planWeightAbsoluteKg: planWeightAbsoluteKg,
      stressSetsDelta: stressSetsDelta,
      phaseSetsDelta: phaseSetsDelta,
      planSetsDelta: planSetsDelta,
      weightReducedByStressOrPhase: weightReducedByStressOrPhase,
      isIntensification: isIntensification,
      explanation: explanation,
    );
  }

  // ---------------------------------------------------------------------------
  //  APPLY — single mutation point
  // ---------------------------------------------------------------------------

  /// Materialises [decision] onto [config], emitting [WorkoutModification] entries.
  ///
  /// Weight:
  ///   originalWeight × combinedWeightFactor + planWeightAbsoluteKg
  ///   (or × deloadFactor for the negative sentinel).
  ///   Clamped once to ±[_maxWeightChangePct] of originalWeight.
  ///   Skipped if change < 0.5 kg.
  ///
  /// Sets:
  ///   (originalSets ?? _defaultSets) + totalSetsDelta
  ///   clamped to [max(1, original − _maxSetsDelta), original + _maxSetsDelta].
  SetConfigData _applyDecision({
    required SetConfigData config,
    required _AdaptationDecision decision,
    required String exerciseName,
    required num? originalWeight,
    required num? originalSets,
    required bool isBodyweight,
    required List<WorkoutModification> modifications,
  }) {
    var adapted = config;
    final reasonText = decision.explanation.contributions
        .where((c) => c.impact != 0.0)
        .map((c) => c.explanation)
        .join('; ');

    // ── Weight ────────────────────────────────────────────────────────────────
    if (!isBodyweight && originalWeight != null && originalWeight > 0) {
      final combinedFactor = decision.combinedWeightFactor;
      final planKg = decision.planWeightAbsoluteKg;

      double newWeight;
      if (planKg < 0) {
        final deloadFactor = 1.0 - (planKg.abs() / 100.0);
        newWeight = originalWeight * combinedFactor * deloadFactor;
      } else {
        newWeight = originalWeight * combinedFactor + planKg;
      }

      final minAllowed = originalWeight * (1 - _maxWeightChangePct);
      final maxAllowed = originalWeight * (1 + _maxWeightChangePct);
      newWeight = newWeight.clamp(minAllowed, maxAllowed);

      if ((newWeight - originalWeight).abs() >= 0.5) {
        modifications.add(WorkoutModification(
          exerciseName: exerciseName,
          field: 'weight',
          originalValue: originalWeight,
          adaptedValue: newWeight,
          reason: reasonText,
        ));
        adapted = adapted.copyWith(weight: newWeight);
      }
    }

    // ── Sets ─────────────────────────────────────────────────────────────────
    {
      final effectiveOriginal = originalSets?.toInt() ?? _defaultSets;
      final totalDelta = decision.totalSetsDelta;

      if (totalDelta != 0) {
        var newSets = effectiveOriginal + totalDelta;
        final minAllowed = math.max(1, effectiveOriginal - _maxSetsDelta);
        final maxAllowed = effectiveOriginal + _maxSetsDelta;
        newSets = newSets.clamp(minAllowed, maxAllowed);

        if (newSets != effectiveOriginal) {
          modifications.add(WorkoutModification(
            exerciseName: exerciseName,
            field: 'sets',
            originalValue: effectiveOriginal,
            adaptedValue: newSets,
            reason: reasonText,
          ));
          adapted = adapted.copyWith(nrOfSets: newSets);
        }
      }
    }

    // ── Reps recommendation (display-only) ───────────────────────────────────
    final repsContrib = decision.explanation.contributions
        .where((c) => c.label == 'Reps recomendadas')
        .firstOrNull;
    if (repsContrib != null && adapted.repetitions != null) {
      modifications.add(WorkoutModification(
        exerciseName: exerciseName,
        field: 'reps',
        originalValue: adapted.repetitions!,
        adaptedValue: adapted.repetitions! + repsContrib.inputValue,
        reason: repsContrib.explanation,
      ));
    }

    return adapted;
  }

  // ---------------------------------------------------------------------------
  //  EXPLANATION builder
  // ---------------------------------------------------------------------------

  AdaptationExplanation _buildExplanation({
    required String exerciseName,
    required StressState stressState,
    required List<FactorContribution> contributions,
    required double confidenceScore,
    required bool isDeload,
    required bool isIntensification,
    required bool weightReducedByStressOrPhase,
  }) {
    final tier = stressState.tier;
    final String summary;

    if (isDeload) {
      summary = '$exerciseName: semana de deload — volumen e intensidad reducidos para recuperación.';
    } else if (tier == StressTier.critical) {
      summary = '$exerciseName: estrés crítico — entrenamiento de mantenimiento mínimo.';
    } else if (tier == StressTier.high) {
      summary = '$exerciseName: estrés elevado — volumen reducido, técnica sobre carga.';
    } else if (isIntensification && !weightReducedByStressOrPhase) {
      summary = '$exerciseName: fase de intensificación — mantener o aumentar carga.';
    } else if (weightReducedByStressOrPhase) {
      summary = '$exerciseName: carga reducida por estrés acumulado.';
    } else {
      summary = '$exerciseName: condición óptima — seguir el plan.';
    }

    final String confidenceLabel;
    if (confidenceScore >= 0.75) {
      confidenceLabel = 'Alta confianza';
    } else if (confidenceScore >= 0.45) {
      confidenceLabel = 'Confianza moderada';
    } else {
      confidenceLabel = 'Datos insuficientes';
    }

    return AdaptationExplanation(
      contributions: List.unmodifiable(contributions),
      summary: summary,
      confidenceScore: confidenceScore,
      confidenceLabel: confidenceLabel,
    );
  }

  // ---------------------------------------------------------------------------
  //  CONFIDENCE SCORE
  // ---------------------------------------------------------------------------

  /// Computes a confidence score in [0, 1] for the adaptation decision.
  ///
  /// Factors:
  ///   • Data quality score from insight (0–100 → 0–1): 50% weight.
  ///   • Session count (≥ 6 = full confidence): 30% weight.
  ///   • Checkin completeness (all muscles rated + fatigue not at default): 20% weight.
  double _computeConfidenceScore(FitnessInsight? insight, PreWorkoutCheckin checkin) {
    // Data quality contribution
    final dataQuality = insight != null ? (insight.dataQualityScore / 100.0).clamp(0.0, 1.0) : 0.0;

    // Session count contribution: saturates at 6 sessions.
    final sessionCount = insight?.sessionCount ?? 0;
    final sessionConfidence = math.min(1.0, sessionCount / 6.0);

    // Checkin completeness: penalise if no muscles rated and fatigue is the
    // default value (5), which suggests the user skipped the check-in screen.
    final hasMusclePain = checkin.musclePain.isNotEmpty;
    final fatigueNotDefault = checkin.fatigue != 5;
    final checkinComplete = (hasMusclePain ? 0.5 : 0.0) + (fatigueNotDefault ? 0.5 : 0.0);

    return (dataQuality * 0.50 + sessionConfidence * 0.30 + checkinComplete * 0.20)
        .clamp(0.0, 1.0);
  }

  // ---------------------------------------------------------------------------
  //  Helpers
  // ---------------------------------------------------------------------------

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

  List<String> _muscleNames(Exercise? exercise) {
    if (exercise == null) {
      return [];
    }
    return [...exercise.muscles, ...exercise.musclesSecondary]
        .map((m) => m.name)
        .toList();
  }

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
