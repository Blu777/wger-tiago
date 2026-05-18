import 'package:wger/features/fitness_insights/domain/entities/session_adherence.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_adaptation.dart';
import 'package:wger/models/workouts/log.dart';

/// Pure use case that compares planned (adapted) workout values against
/// actually executed log values to produce a [SessionAdherence] report.
class ComputeAdherence {
  SessionAdherence call({
    required WorkoutAdaptation adaptation,
    required List<Log> sessionLogs,
    required DateTime sessionDate,
  }) {
    final exerciseAdherences = <ExerciseAdherence>[];
    int overrideCount = 0;

    // Group logs by exercise ID
    final logsByExercise = <int, List<Log>>{};
    for (final log in sessionLogs) {
      logsByExercise.putIfAbsent(log.exerciseId, () => []).add(log);
    }

    // Walk through adapted slots to find planned values
    for (final slot in adaptation.adaptedSlots) {
      for (final config in slot.setConfigs) {
        if (config.exercise.id == null) {
          continue;
        }
        final exerciseId = config.exercise.id!;
        final logs = logsByExercise[exerciseId];
        if (logs == null || logs.isEmpty) {
          continue;
        }

        final plannedWeight = config.weight ?? 0;
        final plannedReps = config.repetitions ?? 0;

        // Use the first log for this exercise as representative
        final executedLog = logs.first;
        final executedWeight = executedLog.weight ?? 0;
        final executedReps = executedLog.repetitions ?? 0;

        final wasOverridden = _isOverride(plannedWeight, executedWeight) ||
            _isOverride(plannedReps, executedReps);

        if (wasOverridden) {
          overrideCount++;
        }

        String exerciseName;
        try {
          exerciseName = config.exercise.getTranslation('es').name;
        } catch (_) {
          try {
            exerciseName = config.exercise.getTranslation('en').name;
          } catch (_) {
            exerciseName = config.exercise.translations.isNotEmpty
                ? config.exercise.translations.first.name
                : 'Ejercicio $exerciseId';
          }
        }

        exerciseAdherences.add(ExerciseAdherence(
          exerciseName: exerciseName,
          plannedWeight: plannedWeight,
          executedWeight: executedWeight,
          plannedReps: plannedReps,
          executedReps: executedReps,
          wasOverridden: wasOverridden,
        ));

        // Remove from map so we don't double-count
        logsByExercise.remove(exerciseId);
      }
    }

    final totalExercises = exerciseAdherences.length;
    final overallScore = totalExercises > 0
        ? _computeOverallScore(exerciseAdherences)
        : 100.0;

    return SessionAdherence(
      date: sessionDate,
      wasAdapted: adaptation.hasModifications,
      exercises: exerciseAdherences,
      overallScore: overallScore,
      overrideCount: overrideCount,
      totalExercises: totalExercises,
    );
  }

  /// An override is when the user changed the value by more than 5%.
  bool _isOverride(num planned, num executed) {
    if (planned == 0) {
      return executed != 0;
    }
    final diff = ((executed - planned) / planned).abs();
    return diff > 0.05;
  }

  /// Score: average of per-exercise adherence (weight + reps closeness).
  /// 100 = perfect adherence; penalized proportionally for deviations.
  double _computeOverallScore(List<ExerciseAdherence> exercises) {
    if (exercises.isEmpty) {
      return 100;
    }

    var totalScore = 0.0;
    for (final ex in exercises) {
      final weightScore = _closenessScore(ex.plannedWeight, ex.executedWeight);
      final repsScore = _closenessScore(ex.plannedReps, ex.executedReps);
      totalScore += weightScore * 0.6 + repsScore * 0.4; // weight matters more
    }
    return (totalScore / exercises.length).clamp(0, 100);
  }

  double _closenessScore(num planned, num executed) {
    if (planned == 0 && executed == 0) {
      return 100;
    }
    if (planned == 0) {
      return 0;
    }
    final ratio = executed / planned;
    // Perfect = 1.0, penalize divergence symmetrically
    final deviation = (ratio - 1.0).abs();
    return (100 * (1.0 - deviation.clamp(0, 1))).clamp(0, 100);
  }
}
