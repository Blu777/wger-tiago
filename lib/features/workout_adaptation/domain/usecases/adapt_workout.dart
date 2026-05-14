import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/workout_adaptation/domain/entities/adapted_workout.dart';
import 'package:wger/features/workout_adaptation/domain/entities/exercise_modification.dart';
import 'package:wger/features/workout_adaptation/domain/entities/planned_exercise.dart';
import 'package:wger/features/workout_adaptation/domain/entities/pre_workout_input.dart';

/// Pure, deterministic use case that adapts today's planned workout based on
/// the current fitness insight and pre-workout subjective input.
class AdaptWorkout {
  static const num _fatigueHighThreshold = 6.0;
  static const int _painRemoveThreshold = 6;
  static const int _painReduceThreshold = 3;
  static const num _volumeReductionModerate = 0.40; // 40%
  static const num _volumeReductionMild = 0.25; // 25%
  static const num _deloadVolumeReduction = 0.30; // 30%
  static const num _weightReduction = 0.10; // 10%

  AdaptedWorkout call({
    required FitnessInsight insight,
    required List<PlannedExercise> plannedExercises,
    required PreWorkoutInput preWorkout,
  }) {
    final modifications = <ExerciseModification>[];
    final fatHigh = preWorkout.fatigue >= _fatigueHighThreshold ||
        (insight.fatigueLevel != null && insight.fatigueLevel! >= _fatigueHighThreshold);

    // --- 1. Pain-based modifications (highest priority) ---
    for (final exercise in plannedExercises) {
      // Find max pain across all muscles targeted by this exercise
      var maxPain = 0;
      for (final muscle in exercise.muscleNames) {
        final pain = preWorkout.painByMuscle[muscle] ?? 0;
        if (pain > maxPain) {
          maxPain = pain;
        }
      }

      if (maxPain >= _painRemoveThreshold) {
        modifications.add(ExerciseModification(
          type: ModificationType.remove,
          exerciseName: exercise.exerciseName,
          reason: 'Dolor $maxPain/10 en ${exercise.muscleNames.join(", ")} → omitir ejercicio.',
        ));
        continue;
      }

      if (maxPain >= _painReduceThreshold) {
        // Reduce volume 40% for moderate pain
        final totalSets = exercise.plannedSets.map((s) => s.sets).fold<num>(0, (a, b) => a + b);
        final newSets = (totalSets * (1 - _volumeReductionModerate)).ceil();
        modifications.add(ExerciseModification(
          type: ModificationType.reduceVolume,
          exerciseName: exercise.exerciseName,
          reason: 'Dolor $maxPain/10 → reducir sets de ${totalSets.toStringAsFixed(0)} a $newSets.',
          newSets: newSets,
        ));
        continue;
      }
    }

    // --- 2. Fatigue + insight-based global modifications ---
    if (fatHigh) {
      final hasRegression = insight.droppedExercises.isNotEmpty;
      final isGoodProgress = insight.status == FitnessStatus.goodProgress;

      if (hasRegression) {
        // Deload: reduce volume globally 30%
        for (final exercise in plannedExercises) {
          // Skip if already removed by pain
          if (modifications.any((m) => m.exerciseName == exercise.exerciseName && m.type == ModificationType.remove)) {
            continue;
          }

          // Check if already modified by pain
          final existing = modifications.where(
            (m) => m.exerciseName == exercise.exerciseName,
          ).firstOrNull;
          if (existing != null && existing.type == ModificationType.reduceVolume) {
            // Stack reductions: apply deload on top of pain reduction
            final totalSets = exercise.plannedSets.map((s) => s.sets).fold<num>(0, (a, b) => a + b);
            final painReducedSets = existing.newSets ?? totalSets;
            final deloadSets = (painReducedSets * (1 - _deloadVolumeReduction)).ceil();
            modifications.remove(existing);
            modifications.add(ExerciseModification(
              type: ModificationType.reduceVolume,
              exerciseName: exercise.exerciseName,
              reason: '${existing.reason} + fatiga alta con regresión → deload adicional a $deloadSets sets.',
              newSets: deloadSets,
            ));
          } else {
            final totalSets = exercise.plannedSets.map((s) => s.sets).fold<num>(0, (a, b) => a + b);
            final deloadSets = (totalSets * (1 - _deloadVolumeReduction)).ceil();
            modifications.add(ExerciseModification(
              type: ModificationType.reduceVolume,
              exerciseName: exercise.exerciseName,
              reason: 'Fatiga alta con regresión → deload: ${totalSets.toStringAsFixed(0)} a $deloadSets sets.',
              newSets: deloadSets,
            ));
          }
        }
      } else if (isGoodProgress) {
        // High fatigue but good progress → maintain, no overload
        for (final exercise in plannedExercises) {
          if (modifications.any((m) => m.exerciseName == exercise.exerciseName)) {
            continue;
          }
          modifications.add(ExerciseModification(
            type: ModificationType.maintain,
            exerciseName: exercise.exerciseName,
            reason: 'Fatiga alta pero progreso sostenido → mantener sin sobrecarga.',
          ));
        }
      } else {
        // High fatigue without clear progress → mild volume reduction
        for (final exercise in plannedExercises) {
          if (modifications.any((m) => m.exerciseName == exercise.exerciseName)) {
            continue;
          }
          final totalSets = exercise.plannedSets.map((s) => s.sets).fold<num>(0, (a, b) => a + b);
          final reducedSets = (totalSets * (1 - _volumeReductionMild)).ceil();
          modifications.add(ExerciseModification(
            type: ModificationType.reduceVolume,
            exerciseName: exercise.exerciseName,
            reason: 'Fatiga alta sin progreso claro → reducir volumen 25%.',
            newSets: reducedSets,
          ));
        }
      }
    }

    // --- 3. Status-based weight adjustments (stalled/overtraining) ---
    if (insight.status == FitnessStatus.stalled || insight.status == FitnessStatus.overtraining) {
      for (final exercise in plannedExercises) {
        if (modifications.any((m) => m.exerciseName == exercise.exerciseName && m.type == ModificationType.remove)) {
          continue;
        }

        final existing = modifications.where((m) => m.exerciseName == exercise.exerciseName).toList();
        if (existing.isNotEmpty && existing.first.type == ModificationType.maintain) {
          continue;
        }

        // If no volume modification yet, reduce weight 10%
        if (existing.isEmpty || existing.first.newWeight == null) {
          final firstSet = exercise.plannedSets.firstOrNull;
          if (firstSet != null) {
            final newWeight = (firstSet.weight * (1 - _weightReduction)).ceil();
            final reason = insight.status == FitnessStatus.overtraining
                ? 'Overtraining detectado → bajar peso 10%.'
                : 'Estancamiento detectado → bajar peso 10% para recuperar progresión.';

            if (existing.isNotEmpty) {
              final old = existing.first;
              modifications.remove(old);
              modifications.add(ExerciseModification(
                type: old.type,
                exerciseName: exercise.exerciseName,
                reason: '${old.reason} + $reason',
                newSets: old.newSets,
                newWeight: newWeight,
              ));
            } else {
              modifications.add(ExerciseModification(
                type: ModificationType.reduceWeight,
                exerciseName: exercise.exerciseName,
                reason: reason,
                newWeight: newWeight,
              ));
            }
          }
        }
      }
    }

    // --- 4. Build summary ---
    final summary = _buildSummary(modifications, fatHigh, insight.status);

    return AdaptedWorkout(
      modifications: modifications,
      summary: summary,
    );
  }

  String _buildSummary(List<ExerciseModification> mods, bool fatHigh, FitnessStatus status) {
    final removed = mods.where((m) => m.type == ModificationType.remove).length;
    final reducedVol = mods.where((m) => m.type == ModificationType.reduceVolume).length;
    final reducedWeight = mods.where((m) => m.type == ModificationType.reduceWeight).length;
    final maintained = mods.where((m) => m.type == ModificationType.maintain).length;

    final parts = <String>[];
    if (removed > 0) {
      parts.add('$removed ejercicio(s) omitido(s) por dolor');
    }
    if (reducedVol > 0) {
      parts.add('$reducedVol ejercicio(s) con volumen reducido');
    }
    if (reducedWeight > 0) {
      parts.add('$reducedWeight ejercicio(s) con peso reducido');
    }
    if (maintained > 0) {
      parts.add('$maintained ejercicio(s) mantenido(s) sin sobrecarga');
    }

    if (parts.isEmpty) {
      return 'Entrenamiento sin cambios: condiciones óptimas.';
    }

    var summary = parts.join('; ');
    if (fatHigh) {
      summary += '. Precaución: fatiga elevada detectada.';
    }
    if (status == FitnessStatus.overtraining) {
      summary += ' Recomendación: priorizar recuperación esta semana.';
    }

    return summary;
  }
}
