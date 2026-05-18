import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wger/features/body_weight/presentation/providers/body_weight_provider.dart';
import 'package:wger/features/fitness_insights/data/repositories/training_repository.dart';
import 'package:wger/features/fitness_insights/data/repositories/training_repository_impl.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/usecases/analyze_training_v2.dart';
import 'package:wger/features/fitness_insights/presentation/providers/fitness_coach_v2_provider.dart';
import 'package:wger/providers/wger_base_riverpod.dart';

part 'v2_fitness_insight_provider.g.dart';

/// Clean v2 provider for [ITrainingRepository].
/// Fetches raw workout sessions from the API and maps them to
/// domain [TrainingSession] entities.
@riverpod
ITrainingRepository trainingRepository(Ref ref) {
  final base = ref.watch(wgerBaseProvider);
  final exercises = ref.watch(exercisesRiverpodProvider);
  return TrainingRepositoryImpl(base, exercises);
}

/// Clean v2 pipeline that produces a [FitnessInsight].
///
/// Steps:
/// 1. Fetches [WorkoutSession] from API via [ITrainingRepository]
///    and maps them to [TrainingSession] internally.
/// 2. Fetches body-weight entries.
/// 3. Runs the [AnalyzeTrainingV2] use case with the user's goal.
/// 4. Returns [AsyncValue<FitnessInsight>].
@riverpod
class V2FitnessInsight extends _$V2FitnessInsight {
  @override
  Future<FitnessInsight> build() async {
    final goal = ref.watch(trainingGoalProvider);
    final sessions = await ref.watch(trainingRepositoryProvider).fetchSessions();
    final weights = await ref.watch(bodyWeightProvider.future);

    final analyze = AnalyzeTrainingV2();
    return analyze(
      weightEntries: weights,
      sessions: sessions,
      feedback: [],
      goal: goal,
    );
  }
}
