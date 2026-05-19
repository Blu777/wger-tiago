import 'package:collection/collection.dart';
import 'package:wger/features/body_weight/domain/models/weight_entry.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_item.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_plan.dart';
import 'package:wger/features/fitness_insights/domain/entities/adherence_metrics.dart';
import 'package:wger/features/fitness_insights/domain/entities/coach_state.dart';
import 'package:wger/features/fitness_insights/domain/entities/coach_summary.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/muscle_analysis.dart';
import 'package:wger/features/fitness_insights/domain/entities/subjective_feedback.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_goal.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_score_breakdown.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';

/// V2 iteration of the coaching use case.
///
/// Improvements over V1 (AnalyzeTraining):
/// 1. Accepts [TrainingGoal] and adjusts status & threshold logic.
/// 2. Uses best e1RM per session (ignores warmup/backoff) instead of averaging
///    all sets.
/// 3. Splits analysis by date ranges (two 2-week halves) instead of by count.
/// 4. Does NOT modify V1 — fully isolated.
class AnalyzeTrainingV2 {
  // ------------------------------------------------------------------
  // Threshold constants
  // ------------------------------------------------------------------
  static const num _e1rmProgressThreshold = 0.02; // 2%
  static const num _e1rmRegressionThreshold = 0.03; // 3%
  static const int _analysisWeeks = 4;
  static const num _fatigueHighThreshold = 6.0;
  static const num _adherenceMinThreshold = 60.0;

  static const int _minWeightEntries = 2;
  static const int _minSessionsForQuality = 3;
  static const int _minExercisesForQuality = 2;

  // Muscle volume thresholds (sets/week)
  static const num _muscleUnderThreshold = 8;
  static const num _muscleOptimalMax = 20;
  static const num _muscleOverThreshold = 25;

  // Warmup/backoff filter: sets below this % of session-best weight are excluded
  static const double _warmupWeightRatio = 0.65;

  FitnessInsight call({
    required List<WeightEntry> weightEntries,
    required List<TrainingSession> sessions,
    required List<SubjectiveFeedback> feedback,
    required TrainingGoal goal,
    CoachState? previousState,
  }) {
    final now = DateTime.now();
    final analysisStart = now.subtract(const Duration(days: _analysisWeeks * 7));

    // --- 1. Sort & filter by date ---
    final sortedWeight = weightEntries.sorted((a, b) => a.date.compareTo(b.date));
    final sortedSessions = sessions
        .where((s) => !s.date.isBefore(analysisStart))
        .sorted((a, b) => a.date.compareTo(b.date));
    final sortedFeedback = feedback
        .where((f) => !f.date.isBefore(analysisStart))
        .sorted((a, b) => a.date.compareTo(b.date));

    // --- 2. Weekly weight change ---
    final weeklyWeightChange = _computeWeeklyWeightChange(sortedWeight);

    // --- 3. Adherence metrics ---
    final adherence = _computeAdherenceMetrics(sortedSessions, analysisStart, now);

    // --- 4. Fatigue ---
    final fatigueLevel = _computeFatigue(sortedFeedback, sortedSessions);
    final fatigueTrend = _computeFatigueTrend(sortedFeedback, sortedSessions);

    // --- 5. Exercise insights (best-e1RM per session, date-range split) ---
    final exerciseInsights = _computeExerciseInsights(sortedSessions, analysisStart, now);
    final stalledExercises = exerciseInsights
        .where((e) => e.progressStatus == ExerciseProgressStatus.stalled)
        .map((e) => e.exerciseName)
        .toList();
    final droppedExercises = exerciseInsights
        .where((e) => e.progressStatus == ExerciseProgressStatus.regression)
        .map((e) => e.exerciseName)
        .toList();
    final progressingCount = exerciseInsights
        .where((e) => e.progressStatus == ExerciseProgressStatus.progressing)
        .length;
    final totalTracked = exerciseInsights.length;
    final isStrengthProgressing = totalTracked > 0 && progressingCount >= totalTracked / 2;

    // --- 6. Muscle analysis ---
    final muscleAnalysis = _computeMuscleAnalysis(sortedSessions);

    // --- 7. Data quality ---
    // Use raw exercise count from sessions, not insight count (which requires
    // ≥2 data points to produce an insight and would undercount for new users).
    final rawExerciseCount = sortedSessions
        .expand((s) => s.exercises)
        .map((e) => e.exerciseName)
        .toSet()
        .length;
    final dataQualityScore = _computeDataQualityScore(sortedSessions, rawExerciseCount);

    // --- 8. Training score ---
    final trainingScore = _computeTrainingScore(
      exerciseInsights: exerciseInsights,
      adherence: adherence,
      fatigueLevel: fatigueLevel,
      dataQualityScore: dataQualityScore,
    );


    // --- 9. Status (goal-aware) ---
    final status = _determineStatus(
      weeklyWeightChange: weeklyWeightChange,
      fatigueLevel: fatigueLevel,
      isStrengthProgressing: isStrengthProgressing,
      droppedExercises: droppedExercises,
      stalledExercises: stalledExercises,
      adherence: adherence,
      goal: goal,
      sessionCount: sortedSessions.length,
      exerciseInsightCount: totalTracked,
    );

    // --- 10. Recommendations ---
    final recommendations = _buildRecommendations(
      exerciseInsights: exerciseInsights,
      muscleAnalysis: muscleAnalysis,
      status: status,
      weeklyWeightChange: weeklyWeightChange,
      isStrengthProgressing: isStrengthProgressing,
      adherence: adherence,
      fatigueLevel: fatigueLevel,
      fatigueTrend: fatigueTrend,
      dataQualityScore: dataQualityScore,
      goal: goal,
    );

    // --- 11. Intensity analysis ---
    final intensityByExercise = _computeIntensityAnalysis(sortedSessions);

    // --- 12. Score breakdown ---
    final scoreBreakdown = _computeTrainingScoreBreakdown(
      exerciseInsights: exerciseInsights,
      adherence: adherence,
      fatigueLevel: fatigueLevel,
      dataQualityScore: dataQualityScore,
    );

    // --- 13. Training phase ---
    final trainingPhase = _detectTrainingPhase(
      fatigueLevel: fatigueLevel,
      fatigueTrend: fatigueTrend,
      exerciseInsights: exerciseInsights,
      muscleAnalysis: muscleAnalysis,
      status: status,
      previousPhase: previousState?.lastPhase,
    );

    // --- 14. Action plan ---
    final actionPlan = _computeActionPlan(
      exerciseInsights: exerciseInsights,
      muscleAnalysis: muscleAnalysis,
      intensityByExercise: intensityByExercise,
      status: status,
      fatigueLevel: fatigueLevel,
      phase: trainingPhase,
      previousState: previousState,
    );

    // --- 15. Coach summary ---
    final coachSummary = _computeCoachSummary(
      phase: trainingPhase,
      status: status,
      actionPlan: actionPlan,
      exerciseInsights: exerciseInsights,
    );

    // --- 16. Coach state for next cycle ---
    final currentWeek = now.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay ~/ 7;
    final newCoachState = CoachState(
      lastPhase: trainingPhase,
      lastActions: actionPlan.actions.take(2).toList(),
      lastDeloadWeek: trainingPhase == TrainingPhase.deload
          ? currentWeek
          : previousState?.lastDeloadWeek,
    );

    // Legacy volume map
    final exerciseVolumes = <String, num>{
      for (final e in exerciseInsights) e.exerciseName: e.totalVolume,
    };

    return FitnessInsight(
      status: status,
      weeklyWeightChange: weeklyWeightChange,
      isStrengthProgressing: isStrengthProgressing,
      fatigueLevel: fatigueLevel,
      stalledExercises: stalledExercises,
      droppedExercises: droppedExercises,
      adherenceMetrics: adherence,
      fatigueTrend: fatigueTrend,
      dataQualityScore: dataQualityScore,
      exerciseVolumes: exerciseVolumes,
      exerciseInsights: exerciseInsights,
      muscleAnalysis: muscleAnalysis,
      trainingScore: trainingScore,
      trainingScoreBreakdown: scoreBreakdown,
      actionPlan: actionPlan,
      trainingPhase: trainingPhase,
      coachSummary: coachSummary,
      coachState: newCoachState,
      recommendations: recommendations,
      sessionCount: sortedSessions.length,
      uniqueExerciseCount: rawExerciseCount,
    );
  }

  // ================================================================
  //  e1RM-based Exercise Insights (V2: best per session, date-range split)
  // ================================================================

  List<ExerciseInsight> _computeExerciseInsights(
    List<TrainingSession> sessions,
    DateTime analysisStart,
    DateTime now,
  ) {
    if (sessions.isEmpty) {
      return [];
    }

    // Date-range midpoint (instead of count-based split)
    final midpoint = analysisStart.add(
      Duration(days: now.difference(analysisStart).inDays ~/ 2),
    );

    // Group best e1RM per exercise per session (filter warmups)
    final byExercise = <String, List<_E1rmEntry>>{};
    final totalVolumeByExercise = <String, num>{};
    final sessionCountByExercise = <String, int>{};

    for (final session in sessions) {
      for (final perf in session.exercises) {
        final name = perf.exerciseName;
        sessionCountByExercise[name] = (sessionCountByExercise[name] ?? 0) + 1;

        if (perf.sets.isEmpty) {
          continue;
        }

        // Find max weight in this exercise's sets for this session
        final maxWeight = perf.sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
        final warmupCutoff = maxWeight * _warmupWeightRatio;

        // Filter out warmup/backoff sets
        final workingSets = perf.sets.where((s) => s.weight >= warmupCutoff).toList();
        if (workingSets.isEmpty) {
          continue;
        }

        // Best e1RM for this session (not average of all sets)
        final bestE1rm = workingSets
            .map((s) => _calculateE1rm(s.weight, s.repetitions))
            .reduce((a, b) => a > b ? a : b);

        byExercise.putIfAbsent(name, () => []).add(
          _E1rmEntry(date: session.date, e1rm: bestE1rm),
        );

        // Volume still uses all sets
        for (final set in perf.sets) {
          totalVolumeByExercise[name] =
              (totalVolumeByExercise[name] ?? 0) + (set.weight * set.repetitions);
        }
      }
    }

    final results = <ExerciseInsight>[];
    for (final entry in byExercise.entries) {
      final points = entry.value.sorted((a, b) => a.date.compareTo(b.date));
      if (points.length < 2) {
        continue;
      }

      // Split by date range (preferred); fall back to count-based split
      // when all data is in the same half (e.g. user started < 2 weeks ago).
      var recent = points.where((p) => !p.date.isBefore(midpoint)).toList();
      var previous = points.where((p) => p.date.isBefore(midpoint)).toList();

      if (recent.isEmpty || previous.isEmpty) {
        // Count-based fallback: first half vs second half
        final mid = points.length ~/ 2;
        if (mid == 0) {
          continue; // truly only 1 data point — nothing to compare
        }
        previous = points.sublist(0, mid);
        recent = points.sublist(mid);
      }

      final recentAvg = recent.map((p) => p.e1rm).average;
      final previousAvg = previous.map((p) => p.e1rm).average;
      final change = previousAvg > 0 ? (recentAvg - previousAvg) / previousAvg : 0;

      ExerciseProgressStatus status;
      String recommendation;
      if (change >= _e1rmProgressThreshold) {
        status = ExerciseProgressStatus.progressing;
        recommendation = 'Subiste ${(change * 100).toStringAsFixed(1)}% en ${entry.key}. '
            'Mantené o incrementá ${(recentAvg * 0.025).toStringAsFixed(1)}kg.';
      } else if (change <= -_e1rmRegressionThreshold) {
        status = ExerciseProgressStatus.regression;
        recommendation = 'Tu e1RM bajó ${(change.abs() * 100).toStringAsFixed(1)}% en ${entry.key}. '
            'Bajá peso 5-10% y recuperá técnica.';
      } else {
        status = ExerciseProgressStatus.stalled;
        recommendation = 'Sin mejora en ${entry.key}. '
            'Probá ${(previousAvg * 1.025).toStringAsFixed(1)}kg o más reps.';
      }

      results.add(ExerciseInsight(
        exerciseName: entry.key,
        currentE1rm: recentAvg,
        previousE1rm: previousAvg,
        e1rmChangePercent: change,
        totalVolume: totalVolumeByExercise[entry.key] ?? 0,
        sessionCount: sessionCountByExercise[entry.key] ?? 0,
        progressStatus: status,
        recommendation: recommendation,
      ));
    }

    return results;
  }

  num _calculateE1rm(num weight, num reps) {
    if (reps <= 1) {
      return weight.toDouble();
    }
    // Brzycki formula is accurate up to ~10 reps; beyond that it inflates
    // e1RM significantly (e.g. 20 reps → ×2.1x). Switch to Epley above 10.
    if (reps <= 10) {
      return weight * (36 / (37 - reps));
    }
    // Epley: weight × (1 + reps/30) — more conservative for high-rep sets
    return weight * (1 + reps / 30);
  }

  // ================================================================
  //  Muscle Analysis
  // ================================================================

  Map<String, MuscleAnalysis> _computeMuscleAnalysis(List<TrainingSession> sessions) {
    if (sessions.isEmpty) {
      return {};
    }

    const weeks = _analysisWeeks;
    final muscleSets = <String, List<num>>{};
    final muscleVolume = <String, num>{};
    final muscleSessions = <String, Set<DateTime>>{};

    for (final session in sessions) {
      for (final perf in session.exercises) {
        final setCount = perf.sets.length;
        final volume = perf.sets.map((s) => s.weight * s.repetitions).fold<num>(0, (a, b) => a + b);

        for (final muscle in perf.muscleNames) {
          muscleSets.putIfAbsent(muscle, () => []).add(setCount.toDouble());
          muscleVolume[muscle] = (muscleVolume[muscle] ?? 0) + volume;
          muscleSessions.putIfAbsent(muscle, () => <DateTime>{}).add(
            DateTime(session.date.year, session.date.month, session.date.day),
          );
        }
      }
    }

    final result = <String, MuscleAnalysis>{};
    for (final muscle in muscleSets.keys) {
      final totalSets = muscleSets[muscle]!.fold<num>(0, (a, b) => a + b);
      final weeklySets = totalSets / weeks;
      final freq = (muscleSessions[muscle]?.length ?? 0) / weeks;
      final vol = muscleVolume[muscle] ?? 0;

      MuscleTrainingStatus status;
      if (weeklySets < _muscleUnderThreshold) {
        status = MuscleTrainingStatus.undertraining;
      } else if (weeklySets > _muscleOverThreshold) {
        status = MuscleTrainingStatus.overtraining;
      } else {
        status = MuscleTrainingStatus.optimal;
      }

      result[muscle] = MuscleAnalysis(
        muscleName: muscle,
        weeklySets: weeklySets,
        weeklyFrequency: freq,
        totalVolume: vol,
        status: status,
      );
    }

    return result;
  }

  // ================================================================
  //  Training Score
  // ================================================================

  num _computeTrainingScore({
    required List<ExerciseInsight> exerciseInsights,
    required AdherenceMetrics adherence,
    required num? fatigueLevel,
    required num dataQualityScore,
  }) {
    return _computeTrainingScoreBreakdown(
      exerciseInsights: exerciseInsights,
      adherence: adherence,
      fatigueLevel: fatigueLevel,
      dataQualityScore: dataQualityScore,
    ).total;
  }

  // ================================================================
  //  Data Quality
  // ================================================================

  num _computeDataQualityScore(List<TrainingSession> sessions, int uniqueExercises) {
    var sessionScore = 0;
    if (sessions.length >= _minSessionsForQuality) {
      sessionScore = 100;
    } else if (sessions.length == 2) {
      sessionScore = 60;
    } else if (sessions.length == 1) {
      sessionScore = 30;
    }

    var exerciseScore = 0;
    if (uniqueExercises >= _minExercisesForQuality + 1) {
      exerciseScore = 100;
    } else if (uniqueExercises == _minExercisesForQuality) {
      exerciseScore = 70;
    } else if (uniqueExercises == 1) {
      exerciseScore = 40;
    }

    return (sessionScore + exerciseScore) / 2;
  }

  // ================================================================
  //  Fatigue
  // ================================================================

  num? _computeFatigue(List<SubjectiveFeedback> feedback, List<TrainingSession> sessions) {
    if (feedback.isNotEmpty) {
      return feedback.map((f) => f.fatigue).average;
    }
    if (sessions.isEmpty) {
      return null;
    }

    final recentSessions = sessions
        .where((s) => s.date.isAfter(DateTime.now().subtract(const Duration(days: 14))))
        .toList();
    if (recentSessions.isEmpty) {
      return null;
    }

    final avgImpression = recentSessions.map((s) => s.impression ?? 2).average;
    if (avgImpression <= 1.5) {
      return 7;
    }
    if (avgImpression <= 2.5) {
      return 4;
    }
    return 2;
  }

  num? _computeFatigueTrend(List<SubjectiveFeedback> feedback, List<TrainingSession> sessions) {
    if (feedback.length >= 2) {
      final mid = feedback.length ~/ 2;
      final firstAvg = feedback.sublist(0, mid).map((f) => f.fatigue).average;
      final secondAvg = feedback.sublist(mid).map((f) => f.fatigue).average;
      return secondAvg - firstAvg;
    }
    if (sessions.length < 2) {
      return null;
    }
    final mid = sessions.length ~/ 2;
    final firstAvg = sessions.sublist(0, mid).map((s) => s.impression ?? 2).average;
    final secondAvg = sessions.sublist(mid).map((s) => s.impression ?? 2).average;
    return firstAvg - secondAvg;
  }

  // ================================================================
  //  Status Determination (GOAL-AWARE — V2 improvement)
  // ================================================================

  FitnessStatus _determineStatus({
    required num? weeklyWeightChange,
    required num? fatigueLevel,
    required bool isStrengthProgressing,
    required List<String> droppedExercises,
    required List<String> stalledExercises,
    required AdherenceMetrics adherence,
    required TrainingGoal goal,
    required int sessionCount,
    required int exerciseInsightCount,
  }) {
    final hasRegression = droppedExercises.isNotEmpty;
    final hasStalled = stalledExercises.isNotEmpty;
    final fatHigh = fatigueLevel != null && fatigueLevel >= _fatigueHighThreshold;
    final progressNegative = weeklyWeightChange != null && weeklyWeightChange < 0;

    // Universal: overtraining detection
    if (fatHigh && (hasRegression || progressNegative)) {
      return FitnessStatus.overtraining;
    }

    // Early-data handling: user is training but not enough exercise insights
    // to determine trend. Give benefit of the doubt instead of "inconsistent".
    if (exerciseInsightCount == 0 && sessionCount > 0) {
      return FitnessStatus.goodProgress;
    }

    switch (goal) {
      case TrainingGoal.strength:
        // Strength: primarily e1RM-driven
        if (isStrengthProgressing && !fatHigh) {
          return FitnessStatus.goodProgress;
        }
        // Progressing but fatigued → still good progress, not inconsistent
        if (isStrengthProgressing && fatHigh) {
          return FitnessStatus.goodProgress;
        }
        if (hasStalled && !isStrengthProgressing) {
          return FitnessStatus.stalled;
        }

      case TrainingGoal.hypertrophy:
        // Hypertrophy: volume + adherence driven; some stalling is ok if volume is high
        final adherenceOk = adherence.consistencyScore >= _adherenceMinThreshold;
        if (adherenceOk && !fatHigh && !hasRegression) {
          return FitnessStatus.goodProgress;
        }
        if (hasStalled && !adherenceOk) {
          return FitnessStatus.stalled;
        }

      case TrainingGoal.fatLoss:
        // Fat loss: weight trending down + preserving strength = success
        final losingWeight = weeklyWeightChange != null && weeklyWeightChange < -0.1;
        if (losingWeight && !hasRegression) {
          return FitnessStatus.goodProgress;
        }
        if (!losingWeight && adherence.consistencyScore < _adherenceMinThreshold) {
          return FitnessStatus.inconsistent;
        }
        if (hasRegression) {
          return FitnessStatus.stalled;
        }

      case TrainingGoal.maintenance:
        // Maintenance: no regression + consistent attendance = success
        final adherenceOk = adherence.consistencyScore >= _adherenceMinThreshold;
        if (!hasRegression && adherenceOk) {
          return FitnessStatus.goodProgress;
        }
        if (!adherenceOk) {
          return FitnessStatus.inconsistent;
        }
    }

    return FitnessStatus.inconsistent;
  }

  // ================================================================
  //  Recommendations (goal-aware)
  // ================================================================

  List<String> _buildRecommendations({
    required List<ExerciseInsight> exerciseInsights,
    required Map<String, MuscleAnalysis> muscleAnalysis,
    required FitnessStatus status,
    required num? weeklyWeightChange,
    required bool isStrengthProgressing,
    required AdherenceMetrics adherence,
    required num? fatigueLevel,
    required num? fatigueTrend,
    required num dataQualityScore,
    required TrainingGoal goal,
  }) {
    final recs = <String>[];

    if (dataQualityScore < 60) {
      recs.add('Registrá $_minSessionsForQuality sesiones y $_minExercisesForQuality ejercicios para coaching preciso.');
      return recs;
    }

    // Goal-specific top-level recommendation
    switch (goal) {
      case TrainingGoal.strength:
        if (!isStrengthProgressing) {
          recs.add('Objetivo fuerza: progresión estancada. Priorizá sobrecarga progresiva en compuestos.');
        }
      case TrainingGoal.hypertrophy:
        final underMuscles = muscleAnalysis.values
            .where((m) => m.status == MuscleTrainingStatus.undertraining)
            .map((m) => m.muscleName)
            .toList();
        if (underMuscles.isNotEmpty) {
          recs.add('Objetivo hipertrofia: ${underMuscles.join(", ")} necesitan más volumen.');
        }
      case TrainingGoal.fatLoss:
        if (weeklyWeightChange != null && weeklyWeightChange > 0) {
          recs.add('Objetivo pérdida grasa: peso subiendo (+${weeklyWeightChange.toStringAsFixed(2)}kg/sem). Revisá ingesta calórica.');
        }
      case TrainingGoal.maintenance:
        if (adherence.consistencyScore < 70) {
          recs.add('Objetivo mantenimiento: adherencia ${adherence.consistencyScore.toStringAsFixed(0)}%. Apuntá a 3+ sesiones/sem.');
        }
    }

    // Per-exercise recs
    for (final insight in exerciseInsights) {
      recs.add(insight.recommendation);
    }

    // Muscle-specific recs
    for (final analysis in muscleAnalysis.values) {
      if (analysis.status == MuscleTrainingStatus.undertraining) {
        recs.add('${analysis.muscleName}: ${analysis.weeklySets.toStringAsFixed(0)} sets/sem → '
            'agregá ${(_muscleUnderThreshold + 2 - analysis.weeklySets).toStringAsFixed(0)} sets.');
      } else if (analysis.status == MuscleTrainingStatus.overtraining) {
        recs.add('${analysis.muscleName}: ${analysis.weeklySets.toStringAsFixed(0)} sets/sem → '
            'reducí ${(analysis.weeklySets - _muscleOptimalMax).toStringAsFixed(0)} sets.');
      }
    }

    // Fatigue recs
    final fatHigh = fatigueLevel != null && fatigueLevel >= _fatigueHighThreshold;
    if (fatHigh && isStrengthProgressing) {
      recs.add('Fatiga alta (${fatigueLevel.toStringAsFixed(1)}/10) con progreso → planificá descarga en 7-10 días.');
    } else if (fatHigh && !isStrengthProgressing) {
      recs.add('Fatiga alta sin progreso → reducí volumen 30% esta semana.');
    }

    if (fatigueTrend != null && fatigueTrend >= 1 && !fatHigh) {
      recs.add('Fatiga en ascenso (+${fatigueTrend.toStringAsFixed(1)}) → monitoreá en 3-5 días.');
    }

    return recs;
  }

  // ================================================================
  //  Intensity Analysis
  // ================================================================

  Map<String, num> _computeIntensityAnalysis(List<TrainingSession> sessions) {
    final result = <String, num>{};
    for (final session in sessions) {
      for (final perf in session.exercises) {
        if (perf.sets.isEmpty) {
          continue;
        }
        final maxWeight = perf.sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
        final maxWeightSet = perf.sets.firstWhere((s) => s.weight == maxWeight);
        final estimated1rm = _calculateE1rm(maxWeight, maxWeightSet.repetitions);
        var totalPct = 0.0;
        for (final set in perf.sets) {
          final setE1rm = _calculateE1rm(set.weight, set.repetitions);
          totalPct += (setE1rm / estimated1rm) * 100;
        }
        result[perf.exerciseName] = totalPct / perf.sets.length;
      }
    }
    return result;
  }

  // ================================================================
  //  Training Score Breakdown
  // ================================================================

  TrainingScoreBreakdown _computeTrainingScoreBreakdown({
    required List<ExerciseInsight> exerciseInsights,
    required AdherenceMetrics adherence,
    required num? fatigueLevel,
    required num dataQualityScore,
  }) {
    if (exerciseInsights.isEmpty) {
      final earlyAdherence = (adherence.consistencyScore / 100) * 40;
      final earlyQuality = (dataQualityScore / 100) * 30;
      final earlyTotal = (30 + earlyAdherence + earlyQuality).clamp(0, 100);
      return TrainingScoreBreakdown(
        progressScore: 30, // base encouragement
        adherenceScore: earlyAdherence,
        fatigueScore: 0,
        dataQualityScore: earlyQuality,
        total: earlyTotal,
      );
    }

    final progressing = exerciseInsights
        .where((e) => e.progressStatus == ExerciseProgressStatus.progressing)
        .length;
    final progressScore = (progressing / exerciseInsights.length) * 40;
    final adherenceScore = (adherence.consistencyScore / 100) * 25;

    var fatigueScore = 20.0;
    if (fatigueLevel != null) {
      fatigueScore = fatigueLevel >= _fatigueHighThreshold
          ? 5.0
          : 20.0 - (fatigueLevel * 1.5);
      if (fatigueScore < 0) {
        fatigueScore = 0;
      }
    }

    final qualityScore = (dataQualityScore / 100) * 15;
    final total = progressScore + adherenceScore + fatigueScore + qualityScore;

    return TrainingScoreBreakdown(
      progressScore: progressScore,
      adherenceScore: adherenceScore,
      fatigueScore: fatigueScore,
      dataQualityScore: qualityScore,
      total: total,
    );
  }

  // ================================================================
  //  Training Phase Detection
  // ================================================================

  TrainingPhase _detectTrainingPhase({
    required num? fatigueLevel,
    required num? fatigueTrend,
    required List<ExerciseInsight> exerciseInsights,
    required Map<String, MuscleAnalysis> muscleAnalysis,
    required FitnessStatus status,
    required TrainingPhase? previousPhase,
  }) {
    final fatHigh = fatigueLevel != null && fatigueLevel >= _fatigueHighThreshold;
    final fatRising = fatigueTrend != null && fatigueTrend > 0.5;
    final hasRegression = exerciseInsights.any(
      (e) => e.progressStatus == ExerciseProgressStatus.regression,
    );
    final totalWeeklySets = muscleAnalysis.values
        .map((m) => m.weeklySets)
        .fold<num>(0, (a, b) => a + b);
    final highVolume = muscleAnalysis.isNotEmpty &&
        totalWeeklySets > _muscleOptimalMax * muscleAnalysis.length;
    final lowVolume = muscleAnalysis.isNotEmpty &&
        totalWeeklySets < _muscleUnderThreshold * muscleAnalysis.length;

    if (fatHigh && hasRegression) {
      return TrainingPhase.deload;
    }

    if (!fatHigh && lowVolume &&
        (previousPhase == TrainingPhase.deload || previousPhase == TrainingPhase.recovery)) {
      return TrainingPhase.recovery;
    }

    final isProgressing = exerciseInsights
        .where((e) => e.progressStatus == ExerciseProgressStatus.progressing)
        .length >= (exerciseInsights.length / 2).ceil();
    if (isProgressing && !fatHigh) {
      return TrainingPhase.intensification;
    }

    if (fatRising && highVolume) {
      return TrainingPhase.accumulation;
    }

    if (previousPhase != null) {
      return previousPhase;
    }
    return TrainingPhase.accumulation;
  }

  // ================================================================
  //  Action Plan
  // ================================================================

  ActionPlan _computeActionPlan({
    required List<ExerciseInsight> exerciseInsights,
    required Map<String, MuscleAnalysis> muscleAnalysis,
    required Map<String, num> intensityByExercise,
    required FitnessStatus status,
    required num? fatigueLevel,
    required TrainingPhase phase,
    required CoachState? previousState,
  }) {
    final actions = <ActionItem>[];
    final targetsHandled = <String>{};

    bool wasRecentlyApplied(ActionItem candidate) {
      for (final past in previousState?.lastActions ?? <ActionItem>[]) {
        final sameTarget = past.target == candidate.target;
        final sameType = past.type == candidate.type;
        final similarValue = candidate.value != 0 &&
            (past.value - candidate.value).abs() < (candidate.value * 0.2);
        if (sameTarget && sameType && similarValue) {
          return true;
        }
      }
      return false;
    }

    // Phase-specific overrides
    if (phase == TrainingPhase.deload) {
      const deloadAction = ActionItem(
        type: ActionType.deload,
        target: 'Global',
        value: 40,
        priority: 1,
        reason: 'Deload: reducir volumen 40%.',
        detailReason: 'Se detectó fatiga acumulada elevada. '
            'Una semana de deload (reducir volumen 40%) permite que músculos y sistema nervioso se recuperen, '
            'preparando el cuerpo para una nueva fase de progresión.',
      );
      if (!wasRecentlyApplied(deloadAction)) {
        actions.add(deloadAction);
      }
      return ActionPlan(
        actions: actions.take(3).toList(),
        summary: 'Semana de deload: recuperación antes de nueva progresión.',
      );
    }

    if (phase == TrainingPhase.recovery) {
      const recoveryAction = ActionItem(
        type: ActionType.addSets,
        target: 'Global',
        value: 2,
        priority: 2,
        reason: 'Recuperación: agregar 2 sets.',
        detailReason: 'Venís de una fase de deload o baja fatiga. '
            'Agregar sets progresivamente ayuda a retomar volumen sin arriesgarte a sobreentrenamiento.',
      );
      if (!wasRecentlyApplied(recoveryAction)) {
        actions.add(recoveryAction);
      }
      return ActionPlan(
        actions: actions.take(3).toList(),
        summary: 'Recuperación activa: volumen progresivo.',
      );
    }

    // Accumulation
    if (phase == TrainingPhase.accumulation) {
      final underMuscles = muscleAnalysis.values
          .where((m) => m.status == MuscleTrainingStatus.undertraining)
          .sorted((a, b) => a.weeklySets.compareTo(b.weeklySets));
      for (final muscle in underMuscles.take(1)) {
        final setsToAdd = (_muscleUnderThreshold + 2 - muscle.weeklySets).clamp(2, 4).toInt();
        final candidate = ActionItem(
          type: ActionType.addSets,
          target: muscle.muscleName,
          value: setsToAdd,
          priority: 2,
          reason: '${muscle.muscleName}: agregar $setsToAdd sets.',
          detailReason: 'Fase de acumulación. '
              '${muscle.muscleName} tiene ${muscle.weeklySets.toStringAsFixed(0)} sets/semana, '
              'por debajo del umbral de $_muscleUnderThreshold sets. '
              'Agregar $setsToAdd sets para estimular el crecimiento.',
        );
        if (!wasRecentlyApplied(candidate)) {
          actions.add(candidate);
          targetsHandled.add(muscle.muscleName);
        }
      }
    }

    // Intensification
    if (phase == TrainingPhase.intensification) {
      final progressing = exerciseInsights
          .where((e) => e.progressStatus == ExerciseProgressStatus.progressing)
          .sorted((a, b) => b.e1rmChangePercent.compareTo(a.e1rmChangePercent));
      for (final insight in progressing.take(1)) {
        final rawIncrease = (insight.currentE1rm * 0.025).ceil();
        final rounded = _roundTo5(rawIncrease);
        final ActionItem candidate;
        if (rounded >= 5) {
          candidate = ActionItem(
            type: ActionType.increaseWeight,
            target: insight.exerciseName,
            value: rounded,
            priority: 1,
            reason: '${insight.exerciseName}: subir ${rounded}kg.',
            detailReason: 'Fase de intensificación. '
                'Tu e1RM pasó de ${insight.previousE1rm.toStringAsFixed(1)}kg a ${insight.currentE1rm.toStringAsFixed(1)}kg '
                '(+${(insight.e1rmChangePercent * 100).toStringAsFixed(1)}%) en ${insight.sessionCount} sesiones. '
                'Estás listo para subir peso.',
          );
        } else {
          candidate = ActionItem(
            type: ActionType.addReps,
            target: insight.exerciseName,
            value: 2,
            priority: 1,
            reason: '${insight.exerciseName}: agregar 2 reps por serie.',
            detailReason: 'Fase de intensificación. '
                'Tu e1RM pasó de ${insight.previousE1rm.toStringAsFixed(1)}kg a ${insight.currentE1rm.toStringAsFixed(1)}kg '
                '(+${(insight.e1rmChangePercent * 100).toStringAsFixed(1)}%). '
                'El incremento de peso ($rawIncrease kg) es menor a 5kg, así que conviene agregar reps '
                'hasta acumular suficiente fuerza para subir de disco.',
          );
        }
        if (!wasRecentlyApplied(candidate)) {
          actions.add(candidate);
          targetsHandled.add(insight.exerciseName);
        }
      }
    }

    // Fallback: regressions
    final regressions = exerciseInsights
        .where((e) => e.progressStatus == ExerciseProgressStatus.regression)
        .sorted((a, b) => b.e1rmChangePercent.compareTo(a.e1rmChangePercent));
    for (final insight in regressions.take(1)) {
      final candidate = ActionItem(
        type: ActionType.reduceVolume,
        target: insight.exerciseName,
        value: 25,
        priority: 1,
        reason: '${insight.exerciseName}: reducir volumen 25%.',
        detailReason: 'Tu e1RM bajó de ${insight.previousE1rm.toStringAsFixed(1)}kg a ${insight.currentE1rm.toStringAsFixed(1)}kg '
            '(${(insight.e1rmChangePercent * 100).toStringAsFixed(1)}%). '
            'Reducir volumen permite recuperar fuerza sin acumular fatiga.',
      );
      if (!wasRecentlyApplied(candidate) && !targetsHandled.contains(insight.exerciseName)) {
        actions.add(candidate);
        targetsHandled.add(insight.exerciseName);
      }
    }

    // Fallback: stalled
    final stalled = exerciseInsights
        .where((e) => e.progressStatus == ExerciseProgressStatus.stalled)
        .sorted((a, b) => b.totalVolume.compareTo(a.totalVolume));
    for (final insight in stalled.take(1)) {
      if (targetsHandled.contains(insight.exerciseName)) {
        continue;
      }
      final intensity = intensityByExercise[insight.exerciseName] ?? 0;
      final ActionItem candidate;
      if (intensity < 80) {
        final rawIncrease = (insight.currentE1rm * 0.025).ceil();
        final rounded = _roundTo5(rawIncrease);
        if (rounded >= 5) {
          candidate = ActionItem(
            type: ActionType.increaseWeight,
            target: insight.exerciseName,
            value: rounded,
            priority: 2,
            reason: '${insight.exerciseName}: subir ${rounded}kg.',
            detailReason: 'Ejercicio estancado con intensidad baja (${intensity.toStringAsFixed(0)}%). '
                'e1RM actual: ${insight.currentE1rm.toStringAsFixed(1)}kg, sin cambio significativo. '
                'Subir peso puede romper el estancamiento.',
          );
        } else {
          candidate = ActionItem(
            type: ActionType.addReps,
            target: insight.exerciseName,
            value: 2,
            priority: 2,
            reason: '${insight.exerciseName}: agregar 2 reps por serie.',
            detailReason: 'Ejercicio estancado con intensidad baja (${intensity.toStringAsFixed(0)}%). '
                'e1RM actual: ${insight.currentE1rm.toStringAsFixed(1)}kg. '
                'El incremento de peso ($rawIncrease kg) es menor a 5kg, así que conviene agregar reps '
                'hasta acumular fuerza para el próximo salto de disco.',
          );
        }
      } else {
        candidate = ActionItem(
          type: ActionType.reduceVolume,
          target: insight.exerciseName,
          value: 15,
          priority: 2,
          reason: '${insight.exerciseName}: reducir volumen 15%.',
          detailReason: 'Ejercicio estancado con intensidad alta (${intensity.toStringAsFixed(0)}%). '
              'e1RM actual: ${insight.currentE1rm.toStringAsFixed(1)}kg, sin cambio significativo. '
              'Reducir volumen puede ayudar a recuperar y progresar.',
        );
      }
      if (!wasRecentlyApplied(candidate)) {
        actions.add(candidate);
        targetsHandled.add(insight.exerciseName);
      }
    }

    // Fallback: undertrained muscles
    final underMuscles = muscleAnalysis.values
        .where((m) => m.status == MuscleTrainingStatus.undertraining)
        .sorted((a, b) => a.weeklySets.compareTo(b.weeklySets));
    for (final muscle in underMuscles.take(1)) {
      if (targetsHandled.contains(muscle.muscleName)) {
        continue;
      }
      final setsToAdd = (_muscleUnderThreshold + 2 - muscle.weeklySets).clamp(2, 4).toInt();
      final candidate = ActionItem(
        type: ActionType.addSets,
        target: muscle.muscleName,
        value: setsToAdd,
        priority: 2,
        reason: '${muscle.muscleName}: agregar $setsToAdd sets.',
        detailReason: '${muscle.muscleName} tiene ${muscle.weeklySets.toStringAsFixed(0)} sets/semana, '
            'por debajo del umbral mínimo de $_muscleUnderThreshold sets. '
            'Agregar volumen para mejorar el estímulo de crecimiento.',
      );
      if (!wasRecentlyApplied(candidate)) {
        actions.add(candidate);
        targetsHandled.add(muscle.muscleName);
      }
    }

    actions.sort((a, b) => a.priority.compareTo(b.priority));
    final selected = actions.take(3).toList();

    String summary;
    if (selected.isEmpty) {
      summary = 'Mantené tu plan actual: progreso estable.';
    } else {
      summary = 'Foco semanal (${_phaseLabel(phase)}): ${selected.first.reason}';
    }

    return ActionPlan(actions: selected, summary: summary);
  }

  String _phaseLabel(TrainingPhase phase) {
    switch (phase) {
      case TrainingPhase.accumulation:
        return 'acumulación';
      case TrainingPhase.intensification:
        return 'intensificación';
      case TrainingPhase.deload:
        return 'deload';
      case TrainingPhase.recovery:
        return 'recuperación';
    }
  }

  // ================================================================
  //  Coach Summary
  // ================================================================

  CoachSummary _computeCoachSummary({
    required TrainingPhase phase,
    required FitnessStatus status,
    required ActionPlan actionPlan,
    required List<ExerciseInsight> exerciseInsights,
  }) {
    String situation;
    String directive;
    String? note;

    final progressingCount = exerciseInsights
        .where((e) => e.progressStatus == ExerciseProgressStatus.progressing)
        .length;
    final stalledCount = exerciseInsights
        .where((e) => e.progressStatus == ExerciseProgressStatus.stalled)
        .length;

    switch (phase) {
      case TrainingPhase.accumulation:
        situation = 'Fase de acumulación: volumen creciente con fatiga manejable.';
        directive = 'Mantené el volumen alto; si el progreso se estanca, pasá a intensificación.';
        if (progressingCount > 0) {
          note = '$progressingCount ejercicio(s) progresando — buena señal.';
        }
      case TrainingPhase.intensification:
        situation = 'Fase de intensificación: cargas subiendo con progreso sostenido.';
        directive = 'Priorizá subir peso en ejercicios que progresan; no agregues sets.';
        if (stalledCount > 0) {
          note = '$stalledCount ejercicio(s) estancado(s) — considerá técnica o descanso.';
        }
      case TrainingPhase.deload:
        situation = 'Fase de deload: fatiga alta con señales de regresión.';
        directive = 'Reducí volumen 40% esta semana; mantené técnica y recuperación.';
        note = 'Evitá proximidad al fallo; enfocate en sueño y nutrición.';
      case TrainingPhase.recovery:
        situation = 'Fase de recuperación: fatiga baja, volumen en reconstrucción.';
        directive = 'Agregá sets progresivamente hasta volver a la carga base.';
        note = 'No apures el retorno; la consistencia supera la intensidad.';
    }

    if (actionPlan.actions.isEmpty) {
      directive = 'Todo en rango. Seguí con el plan actual sin cambios mayores.';
    }

    return CoachSummary(situation: situation, directive: directive, note: note);
  }

  // ================================================================
  //  Weight & Adherence
  // ================================================================

  num? _computeWeeklyWeightChange(List<WeightEntry> entries) {
    if (entries.length < _minWeightEntries) {
      return null;
    }

    final cutoff = DateTime.now().subtract(const Duration(days: _analysisWeeks * 7));
    final relevant = entries.where((e) => !e.date.isBefore(cutoff)).toList();
    if (relevant.length < _minWeightEntries) {
      return null;
    }

    final first = relevant.first;
    final last = relevant.last;
    final daysDiff = last.date.difference(first.date).inDays;
    if (daysDiff < 7) {
      return null;
    }

    return (last.weight - first.weight) / (daysDiff / 7);
  }

  AdherenceMetrics _computeAdherenceMetrics(
    List<TrainingSession> sessions,
    DateTime start,
    DateTime end,
  ) {
    if (sessions.isEmpty) {
      return const AdherenceMetrics(weeklyFrequency: 0, maxGapDays: 0, consistencyScore: 0);
    }

    final daysTotal = end.difference(start).inDays;
    final weeksTotal = daysTotal / 7;
    final frequency = weeksTotal > 0 ? sessions.length / weeksTotal : 0;

    int maxGap = 0;
    int currentGap = 0;
    var checkDate = start;
    final sessionDates = sessions
        .map((s) => DateTime(s.date.year, s.date.month, s.date.day))
        .toSet();

    while (checkDate.isBefore(end) || checkDate.isAtSameMomentAs(end)) {
      final day = DateTime(checkDate.year, checkDate.month, checkDate.day);
      if (sessionDates.contains(day)) {
        maxGap = currentGap > maxGap ? currentGap : maxGap;
        currentGap = 0;
      } else {
        currentGap++;
      }
      checkDate = checkDate.add(const Duration(days: 1));
    }
    maxGap = currentGap > maxGap ? currentGap : maxGap;

    final weeklyCounts = <int, int>{};
    for (final s in sessions) {
      final week = s.date.difference(start).inDays ~/ 7;
      weeklyCounts[week] = (weeklyCounts[week] ?? 0) + 1;
    }
    // Use the mean sessions/week as the expected baseline, not the modal max.
    // Using max caused one exceptional week to make every other week look inconsistent.
    final meanWeekly = weeksTotal > 0 ? sessions.length / weeksTotal : 0;
    final expectedSessions = weeksTotal * meanWeekly;
    final consistency = expectedSessions > 0 ? (sessions.length / expectedSessions) * 100 : 0;

    return AdherenceMetrics(
      weeklyFrequency: frequency,
      maxGapDays: maxGap,
      consistencyScore: consistency > 100 ? 100 : consistency,
    );
  }
}

// ------------------------------------------------------------------
// Internal helpers
// ------------------------------------------------------------------

/// Rounds a value up to the nearest multiple of 5.
int _roundTo5(num value) => (value / 5).ceil() * 5;

class _E1rmEntry {
  final DateTime date;
  final num e1rm;
  _E1rmEntry({required this.date, required this.e1rm});
}
