import 'package:freezed_annotation/freezed_annotation.dart';

part 'adherence_metrics.freezed.dart';

/// Training adherence metrics calculated from session history.
@freezed
sealed class AdherenceMetrics with _$AdherenceMetrics {
  const factory AdherenceMetrics({
    /// Average number of sessions per week over the analysis period.
    required num weeklyFrequency,

    /// Longest streak of days without a session.
    required int maxGapDays,

    /// Consistency score (0–100) based on actual vs expected sessions.
    required num consistencyScore,
  }) = _AdherenceMetrics;
}
