/// User-reported condition before starting a workout.
///
/// - [musclePain]: map of muscle name → pain level (0–10)
/// - [fatigue]: global fatigue (1–10)
class PreWorkoutCheckin {
  final Map<String, int> musclePain;
  final int fatigue;

  const PreWorkoutCheckin({
    this.musclePain = const {},
    this.fatigue = 5,
  });

  PreWorkoutCheckin copyWith({
    Map<String, int>? musclePain,
    int? fatigue,
  }) {
    return PreWorkoutCheckin(
      musclePain: musclePain ?? this.musclePain,
      fatigue: fatigue ?? this.fatigue,
    );
  }

  int painForMuscle(String muscleName) => musclePain[muscleName] ?? 0;
}
