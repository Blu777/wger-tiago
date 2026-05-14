import 'package:freezed_annotation/freezed_annotation.dart';

part 'muscle_analysis.freezed.dart';

/// Training status for a muscle group based on weekly volume.
enum MuscleTrainingStatus {
  undertraining,
  optimal,
  overtraining,
}

/// Analysis of a single muscle group's training load.
@freezed
sealed class MuscleAnalysis with _$MuscleAnalysis {
  const factory MuscleAnalysis({
    /// Muscle group name.
    required String muscleName,

    /// Total sets per week (average over analysis period).
    required num weeklySets,

    /// Training frequency per week (sessions hitting this muscle).
    required num weeklyFrequency,

    /// Total volume (weight × reps) for this muscle.
    required num totalVolume,

    /// Status based on weekly sets thresholds.
    required MuscleTrainingStatus status,
  }) = _MuscleAnalysis;
}
