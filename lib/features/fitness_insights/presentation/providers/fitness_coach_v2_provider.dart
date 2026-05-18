import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wger/features/body_weight/presentation/providers/body_weight_provider.dart';
import 'package:wger/features/fitness_insights/data/repositories/training_repository.dart';
import 'package:wger/features/fitness_insights/data/repositories/training_repository_impl.dart';
import 'package:wger/features/fitness_insights/domain/entities/adherence_metrics.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/subjective_feedback.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_goal.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';
import 'package:wger/features/fitness_insights/domain/usecases/analyze_training_v2.dart';
import 'package:wger/features/fitness_insights/presentation/providers/session_adherence_provider.dart';
import 'package:wger/providers/wger_base_riverpod.dart';

part 'fitness_coach_v2_provider.g.dart';

// ------------------------------------------------------------------
// Persistence keys
// ------------------------------------------------------------------
const _kTrainingGoalKey = 'fitness_coach_v2_training_goal';
const _kCachedInsightKey = 'fitness_coach_v2_cached_insight';

// ------------------------------------------------------------------
// Training Goal Provider (persisted)
// ------------------------------------------------------------------

/// Manages the user's selected [TrainingGoal], persisted via SharedPreferences.
@Riverpod(keepAlive: true)
class TrainingGoalNotifier extends _$TrainingGoalNotifier {
  @override
  TrainingGoal build() {
    _loadFromPrefs();
    return TrainingGoal.hypertrophy; // initial default; overwritten once prefs load
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kTrainingGoalKey);
    if (stored != null) {
      final parsed = TrainingGoal.values.firstWhere(
        (g) => g.name == stored,
        orElse: () => TrainingGoal.hypertrophy,
      );
      state = parsed;
    }
  }

  Future<void> setGoal(TrainingGoal goal) async {
    state = goal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTrainingGoalKey, goal.name);
    // Invalidate the insight so it re-runs with the new goal
    ref.invalidate(fitnessCoachV2Provider);
  }
}

/// Async gate: resolves to the persisted [TrainingGoal] after SharedPreferences
/// has been read. [FitnessCoachV2] watches this instead of the raw sync notifier
/// so it never runs analysis with the default goal before prefs have loaded.
@Riverpod(keepAlive: true)
Future<TrainingGoal> trainingGoalReady(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  final stored = prefs.getString(_kTrainingGoalKey);
  TrainingGoal loaded = TrainingGoal.hypertrophy;
  if (stored != null) {
    loaded = TrainingGoal.values.firstWhere(
      (g) => g.name == stored,
      orElse: () => TrainingGoal.hypertrophy,
    );
  }
  return loaded;
}

// ------------------------------------------------------------------
// Repository + Sessions cache (reuses existing impl)
// ------------------------------------------------------------------

@riverpod
ITrainingRepository trainingRepositoryV2(Ref ref) {
  final base = ref.watch(wgerBaseProvider);
  final exercises = ref.watch(exercisesRiverpodProvider);
  return TrainingRepositoryImpl(base, exercises);
}

/// Cached sessions provider — fetches once and holds the result.
/// Prevents [FitnessCoachV2] from re-fetching on every rebuild.
@riverpod
Future<List<TrainingSession>> trainingSessions(Ref ref) {
  return ref.watch(trainingRepositoryV2Provider).fetchSessions();
}

// ------------------------------------------------------------------
// Main Coach V2 Provider (with caching)
// ------------------------------------------------------------------

/// V2 coaching pipeline that:
/// 1. Fetches sessions + body-weight from API.
/// 2. Runs [AnalyzeTrainingV2] with the user's [TrainingGoal].
/// 3. Caches the result locally for fast app-start.
@riverpod
class FitnessCoachV2 extends _$FitnessCoachV2 {
  @override
  Future<FitnessInsight> build() async {
    // Await persisted goal — never run with the default before prefs load.
    final goal = await ref.watch(trainingGoalReadyProvider.future);

    // Await adherence history load — never run with empty list on cold start.
    // sessionAdherenceProvider is a sync Notifier; we await its async loader via
    // the dedicated gate provider.
    await ref.watch(sessionAdherenceReadyProvider.future);
    final adherenceHistory = ref.read(sessionAdherenceProvider);

    final sessions = await ref.watch(trainingSessionsProvider.future);
    final weights = await ref.watch(bodyWeightProvider.future);

    // Convert adherence history into synthetic feedback signals.
    // Only non-adapted sessions with genuine overrides contribute.
    final syntheticFeedback = <SubjectiveFeedback>[];
    for (final record in adherenceHistory) {
      // Skip sessions where user wasn't given an adaptation — no signal to extract.
      if (!record.wasAdapted) {
        continue;
      }
      // Map adherence score to inverse fatigue: 100 score → fatigue 1, 0 score → fatigue 10
      final fatigue = ((1 - record.overallScore / 100) * 9 + 1).round().clamp(1, 10);
      // Map adherence score to energy (high adherence = high energy)
      final energy = (record.overallScore / 10).round().clamp(1, 10);
      syntheticFeedback.add(SubjectiveFeedback(
        date: record.date,
        fatigue: fatigue,
        energy: energy,
      ));
    }

    final analyze = AnalyzeTrainingV2();
    final insight = analyze(
      weightEntries: weights,
      sessions: sessions,
      feedback: syntheticFeedback,
      goal: goal,
    );

    // Cache asynchronously (fire-and-forget)
    _cacheInsight(insight);

    return insight;
  }

  /// Load cached insight from SharedPreferences (used on cold start).
  Future<FitnessInsight?> loadCached() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_kCachedInsightKey);
    if (json == null) {
      return null;
    }
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return _deserializeInsight(map);
    } catch (e, st) {
      debugPrint('[FitnessCoachV2] cache read/deserialize failed: $e\n$st');
      return null;
    }
  }

  Future<void> _cacheInsight(FitnessInsight insight) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(_serializeInsight(insight));
      await prefs.setString(_kCachedInsightKey, json);
    } catch (e, st) {
      debugPrint('[FitnessCoachV2] cache write failed: $e\n$st');
    }
  }

  /// Minimal serialization of the key insight fields we want to restore on cold start.
  Map<String, dynamic> _serializeInsight(FitnessInsight insight) {
    return {
      'status': insight.status.name,
      'trainingScore': insight.trainingScore,
      'isStrengthProgressing': insight.isStrengthProgressing,
      'fatigueLevel': insight.fatigueLevel,
      'dataQualityScore': insight.dataQualityScore,
      'stalledExercises': insight.stalledExercises,
      'droppedExercises': insight.droppedExercises,
      'recommendations': insight.recommendations,
      'weeklyWeightChange': insight.weeklyWeightChange,
      'fatigueTrend': insight.fatigueTrend,
      'trainingPhase': insight.trainingPhase?.name,
      'actionPlanSummary': insight.actionPlan.summary,
      'coachSituation': insight.coachSummary?.situation,
      'coachDirective': insight.coachSummary?.directive,
      'coachNote': insight.coachSummary?.note,
      'cachedAt': DateTime.now().toIso8601String(),
      'adherenceWeeklyFrequency': insight.adherenceMetrics.weeklyFrequency,
      'adherenceMaxGapDays': insight.adherenceMetrics.maxGapDays,
      'adherenceConsistencyScore': insight.adherenceMetrics.consistencyScore,
    };
  }

  FitnessInsight? _deserializeInsight(Map<String, dynamic> map) {
    final statusName = map['status'] as String?;
    if (statusName == null) {
      return null;
    }

    final status = FitnessStatus.values.firstWhere(
      (s) => s.name == statusName,
      orElse: () => FitnessStatus.inconsistent,
    );

    return FitnessInsight(
      status: status,
      trainingScore: (map['trainingScore'] as num?) ?? 0,
      isStrengthProgressing: (map['isStrengthProgressing'] as bool?) ?? false,
      fatigueLevel: map['fatigueLevel'] as num?,
      dataQualityScore: (map['dataQualityScore'] as num?) ?? 0,
      stalledExercises: ((map['stalledExercises'] as List?) ?? []).cast<String>(),
      droppedExercises: ((map['droppedExercises'] as List?) ?? []).cast<String>(),
      recommendations: ((map['recommendations'] as List?) ?? []).cast<String>(),
      weeklyWeightChange: map['weeklyWeightChange'] as num?,
      fatigueTrend: map['fatigueTrend'] as num?,
      adherenceMetrics: AdherenceMetrics(
        weeklyFrequency: (map['adherenceWeeklyFrequency'] as num?) ?? 0,
        maxGapDays: (map['adherenceMaxGapDays'] as num?)?.toInt() ?? 0,
        consistencyScore: (map['adherenceConsistencyScore'] as num?) ?? 0,
      ),
    );
  }
}
