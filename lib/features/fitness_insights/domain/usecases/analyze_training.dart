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
import 'package:wger/features/fitness_insights/domain/entities/training_score_breakdown.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';

/// Pure, deterministic coaching use case that evaluates training effectiveness
/// and produces a [FitnessInsight] with exercise-level and muscle-group detail.
class AnalyzeTraining {
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

  FitnessInsight call({
    required List<WeightEntry> weightEntries,
    required List<TrainingSession> sessions,
    required List<SubjectiveFeedback> feedback,
    CoachState? previousState,
  }) {
    final now = DateTime.now();
    final analysisStart = now.subtract(const Duration(days: _analysisWeeks * 7));

    // --- 1. Sort & filter by date ---
    final sortedWeight = _sortByDate(weightEntries);
    final sortedSessions = _sortByDate(sessions).where((s) => s.date.isAfter(analysisStart) || s.date.isAtSameMomentAs(analysisStart)).toList();
    final sortedFeedback = _sortByDate(feedback).where((f) => f.date.isAfter(analysisStart) || f.date.isAtSameMomentAs(analysisStart)).toList();

    // --- 2. Weekly weight change ---
    final weeklyWeightChange = _computeWeeklyWeightChange(sortedWeight);

    // --- 3. Adherence metrics ---
    final adherence = _computeAdherenceMetrics(sortedSessions, analysisStart, now);

    // --- 4. Fatigue ---
    final fatigueLevel = _computeFatigue(sortedFeedback, sortedSessions);
    final fatigueTrend = _computeFatigueTrend(sortedFeedback, sortedSessions);

    // --- 5. Exercise insights (e1RM-based) ---
    final exerciseInsights = _computeExerciseInsights(sortedSessions);
    final stalledExercises = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.stalled).map((e) => e.exerciseName).toList();
    final droppedExercises = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.regression).map((e) => e.exerciseName).toList();
    final progressingCount = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.progressing).length;
    final totalTracked = exerciseInsights.length;
    final isStrengthProgressing = totalTracked > 0 && progressingCount >= totalTracked / 2;

    // --- 6. Muscle analysis ---
    final muscleAnalysis = _computeMuscleAnalysis(sortedSessions);

    // --- 7. Data quality ---
    final dataQualityScore = _computeDataQualityScore(sortedSessions, totalTracked);

    // --- 8. Training score ---
    final trainingScore = _computeTrainingScore(
      exerciseInsights: exerciseInsights,
      adherence: adherence,
      fatigueLevel: fatigueLevel,
      dataQualityScore: dataQualityScore,
    );

    // --- 9. Status (strict priority) ---
    final status = _determineStatus(
      weeklyWeightChange: weeklyWeightChange,
      fatigueLevel: fatigueLevel,
      isStrengthProgressing: isStrengthProgressing,
      droppedExercises: droppedExercises,
      stalledExercises: stalledExercises,
      adherence: adherence,
    );

    // --- 10. Specific recommendations ---
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
    );

    // --- 11. Intensity analysis (%1RM per set) ---
    final intensityByExercise = _computeIntensityAnalysis(sortedSessions);

    // --- 12. Training score breakdown ---
    final scoreBreakdown = _computeTrainingScoreBreakdown(
      exerciseInsights: exerciseInsights,
      adherence: adherence,
      fatigueLevel: fatigueLevel,
      dataQualityScore: dataQualityScore,
    );

    // --- 13. Detect training phase ---
    final trainingPhase = _detectTrainingPhase(
      fatigueLevel: fatigueLevel,
      fatigueTrend: fatigueTrend,
      exerciseInsights: exerciseInsights,
      muscleAnalysis: muscleAnalysis,
      status: status,
      previousPhase: previousState?.lastPhase,
    );

    // --- 14. Weekly action plan (max 3 high-impact actions, phase-aware, loop-safe) ---
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

    // --- 16. Persist updated state for next cycle ---
    final currentWeek = now.millisecondsSinceEpoch ~/ Duration.millisecondsPerDay ~/ 7;
    final newCoachState = CoachState(
      lastPhase: trainingPhase,
      lastActions: actionPlan.actions.take(2).toList(),
      lastDeloadWeek: trainingPhase == TrainingPhase.deload ? currentWeek : previousState?.lastDeloadWeek,
    );

    // --- 14. Legacy volume map for backwards compat ---
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
    );
  }

  List<T> _sortByDate<T>(List<T> items, {DateTime Function(T)? dateExtractor}) {
    if (items.isEmpty) {
      return [];
    }
    if (T == WeightEntry) {
      return (items as List<WeightEntry>).sorted((a, b) => a.date.compareTo(b.date)) as List<T>;
    } else if (T == TrainingSession) {
      return (items as List<TrainingSession>).sorted((a, b) => a.date.compareTo(b.date)) as List<T>;
    } else if (T == SubjectiveFeedback) {
      return (items as List<SubjectiveFeedback>).sorted((a, b) => a.date.compareTo(b.date)) as List<T>;
    }
    return items;
  }

  // ================================================================
  //  e1RM-based Exercise Insights
  // ================================================================

  List<ExerciseInsight> _computeExerciseInsights(List<TrainingSession> sessions) {
    if (sessions.isEmpty) {
      return [];
    }

    // Group all sets by exercise
    final byExercise = <String, List<_E1rmEntry>>{};
    final totalVolumeByExercise = <String, num>{};
    final sessionCountByExercise = <String, int>{};

    for (final session in sessions) {
      for (final perf in session.exercises) {
        final name = perf.exerciseName;
        sessionCountByExercise[name] = (sessionCountByExercise[name] ?? 0) + 1;

        for (final set in perf.sets) {
          final e1rm = _calculateE1rm(set.weight, set.repetitions);
          byExercise.putIfAbsent(name, () => []).add(
            _E1rmEntry(date: session.date, e1rm: e1rm),
          );
          totalVolumeByExercise[name] = (totalVolumeByExercise[name] ?? 0) + (set.weight * set.repetitions);
        }
      }
    }

    final results = <ExerciseInsight>[];
    for (final entry in byExercise.entries) {
      final points = entry.value.sorted((a, b) => a.date.compareTo(b.date));
      if (points.length < 2) {
        continue;
      }

      final mid = points.length ~/ 2;
      final recent = points.sublist(mid);
      final previous = points.sublist(0, mid);

      final recentAvg = recent.map((p) => p.e1rm).average;
      final previousAvg = previous.map((p) => p.e1rm).average;
      final change = previousAvg > 0 ? (recentAvg - previousAvg) / previousAvg : 0;

      ExerciseProgressStatus status;
      String recommendation;
      if (change >= _e1rmProgressThreshold) {
        status = ExerciseProgressStatus.progressing;
        recommendation = 'Subí ${(change * 100).toStringAsFixed(1)}% en ${entry.key}. '
            'Mantén o incrementa ${(recentAvg * 0.025).toStringAsFixed(1)}kg.';
      } else if (change <= -_e1rmRegressionThreshold) {
        status = ExerciseProgressStatus.regression;
        recommendation = 'Tu e1RM bajó ${(change.abs() * 100).toStringAsFixed(1)}% en ${entry.key}. '
            'Baja peso un 5-10% y recupera técnica.';
      } else {
        status = ExerciseProgressStatus.stalled;
        recommendation = 'Sin mejora en ${entry.key}. '
            'Prueba ${(previousAvg * 1.025).toStringAsFixed(1)}kg o más reps.';
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
    final muscleSets = <String, List<num>>{}; // muscle -> sets per session day
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
      final totalSets = muscleSets[muscle]!.length; // total sets across all sessions
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
  //  Training Score (0-100)
  // ================================================================

  num _computeTrainingScore({
    required List<ExerciseInsight> exerciseInsights,
    required AdherenceMetrics adherence,
    required num? fatigueLevel,
    required num dataQualityScore,
  }) {
    if (exerciseInsights.isEmpty) {
      return dataQualityScore;
    }

    // Progress score: % of exercises progressing (0-40)
    final progressing = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.progressing).length;
    final progressScore = (progressing / exerciseInsights.length) * 40;

    // Adherence score (0-25)
    final adherenceScore = (adherence.consistencyScore / 100) * 25;

    // Fatigue score (0-20): lower fatigue = higher score
    var fatigueScore = 20.0;
    if (fatigueLevel != null) {
      fatigueScore = fatigueLevel >= _fatigueHighThreshold ? 5.0 : 20.0 - (fatigueLevel * 1.5);
      if (fatigueScore < 0) {
        fatigueScore = 0;
      }
    }

    // Data quality (0-15)
    final qualityScore = (dataQualityScore / 100) * 15;

    return progressScore + adherenceScore + fatigueScore + qualityScore;
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

  num? _computeFatigue(
    List<SubjectiveFeedback> feedback,
    List<TrainingSession> sessions,
  ) {
    if (feedback.isNotEmpty) {
      return feedback.map((f) => f.fatigue).average;
    }

    if (sessions.isEmpty) {
      return null;
    }
    final recentSessions = sessions.where(
      (s) => s.date.isAfter(DateTime.now().subtract(const Duration(days: 14))),
    ).toList();
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

  num? _computeFatigueTrend(
    List<SubjectiveFeedback> feedback,
    List<TrainingSession> sessions,
  ) {
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
  //  Specific Recommendations
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
  }) {
    final recs = <String>[];

    if (dataQualityScore < 60) {
      recs.add('Registra $_minSessionsForQuality sesiones y $_minExercisesForQuality ejercicios para coaching preciso.');
      return recs;
    }

    // Per-exercise specific recs
    for (final insight in exerciseInsights) {
      recs.add(insight.recommendation);
    }

    // Muscle-specific recs
    for (final analysis in muscleAnalysis.values) {
      if (analysis.status == MuscleTrainingStatus.undertraining) {
        recs.add('${analysis.muscleName}: ${analysis.weeklySets.toStringAsFixed(0)} sets/semana → '
            'agrega ${(_muscleUnderThreshold + 2 - analysis.weeklySets).toStringAsFixed(0)} sets.');
      } else if (analysis.status == MuscleTrainingStatus.overtraining) {
        recs.add('${analysis.muscleName}: ${analysis.weeklySets.toStringAsFixed(0)} sets/semana → '
            'reduce ${(analysis.weeklySets - _muscleOptimalMax).toStringAsFixed(0)} sets para recuperación.');
      }
    }

    // Fatigue-aware status recs
    final fatHigh = fatigueLevel != null && fatigueLevel >= _fatigueHighThreshold;
    if (fatHigh && isStrengthProgressing) {
      recs.add('Fatiga alta (${fatigueLevel.toStringAsFixed(1)}/10) con progreso → '
          'planifica descarga en 7-10 días, no pares.');
    } else if (fatHigh && !isStrengthProgressing) {
      recs.add('Fatiga alta (${fatigueLevel.toStringAsFixed(1)}/10) sin progreso → '
          'reduce volumen 30% esta semana, prioriza sueño.');
    }

    // Status-specific global recs
    switch (status) {
      case FitnessStatus.overtraining:
        if (recs.length <= exerciseInsights.length) {
          recs.add('Baja intensidad global: usa RPE 6-7 hasta recuperar.');
        }
      case FitnessStatus.stalled:
        if (adherence.consistencyScore < 70) {
          recs.add('Adherencia ${adherence.consistencyScore.toStringAsFixed(0)}% → '
              'establece ${(adherence.weeklyFrequency + 1).toStringAsFixed(0)} sesiones/semana.');
        }
      case FitnessStatus.goodProgress:
        if (weeklyWeightChange != null && weeklyWeightChange > 0.5) {
          recs.add('Peso +${weeklyWeightChange.toStringAsFixed(2)}kg/semana → '
              'ajusta déficit si objetivo es pérdida.');
        }
      case FitnessStatus.inconsistent:
        if (adherence.weeklyFrequency < 2) {
          recs.add('Solo ${adherence.weeklyFrequency.toStringAsFixed(1)} sesiones/semana → '
              'mínimo 3 para progreso óptimo.');
        }
    }

    if (fatigueTrend != null && fatigueTrend >= 1 && !fatHigh) {
      recs.add('Fatiga en ascenso (+${fatigueTrend.toStringAsFixed(1)}) → '
          'monitorea en 3-5 días.');
    }

    return recs;
  }

  // ================================================================
  //  Status Determination (strict priority)
  // ================================================================

  FitnessStatus _determineStatus({
    required num? weeklyWeightChange,
    required num? fatigueLevel,
    required bool isStrengthProgressing,
    required List<String> droppedExercises,
    required List<String> stalledExercises,
    required AdherenceMetrics adherence,
  }) {
    final hasRegression = droppedExercises.isNotEmpty;
    final hasStalled = stalledExercises.isNotEmpty;
    final fatHigh = fatigueLevel != null && fatigueLevel >= _fatigueHighThreshold;
    final progressNegative = weeklyWeightChange != null && weeklyWeightChange < 0;

    // 1. Overtraining: high fatigue + (regression or negative progress)
    if (fatHigh && (hasRegression || progressNegative)) {
      return FitnessStatus.overtraining;
    }

    // 2. Stalled: no regression, but stalled and no global progress
    if (!hasRegression && hasStalled && !isStrengthProgressing) {
      return FitnessStatus.stalled;
    }

    // 3. Good progress: weight ok, strength progressing, low fatigue, decent adherence
    final weightOk = weeklyWeightChange == null || weeklyWeightChange >= -0.5;
    final adherenceOk = adherence.consistencyScore >= _adherenceMinThreshold;
    if (weightOk && isStrengthProgressing && !fatHigh && adherenceOk) {
      return FitnessStatus.goodProgress;
    }

    return FitnessStatus.inconsistent;
  }

  // ================================================================
  //  Weight & Adherence (unchanged helpers)
  // ================================================================

  num? _computeWeeklyWeightChange(List<WeightEntry> entries) {
    if (entries.length < _minWeightEntries) {
      return null;
    }

    final cutoff = DateTime.now().subtract(const Duration(days: _analysisWeeks * 7));
    final relevant = entries.where((e) => e.date.isAfter(cutoff) || e.date.isAtSameMomentAs(cutoff)).toList();
    if (relevant.length < _minWeightEntries) {
      return null;
    }

    final first = relevant.first;
    final last = relevant.last;
    final daysDiff = last.date.difference(first.date).inDays;
    if (daysDiff < 7) {
      return null;
    }

    final weeks = daysDiff / 7;
    return (last.weight - first.weight) / weeks;
  }

  AdherenceMetrics _computeAdherenceMetrics(
    List<TrainingSession> sessions,
    DateTime start,
    DateTime end,
  ) {
    if (sessions.isEmpty) {
      return const AdherenceMetrics(
        weeklyFrequency: 0,
        maxGapDays: 0,
        consistencyScore: 0,
      );
    }

    final daysTotal = end.difference(start).inDays;
    final weeksTotal = daysTotal / 7;
    final frequency = weeksTotal > 0 ? sessions.length / weeksTotal : 0;

    int maxGap = 0;
    int currentGap = 0;
    var checkDate = start;
    final sessionDates = sessions.map((s) => DateTime(s.date.year, s.date.month, s.date.day)).toSet();

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
    final modalWeekly = weeklyCounts.values.isNotEmpty
        ? weeklyCounts.values.reduce((a, b) => a > b ? a : b)
        : 0;
    final expectedSessions = weeksTotal * modalWeekly;
    final consistency = expectedSessions > 0 ? (sessions.length / expectedSessions) * 100 : 0;

    return AdherenceMetrics(
      weeklyFrequency: frequency,
      maxGapDays: maxGap,
      consistencyScore: consistency > 100 ? 100 : consistency,
    );
  }

  // ================================================================
  //  Intensity Analysis (%1RM per set)
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
      return TrainingScoreBreakdown(
        progressScore: 0,
        adherenceScore: 0,
        fatigueScore: 0,
        dataQualityScore: (dataQualityScore / 100) * 15,
        total: dataQualityScore,
      );
    }

    final progressing = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.progressing).length;
    final progressScore = (progressing / exerciseInsights.length) * 40;

    final adherenceScore = (adherence.consistencyScore / 100) * 25;

    var fatigueScore = 20.0;
    if (fatigueLevel != null) {
      fatigueScore = fatigueLevel >= _fatigueHighThreshold ? 5.0 : 20.0 - (fatigueLevel * 1.5);
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
    final hasRegression = exerciseInsights.any((e) => e.progressStatus == ExerciseProgressStatus.regression);
    final totalWeeklySets = muscleAnalysis.values.map((m) => m.weeklySets).fold<num>(0, (a, b) => a + b);
    final highVolume = totalWeeklySets > _muscleOptimalMax * muscleAnalysis.length;
    final lowVolume = totalWeeklySets < _muscleUnderThreshold * muscleAnalysis.length;

    // Deload: very high fatigue + regression (highest priority)
    if (fatHigh && hasRegression) {
      return TrainingPhase.deload;
    }

    // Recovery: low fatigue + low volume
    if (!fatHigh && lowVolume && (previousPhase == TrainingPhase.deload || previousPhase == TrainingPhase.recovery)) {
      return TrainingPhase.recovery;
    }

    // Intensification: high intensity + progress + manageable fatigue
    final avgIntensity = exerciseInsights.isNotEmpty
        ? exerciseInsights.map((e) => e.currentE1rm).average
        : 0;
    final isProgressing = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.progressing).length >=
        (exerciseInsights.length / 2).ceil();
    if (isProgressing && !fatHigh && avgIntensity > 0) {
      return TrainingPhase.intensification;
    }

    // Accumulation: rising fatigue + high volume (even with progress)
    if (fatRising && highVolume) {
      return TrainingPhase.accumulation;
    }

    // Default based on previous phase to avoid jumping around
    if (previousPhase != null) {
      return previousPhase;
    }

    return TrainingPhase.accumulation;
  }

  // ================================================================
  //  Action Plan (max 3 high-impact, non-conflicting, phase-aware)
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

    // Helper: check if same action was taken recently
    bool wasRecentlyApplied(ActionItem candidate) {
      for (final past in previousState?.lastActions ?? <ActionItem>[]) {
        if (past.target == candidate.target && past.type == candidate.type) {
          return true;
        }
      }
      return false;
    }

    // Phase-specific overrides
    if (phase == TrainingPhase.deload) {
      // Global deload, block other actions
      const deloadAction = ActionItem(
        type: ActionType.deload,
        target: 'Global',
        value: 40,
        priority: 1,
        reason: 'Fase de deload: reducir volumen global 40% esta semana.',
      );
      if (!wasRecentlyApplied(deloadAction)) {
        actions.add(deloadAction);
      }
      return ActionPlan(
        actions: actions.take(3).toList(),
        summary: 'Semana de deload activa: recuperación antes de nueva progresión.',
      );
    }

    if (phase == TrainingPhase.recovery) {
      const recoveryAction = ActionItem(
        type: ActionType.addSets,
        target: 'Global',
        value: 2,
        priority: 2,
        reason: 'Fase de recuperación: agregar 2 sets progresivamente para volver a cargar.',
      );
      if (!wasRecentlyApplied(recoveryAction)) {
        actions.add(recoveryAction);
      }
      return ActionPlan(
        actions: actions.take(3).toList(),
        summary: 'Recuperación activa: volumen progresivo para retomar progresión.',
      );
    }

    // Accumulation: allow high fatigue if progressing, focus on volume
    if (phase == TrainingPhase.accumulation) {
      final underMuscles = muscleAnalysis.values.where((m) => m.status == MuscleTrainingStatus.undertraining).toList()
        ..sort((a, b) => a.weeklySets.compareTo(b.weeklySets));
      for (final muscle in underMuscles.take(1)) {
        final setsToAdd = (_muscleUnderThreshold + 2 - muscle.weeklySets).clamp(2, 4).toInt();
        final candidate = ActionItem(
          type: ActionType.addSets,
          target: muscle.muscleName,
          value: setsToAdd,
          priority: 2,
          reason: '${muscle.muscleName}: acumulación activa → agregar $setsToAdd sets.',
        );
        if (!wasRecentlyApplied(candidate)) {
          actions.add(candidate);
          targetsHandled.add(muscle.muscleName);
        }
      }
    }

    // Intensification: prioritize weight increase on progressing exercises
    if (phase == TrainingPhase.intensification) {
      final progressing = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.progressing).toList()
        ..sort((a, b) => b.e1rmChangePercent.compareTo(a.e1rmChangePercent));
      for (final insight in progressing.take(1)) {
        final candidate = ActionItem(
          type: ActionType.increaseWeight,
          target: insight.exerciseName,
          value: (insight.currentE1rm * 0.025).ceil(),
          priority: 1,
          reason: '${insight.exerciseName}: intensificación → subir ${(insight.currentE1rm * 0.025).ceil()}kg.',
        );
        if (!wasRecentlyApplied(candidate)) {
          actions.add(candidate);
          targetsHandled.add(insight.exerciseName);
        }
      }
    }

    // Fallback rules (always active, filtered by phase priority above)
    // Priority 1: Regression → reduce volume 20-30%
    final regressions = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.regression).toList()
      ..sort((a, b) => b.e1rmChangePercent.compareTo(a.e1rmChangePercent));
    for (final insight in regressions.take(1)) {
      final candidate = ActionItem(
        type: ActionType.reduceVolume,
        target: insight.exerciseName,
        value: 25,
        priority: 1,
        reason: '${insight.exerciseName} regresó ${(insight.e1rmChangePercent.abs() * 100).toStringAsFixed(1)}% → reducir volumen 25%.',
      );
      if (!wasRecentlyApplied(candidate) && !targetsHandled.contains(insight.exerciseName)) {
        actions.add(candidate);
        targetsHandled.add(insight.exerciseName);
      }
    }

    // Priority 2: Stalled exercises
    final stalled = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.stalled).toList()
      ..sort((a, b) => b.totalVolume.compareTo(a.totalVolume));
    for (final insight in stalled.take(1)) {
      if (targetsHandled.contains(insight.exerciseName)) {
        continue;
      }
      final intensity = intensityByExercise[insight.exerciseName] ?? 0;
      if (intensity < 80) {
        final candidate = ActionItem(
          type: ActionType.increaseWeight,
          target: insight.exerciseName,
          value: (insight.currentE1rm * 0.025).ceil(),
          priority: 2,
          reason: '${insight.exerciseName} estancado con baja intensidad → subir ${(insight.currentE1rm * 0.025).ceil()}kg.',
        );
        if (!wasRecentlyApplied(candidate)) {
          actions.add(candidate);
          targetsHandled.add(insight.exerciseName);
        }
      } else {
        final candidate = ActionItem(
          type: ActionType.reduceVolume,
          target: insight.exerciseName,
          value: 15,
          priority: 2,
          reason: '${insight.exerciseName} estancado con alta intensidad → reducir volumen 15%.',
        );
        if (!wasRecentlyApplied(candidate)) {
          actions.add(candidate);
          targetsHandled.add(insight.exerciseName);
        }
      }
    }

    // Priority 2: Undertrained muscles
    final underMuscles = muscleAnalysis.values.where((m) => m.status == MuscleTrainingStatus.undertraining).toList()
      ..sort((a, b) => a.weeklySets.compareTo(b.weeklySets));
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
        reason: '${muscle.muscleName} bajo volumen → agregar $setsToAdd sets.',
      );
      if (!wasRecentlyApplied(candidate)) {
        actions.add(candidate);
        targetsHandled.add(muscle.muscleName);
      }
    }

    // Priority 3: Overtrained muscles
    final overMuscles = muscleAnalysis.values.where((m) => m.status == MuscleTrainingStatus.overtraining).toList()
      ..sort((a, b) => b.weeklySets.compareTo(a.weeklySets));
    for (final muscle in overMuscles.take(1)) {
      if (targetsHandled.contains(muscle.muscleName)) {
        continue;
      }
      final setsToRemove = (muscle.weeklySets - _muscleOptimalMax).clamp(2, 6).toInt();
      final candidate = ActionItem(
        type: ActionType.reduceVolume,
        target: muscle.muscleName,
        value: setsToRemove,
        priority: 3,
        reason: '${muscle.muscleName} sobreentrenado → quitar $setsToRemove sets.',
      );
      if (!wasRecentlyApplied(candidate)) {
        actions.add(candidate);
        targetsHandled.add(muscle.muscleName);
      }
    }

    // Sort by priority ascending and keep max 3
    actions.sort((a, b) => a.priority.compareTo(b.priority));
    final selected = actions.take(3).toList();

    String summary;
    if (selected.isEmpty) {
      summary = 'Mantén tu plan actual: progreso estable y cargas bien distribuidas.';
    } else {
      final top = selected.first;
      summary = 'Foco semanal (${_phaseLabel(phase)}): ${top.reason}';
    }

    return ActionPlan(
      actions: selected,
      summary: summary,
    );
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

    final progressingCount = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.progressing).length;
    final stalledCount = exerciseInsights.where((e) => e.progressStatus == ExerciseProgressStatus.stalled).length;

    switch (phase) {
      case TrainingPhase.accumulation:
        situation = 'Fase de acumulación: volumen creciente con fatiga manejable.';
        directive = 'Mantené el volumen alto; si el progreso se estanca, pasá a intensificación.';
        if (progressingCount > 0) {
          note = '$progressingCount ejercicio(s) progresando — buena señal de adaptación.';
        }
      case TrainingPhase.intensification:
        situation = 'Fase de intensificación: cargas subiendo con progreso sostenido.';
        directive = 'Priorizá subir peso en ejercicios que progresan; no agregues más sets.';
        if (stalledCount > 0) {
          note = '$stalledCount ejercicio(s) estancado(s) — considerá técnica o descanso.';
        }
      case TrainingPhase.deload:
        situation = 'Fase de deload: fatiga alta con señales de regresión.';
        directive = 'Reducí volumen 40% esta semana; mantené técnica y recuperación.';
        note = 'Evitá proximidad al fallo; enfocate en sueño y nutrición.';
      case TrainingPhase.recovery:
        situation = 'Fase de recuperación: fatiga baja, volumen en reconstrucción.';
        directive = 'Agregá sets progresivamente (2-3 por semana) hasta volver a la carga base.';
        note = 'No apures el retorno; la consistencia supera la intensidad.';
    }

    if (actionPlan.actions.isEmpty) {
      directive = 'Todo en rango. Seguí con el plan actual sin cambios mayores.';
    }

    return CoachSummary(
      situation: situation,
      directive: directive,
      note: note,
    );
  }
}

// ------------------------------------------------------------------
// Internal helpers
// ------------------------------------------------------------------

class _E1rmEntry {
  final DateTime date;
  final num e1rm;

  _E1rmEntry({required this.date, required this.e1rm});
}
