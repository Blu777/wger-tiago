import 'package:wger/features/fitness_insights/domain/entities/pre_workout_checkin.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_adaptation.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_modification.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/workouts/day_data.dart';
import 'package:wger/models/workouts/set_config_data.dart';
import 'package:wger/models/workouts/slot_data.dart';

/// Pure use case that adapts a planned workout based on pre-workout checkin.
///
/// Rules:
/// - Muscle pain ≥ 7 → reduce weight 10% (pain 7–8) or 20% (pain 9–10)
/// - Muscle pain ≥ 5 → reduce sets by 1
/// - Fatigue ≥ 8    → reduce sets by 1 globally
/// - Fatigue ≥ 6    → reduce weight 5% globally
class AdaptWorkout {
  static const _painHighThreshold = 7;
  static const _painMediumThreshold = 5;
  static const _fatigueHighThreshold = 8;
  static const _fatigueMediumThreshold = 6;

  WorkoutAdaptation call({
    required DayData originalWorkout,
    required PreWorkoutCheckin checkin,
  }) {
    final modifications = <WorkoutModification>[];
    final adaptedSlots = <SlotData>[];

    for (final slot in originalWorkout.slots) {
      final adaptedConfigs = <SetConfigData>[];

      for (final config in slot.setConfigs) {
        var adapted = config;
        final exercise = config.exercise;
        final exerciseName = _exerciseName(exercise);

        // 1. Muscle-pain-based weight reduction
        final maxPain = _maxPainForExercise(exercise, checkin);
        if (maxPain >= _painHighThreshold && adapted.weight != null) {
          final reduction = maxPain >= 9 ? 0.20 : 0.10;
          final newWeight = adapted.weight! * (1 - reduction);
          modifications.add(
            WorkoutModification(
              exerciseName: exerciseName,
              field: 'weight',
              originalValue: adapted.weight!,
              adaptedValue: newWeight,
              reason:
                  '$exerciseName: dolor $maxPain/10 en '
                  '${_painfulMuscles(exercise, checkin).join(", ")} '
                  '→ reducir ${(reduction * 100).toInt()}% peso',
            ),
          );
          adapted = adapted.copyWith(weight: newWeight);
        }

        // 2. Muscle-pain-based set reduction
        if (maxPain >= _painMediumThreshold &&
            adapted.nrOfSets != null &&
            adapted.nrOfSets! > 1) {
          final newSets = adapted.nrOfSets! - 1;
          modifications.add(
            WorkoutModification(
              exerciseName: exerciseName,
              field: 'sets',
              originalValue: adapted.nrOfSets!,
              adaptedValue: newSets,
              reason:
                  '$exerciseName: dolor muscular moderado '
                  '→ quitar 1 serie',
            ),
          );
          adapted = adapted.copyWith(nrOfSets: newSets);
        }

        // 3. High fatigue → reduce sets
        if (checkin.fatigue >= _fatigueHighThreshold &&
            adapted.nrOfSets != null &&
            adapted.nrOfSets! > 1) {
          // Only apply if not already reduced by pain
          final alreadyReduced = modifications.any(
            (m) =>
                m.exerciseName == exerciseName &&
                m.field == 'sets',
          );
          if (!alreadyReduced) {
            final newSets = adapted.nrOfSets! - 1;
            modifications.add(
              WorkoutModification(
                exerciseName: exerciseName,
                field: 'sets',
                originalValue: adapted.nrOfSets!,
                adaptedValue: newSets,
                reason:
                    'Fatiga global ${checkin.fatigue}/10 '
                    '→ quitar 1 serie',
              ),
            );
            adapted = adapted.copyWith(nrOfSets: newSets);
          }
        }

        // 4. Medium fatigue → reduce weight 5%
        if (checkin.fatigue >= _fatigueMediumThreshold &&
            checkin.fatigue < _fatigueHighThreshold &&
            adapted.weight != null) {
          // Only apply if not already reduced by pain
          final alreadyReduced = modifications.any(
            (m) =>
                m.exerciseName == exerciseName &&
                m.field == 'weight',
          );
          if (!alreadyReduced) {
            final newWeight = adapted.weight! * 0.95;
            modifications.add(
              WorkoutModification(
                exerciseName: exerciseName,
                field: 'weight',
                originalValue: adapted.weight!,
                adaptedValue: newWeight,
                reason:
                    'Fatiga global ${checkin.fatigue}/10 '
                    '→ reducir 5% peso',
              ),
            );
            adapted = adapted.copyWith(weight: newWeight);
          }
        }

        adaptedConfigs.add(adapted);
      }

      adaptedSlots.add(
        SlotData(
          comment: slot.comment,
          isSuperset: slot.isSuperset,
          exerciseIds: slot.exerciseIds,
          setConfigs: adaptedConfigs,
        ),
      );
    }

    return WorkoutAdaptation(
      originalSlots: originalWorkout.slots,
      adaptedSlots: adaptedSlots,
      modifications: modifications,
      checkin: checkin,
    );
  }

  // ------------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------------

  int _maxPainForExercise(Exercise? exercise, PreWorkoutCheckin checkin) {
    if (exercise == null) {
      return 0;
    }
    var maxPain = 0;
    for (final m in [...exercise.muscles, ...exercise.musclesSecondary]) {
      final pain = checkin.painForMuscle(m.name);
      if (pain > maxPain) {
        maxPain = pain;
      }
    }
    return maxPain;
  }

  List<String> _painfulMuscles(Exercise? exercise, PreWorkoutCheckin checkin) {
    if (exercise == null) {
      return [];
    }
    final names = <String>[];
    for (final m in [...exercise.muscles, ...exercise.musclesSecondary]) {
      if (checkin.painForMuscle(m.name) > 0) {
        names.add(m.name);
      }
    }
    return names;
  }

  String _exerciseName(Exercise? exercise) {
    if (exercise == null || exercise.translations.isEmpty) {
      return 'Ejercicio';
    }
    try {
      return exercise.getTranslation('es').name;
    } catch (_) {
      try {
        return exercise.getTranslation('en').name;
      } catch (_) {
        return exercise.translations.first.name;
      }
    }
  }
}
