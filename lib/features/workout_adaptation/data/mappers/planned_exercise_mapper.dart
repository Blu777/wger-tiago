import 'package:wger/features/workout_adaptation/domain/entities/planned_exercise.dart';
import 'package:wger/features/workout_adaptation/domain/entities/planned_set.dart';
import 'package:wger/models/workouts/day_data.dart';
import 'package:wger/models/workouts/set_config_data.dart';

/// Maps wger's [DayData] into a flat list of domain [PlannedExercise] entities.
class PlannedExerciseMapper {
  List<PlannedExercise> fromDayData(DayData dayData) {
    final result = <PlannedExercise>[];
    for (final slot in dayData.slots) {
      for (final config in slot.setConfigs) {
        result.add(_mapConfig(config));
      }
    }
    return result;
  }

  /// Maps a raw list of [SetConfigData] (e.g. from a Slot) into domain entities.
  List<PlannedExercise> fromSetConfigs(List<SetConfigData> configs) {
    return configs.map(_mapConfig).toList();
  }

  PlannedExercise _mapConfig(SetConfigData config) {
    final exercise = config.exercise;
    final exerciseName = exercise.translations.firstOrNull?.name ?? 'Unknown';

    final muscleNames = <String>[
      ...exercise.muscles.map((m) => m.name),
      ...exercise.musclesSecondary.map((m) => m.name),
    ];

    return PlannedExercise(
      exerciseId: exercise.id ?? config.exerciseId,
      exerciseName: exerciseName,
      muscleNames: muscleNames.toSet().toList(),
      plannedSets: [
        PlannedSet(
          weight: config.weight ?? 0,
          repetitions: config.repetitions ?? 0,
          sets: config.nrOfSets ?? 1,
        ),
      ],
    );
  }
}
