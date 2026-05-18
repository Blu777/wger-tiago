import 'package:wger/features/fitness_insights/domain/entities/pre_workout_checkin.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_modification.dart';
import 'package:wger/models/workouts/slot_data.dart';

/// Result of adapting a planned workout based on a pre-workout checkin.
class WorkoutAdaptation {
  final List<SlotData> originalSlots;
  final List<SlotData> adaptedSlots;
  final List<WorkoutModification> modifications;
  final PreWorkoutCheckin checkin;

  const WorkoutAdaptation({
    this.originalSlots = const [],
    this.adaptedSlots = const [],
    this.modifications = const [],
    this.checkin = const PreWorkoutCheckin(),
  });

  bool get hasModifications => modifications.isNotEmpty;
}
