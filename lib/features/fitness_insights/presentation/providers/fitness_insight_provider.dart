import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wger/features/body_weight/presentation/providers/body_weight_provider.dart';
import 'package:wger/features/fitness_insights/data/repositories/training_repository_impl.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/subjective_feedback.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';
import 'package:wger/features/fitness_insights/domain/usecases/analyze_training.dart';
import 'package:wger/providers/wger_base_riverpod.dart';

part 'fitness_insight_provider.g.dart';

/// Repository provider — clean, swappable, no legacy Provider dependency.
@riverpod
TrainingRepositoryImpl trainingRepository(Ref ref) {
  final base = ref.watch(wgerBaseProvider);
  return TrainingRepositoryImpl(base);
}

/// Fetches domain-level [TrainingSession] entities from the API.
@riverpod
Future<List<TrainingSession>> trainingSessions(Ref ref) async {
  return ref.watch(trainingRepositoryProvider).fetchSessions();
}

/// Stub provider for subjective feedback.
/// Returns an empty list until a real data source is wired in.
@riverpod
List<SubjectiveFeedback> subjectiveFeedback(Ref ref) {
  return [];
}

/// Central insight provider that aggregates weight, training and feedback
/// data, runs the pure [AnalyzeTraining] use case, and exposes the result.
@riverpod
Future<FitnessInsight> fitnessInsight(Ref ref) async {
  final weightAsync = ref.watch(bodyWeightProvider.future);
  final sessionsAsync = ref.watch(trainingSessionsProvider.future);
  final feedback = ref.watch(subjectiveFeedbackProvider);

  // Wait for all async sources to resolve
  final weights = await weightAsync;
  final sessions = await sessionsAsync;

  final analyze = AnalyzeTraining();
  return analyze(
    weightEntries: weights,
    sessions: sessions,
    feedback: feedback,
  );
}
