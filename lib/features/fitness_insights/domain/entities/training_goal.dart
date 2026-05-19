/// User training goal that influences how the coaching system
/// evaluates progress, status, and recommendations.
enum TrainingGoal {
  /// Focus: progressive overload, e1RM improvements.
  strength,

  /// Focus: volume accumulation, muscle stimulus.
  hypertrophy,

  /// Focus: caloric deficit adherence, muscle preservation.
  fatLoss,

  /// Focus: consistency, avoiding regression.
  maintenance,
}
