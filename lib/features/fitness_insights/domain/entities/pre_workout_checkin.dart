/// Type of sport/physical activity planned for later today.
enum PlannedSportActivity {
  none,
  lightActivity,   // walk, yoga, etc.
  moderateMatch,   // casual game, recreational sport
  competitiveMatch, // competitive game/match, tournament
  intensiveTraining, // second training session, intense practice
}

extension PlannedSportActivityExtension on PlannedSportActivity {
  String get label {
    switch (this) {
      case PlannedSportActivity.none:
        return 'Ninguna';
      case PlannedSportActivity.lightActivity:
        return 'Actividad leve (caminata, yoga)';
      case PlannedSportActivity.moderateMatch:
        return 'Partido/juego recreativo';
      case PlannedSportActivity.competitiveMatch:
        return 'Partido competitivo / torneo';
      case PlannedSportActivity.intensiveTraining:
        return 'Entrenamiento intenso (doble sesión)';
    }
  }

  /// Volume reduction factor (0.0 = no reduction, 0.4 = 40% reduction)
  double get volumeReductionFactor {
    switch (this) {
      case PlannedSportActivity.none:
        return 0.0;
      case PlannedSportActivity.lightActivity:
        return 0.10;
      case PlannedSportActivity.moderateMatch:
        return 0.25;
      case PlannedSportActivity.competitiveMatch:
        return 0.40;
      case PlannedSportActivity.intensiveTraining:
        return 0.35;
    }
  }

  /// Weight reduction factor (0.0 = no reduction, 0.15 = 15% reduction)
  double get weightReductionFactor {
    switch (this) {
      case PlannedSportActivity.none:
        return 0.0;
      case PlannedSportActivity.lightActivity:
        return 0.0;
      case PlannedSportActivity.moderateMatch:
        return 0.10;
      case PlannedSportActivity.competitiveMatch:
        return 0.15;
      case PlannedSportActivity.intensiveTraining:
        return 0.10;
    }
  }
}

/// User-reported condition before starting a workout.
///
/// - [musclePain]: map of muscle name → pain level (0–10)
/// - [fatigue]: global fatigue (1–10)
/// - [plannedSportActivity]: sport/activity planned for later today
class PreWorkoutCheckin {
  final Map<String, int> musclePain;
  final int fatigue;
  final PlannedSportActivity plannedSportActivity;

  const PreWorkoutCheckin({
    this.musclePain = const {},
    this.fatigue = 5,
    this.plannedSportActivity = PlannedSportActivity.none,
  });

  PreWorkoutCheckin copyWith({
    Map<String, int>? musclePain,
    int? fatigue,
    PlannedSportActivity? plannedSportActivity,
  }) {
    return PreWorkoutCheckin(
      musclePain: musclePain ?? this.musclePain,
      fatigue: fatigue ?? this.fatigue,
      plannedSportActivity: plannedSportActivity ?? this.plannedSportActivity,
    );
  }

  int painForMuscle(String muscleName) => musclePain[muscleName] ?? 0;
}
