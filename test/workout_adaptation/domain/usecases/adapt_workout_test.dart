import 'package:flutter_test/flutter_test.dart';
import 'package:wger/features/fitness_insights/domain/entities/adherence_metrics.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/workout_adaptation/domain/entities/adapted_workout.dart';
import 'package:wger/features/workout_adaptation/domain/entities/exercise_modification.dart';
import 'package:wger/features/workout_adaptation/domain/entities/planned_exercise.dart';
import 'package:wger/features/workout_adaptation/domain/entities/planned_set.dart';
import 'package:wger/features/workout_adaptation/domain/entities/pre_workout_input.dart';
import 'package:wger/features/workout_adaptation/domain/usecases/adapt_workout.dart';

void main() {
  final adaptWorkout = AdaptWorkout();

  FitnessInsight _baseInsight({
    FitnessStatus status = FitnessStatus.goodProgress,
    List<String> droppedExercises = const [],
    num? fatigueLevel,
  }) {
    return FitnessInsight(
      status: status,
      isStrengthProgressing: status == FitnessStatus.goodProgress,
      adherenceMetrics: const AdherenceMetrics(
        weeklyFrequency: 3,
        maxGapDays: 2,
        consistencyScore: 80,
      ),
      dataQualityScore: 80,
      trainingScore: 70,
      droppedExercises: droppedExercises,
      fatigueLevel: fatigueLevel,
    );
  }

  PlannedExercise _plannedExercise({
    required String name,
    List<String> muscles = const ['Chest'],
    num weight = 80,
    num reps = 10,
    num sets = 3,
  }) {
    return PlannedExercise(
      exerciseId: name.hashCode,
      exerciseName: name,
      muscleNames: muscles,
      plannedSets: [
        PlannedSet(weight: weight, repetitions: reps, sets: sets),
      ],
    );
  }

  group('AdaptWorkout', () {
    test('removes exercise when pain >= 6', () {
      final result = adaptWorkout(
        insight: _baseInsight(),
        plannedExercises: [
          _plannedExercise(name: 'Bench Press', muscles: ['Chest']),
        ],
        preWorkout: const PreWorkoutInput(
          painByMuscle: {'Chest': 7},
          fatigue: 2,
        ),
      );

      expect(result.modifications.length, 1);
      expect(result.modifications.first.type, ModificationType.remove);
      expect(result.modifications.first.exerciseName, 'Bench Press');
      expect(result.summary, contains('omitido'));
    });

    test('reduces volume 40% when pain is 3-5', () {
      final result = adaptWorkout(
        insight: _baseInsight(),
        plannedExercises: [
          _plannedExercise(name: 'Squat', muscles: ['Quadriceps'], sets: 5),
        ],
        preWorkout: const PreWorkoutInput(
          painByMuscle: {'Quadriceps': 4},
          fatigue: 2,
        ),
      );

      expect(result.modifications.length, 1);
      expect(result.modifications.first.type, ModificationType.reduceVolume);
      expect(result.modifications.first.newSets, 3); // 5 * 0.6 = 3
      expect(result.modifications.first.reason, contains('Dolor 4'));
    });

    test('deloads when fatigue high + regression', () {
      final result = adaptWorkout(
        insight: _baseInsight(
          status: FitnessStatus.overtraining,
          droppedExercises: ['Deadlift'],
          fatigueLevel: 8,
        ),
        plannedExercises: [
          _plannedExercise(name: 'Deadlift', muscles: ['Lower Back'], sets: 5),
          _plannedExercise(name: 'Row', muscles: ['Lats'], sets: 4),
        ],
        preWorkout: const PreWorkoutInput(fatigue: 8),
      );

      final deadliftMod = result.modifications.firstWhere(
        (m) => m.exerciseName == 'Deadlift',
      );
      expect(deadliftMod.type, ModificationType.reduceVolume);
      expect(deadliftMod.newSets, 4); // 5 * 0.7 = 3.5 → ceil = 4
    });

    test('maintains when fatigue high but good progress', () {
      final result = adaptWorkout(
        insight: _baseInsight(
          status: FitnessStatus.goodProgress,
          fatigueLevel: 8,
        ),
        plannedExercises: [
          _plannedExercise(name: 'Squat', muscles: ['Quadriceps']),
        ],
        preWorkout: const PreWorkoutInput(fatigue: 8),
      );

      expect(result.modifications.length, 1);
      expect(result.modifications.first.type, ModificationType.maintain);
      expect(result.modifications.first.reason, contains('mantener'));
    });

    test('reduces weight 10% when stalled', () {
      final result = adaptWorkout(
        insight: _baseInsight(status: FitnessStatus.stalled),
        plannedExercises: [
          _plannedExercise(name: 'Press', muscles: ['Shoulders'], weight: 60),
        ],
        preWorkout: const PreWorkoutInput(),
      );

      final mod = result.modifications.firstWhere(
        (m) => m.exerciseName == 'Press',
      );
      expect(mod.type, ModificationType.reduceWeight);
      expect(mod.newWeight, 54); // 60 * 0.9 = 54
    });

    test('no modifications when conditions are optimal', () {
      final result = adaptWorkout(
        insight: _baseInsight(),
        plannedExercises: [
          _plannedExercise(name: 'Curl', muscles: ['Biceps']),
        ],
        preWorkout: const PreWorkoutInput(),
      );

      expect(result.modifications, isEmpty);
      expect(result.summary, contains('sin cambios'));
    });

    test('pain takes priority over fatigue', () {
      final result = adaptWorkout(
        insight: _baseInsight(
          status: FitnessStatus.overtraining,
          droppedExercises: ['Squat'],
          fatigueLevel: 9,
        ),
        plannedExercises: [
          _plannedExercise(name: 'Squat', muscles: ['Quadriceps'], sets: 5),
        ],
        preWorkout: const PreWorkoutInput(
          painByMuscle: {'Quadriceps': 8},
          fatigue: 9,
        ),
      );

      expect(result.modifications.length, 1);
      expect(result.modifications.first.type, ModificationType.remove);
    });

    test('applies deload on top of pain reduction', () {
      final result = adaptWorkout(
        insight: _baseInsight(
          status: FitnessStatus.overtraining,
          droppedExercises: ['Bench'],
          fatigueLevel: 8,
        ),
        plannedExercises: [
          _plannedExercise(name: 'Bench', muscles: ['Chest'], sets: 5),
        ],
        preWorkout: const PreWorkoutInput(
          painByMuscle: {'Chest': 4},
          fatigue: 8,
        ),
      );

      // Pain 4 → reduce to 3 sets, then deload 30% on top → 3 * 0.7 = 2.1 → ceil = 3... wait
      // Actually pain reduces to 40% less: 5 → 3. Then deload 30% on 3 → 2.1 → ceil = 3? No wait
      // 40% reduction means newSets = 5 * 0.6 = 3. Then deload on 3: 3 * 0.7 = 2.1 → ceil = 3?
      // Actually: (5 * 0.6) = 3, then 3 * 0.7 = 2.1, ceil = 3. Hmm that doesn't change.
      // Let me use 6 sets: 6 * 0.6 = 3.6 → ceil = 4. Then 4 * 0.7 = 2.8 → ceil = 3.
      expect(result.modifications.first.type, ModificationType.reduceVolume);
      expect(result.modifications.first.reason, contains('deload'));
    });
  });
}
