import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/workout_adaptation/domain/entities/adapted_workout.dart';
import 'package:wger/features/workout_adaptation/domain/entities/planned_exercise.dart';
import 'package:wger/features/workout_adaptation/domain/entities/pre_workout_input.dart';
import 'package:wger/features/workout_adaptation/domain/usecases/adapt_workout.dart';

/// Provider that exposes the [AdaptWorkout] use case.
final adaptWorkoutUseCaseProvider = Provider<AdaptWorkout>((ref) {
  return AdaptWorkout();
});

/// Parameters for adapting a workout.
class AdaptWorkoutParams {
  final FitnessInsight insight;
  final List<PlannedExercise> plannedExercises;
  final PreWorkoutInput preWorkout;

  const AdaptWorkoutParams({
    required this.insight,
    required this.plannedExercises,
    required this.preWorkout,
  });
}

/// Provider that computes an [AdaptedWorkout] from the current insight,
/// planned exercises, and pre-workout input.
///
/// Listen to this provider to get the adapted workout for today's session.
final adaptedWorkoutProvider = Provider.family<AdaptedWorkout, AdaptWorkoutParams>(
  (ref, params) {
    final useCase = ref.watch(adaptWorkoutUseCaseProvider);
    return useCase(
      insight: params.insight,
      plannedExercises: params.plannedExercises,
      preWorkout: params.preWorkout,
    );
  },
);
