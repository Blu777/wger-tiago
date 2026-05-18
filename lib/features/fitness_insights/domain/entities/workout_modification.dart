/// A single modification made to a set configuration.
class WorkoutModification {
  final String exerciseName;
  final String field;
  final num originalValue;
  final num adaptedValue;
  final String reason;

  const WorkoutModification({
    required this.exerciseName,
    required this.field,
    required this.originalValue,
    required this.adaptedValue,
    required this.reason,
  });
}
