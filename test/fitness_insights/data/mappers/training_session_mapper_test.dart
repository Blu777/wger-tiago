import 'package:flutter_test/flutter_test.dart';
import 'package:wger/features/fitness_insights/data/mappers/training_session_mapper.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/exercises/translation.dart';
import 'package:wger/models/workouts/log.dart';
import 'package:wger/models/workouts/session.dart';

void main() {
  group('mapWorkoutSession', () {
    test('maps empty session correctly', () {
      final source = WorkoutSession(
        routineId: 1,
        date: DateTime(2024, 1, 1),
        impression: 2,
        logs: [],
      );

      final result = mapWorkoutSession(source);

      expect(result.exercises, isEmpty);
      expect(result.date, DateTime(2024, 1, 1));
      expect(result.impression, 2);
    });

    test('maps session with single exercise and multiple sets', () {
      final exercise = const Exercise(
        id: 1,
        translations: [Translation(name: 'Squat', languageId: 1, description: '')],
      );
      final log1 = Log(
        exerciseId: 1,
        routineId: 1,
        weight: 100,
        repetitions: 5,
      );
      log1.exerciseBase = exercise;
      final log2 = Log(
        exerciseId: 1,
        routineId: 1,
        weight: 105,
        repetitions: 5,
      );
      log2.exerciseBase = exercise;
      final source = WorkoutSession(
        routineId: 1,
        date: DateTime(2024, 1, 1),
        impression: 3,
        logs: [log1, log2],
      );

      final result = mapWorkoutSession(source);

      expect(result.exercises.length, 1);
      expect(result.exercises.first.exerciseName, 'Squat');
      expect(result.exercises.first.sets.length, 2);
      expect(result.exercises.first.sets.first.weight, 100);
      expect(result.exercises.first.sets.last.weight, 105);
    });

    test('ignores logs with null weight or repetitions', () {
      final exercise = const Exercise(
        id: 1,
        translations: [Translation(name: 'Bench', languageId: 1, description: '')],
      );
      final log1 = Log(
        exerciseId: 1,
        routineId: 1,
        weight: 80,
        repetitions: 8,
      );
      log1.exerciseBase = exercise;
      final log2 = Log(
        exerciseId: 1,
        routineId: 1,
        weight: null,
        repetitions: 8,
      );
      log2.exerciseBase = exercise;
      final source = WorkoutSession(
        routineId: 1,
        date: DateTime(2024, 1, 1),
        impression: 2,
        logs: [log1, log2],
      );

      final result = mapWorkoutSession(source);

      expect(result.exercises.first.sets.length, 1);
    });
  });
}
