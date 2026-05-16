import 'package:wger/features/fitness_insights/domain/entities/exercise_performance.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_set.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/exercises/translation.dart';
import 'package:wger/models/workouts/log.dart';
import 'package:wger/models/workouts/session.dart';

/// Pure function that maps a wger [WorkoutSession] to a domain
/// [TrainingSession]. No side effects, no dependencies on framework code.
TrainingSession mapWorkoutSession(WorkoutSession source) {
  // Group logs by exerciseId
  final logsByExercise = <int, List<Log>>{};
  for (final log in source.logs) {
    logsByExercise.putIfAbsent(log.exerciseId, () => []).add(log);
  }

  final performances = <ExercisePerformance>[];
  for (final entry in logsByExercise.entries) {
    final logs = entry.value;
    if (logs.isEmpty) {
      continue;
    }

    final exerciseName = _pickExerciseName(logs.first.exercise.translations, entry.key);
    final sets = logs
        .where((log) => log.weight != null && log.repetitions != null)
        .map(
          (log) => ExerciseSet(
            weight: log.weight!,
            repetitions: log.repetitions!,
          ),
        )
        .toList();

    // Extract muscle names from primary and secondary muscles
    final muscleNames = <String>[];
    final exercise = logs.first.exercise;
    for (final m in exercise.muscles) {
      muscleNames.add(m.name);
    }
    for (final m in exercise.musclesSecondary) {
      if (!muscleNames.contains(m.name)) {
        muscleNames.add(m.name);
      }
    }

    if (sets.isNotEmpty) {
      performances.add(
        ExercisePerformance(
          exerciseId: entry.key,
          exerciseName: exerciseName,
          sets: sets,
          muscleNames: muscleNames,
        ),
      );
    }
  }

  int? durationMinutes;
  final duration = source.duration;
  if (duration != null) {
    durationMinutes = duration.inMinutes;
  }

  return TrainingSession(
    date: source.date,
    exercises: performances,
    impression: source.impression,
    durationMinutes: durationMinutes,
  );
}

/// Busca el nombre del ejercicio en español, luego inglés, luego cualquier disponible.
String _pickExerciseName(List<Translation> translations, int exerciseId) {
  if (translations.isEmpty) {
    return 'Exercise $exerciseId';
  }

  String? fallback;
  for (final t in translations) {
    final code = t.languageObj?.shortName ?? '';
    if (code == 'es') {
      return t.name;
    }
    if (code == LANGUAGE_SHORT_ENGLISH) {
      fallback = t.name;
    }
  }

  return fallback ?? translations.first.name;
}
