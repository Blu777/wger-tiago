import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_summary.freezed.dart';

/// Human-readable coaching summary (2–3 lines) describing the current situation
/// and what to do this week.
@freezed
sealed class CoachSummary with _$CoachSummary {
  const factory CoachSummary({
    /// What is currently happening (e.g. "Fatiga creciente con progreso sostenido").
    required String situation,

    /// What to do this week (e.g. "Mantené volumen, planificá deload en 7 días").
    required String directive,

    /// Optional longer explanation or warning.
    String? note,
  }) = _CoachSummary;
}
