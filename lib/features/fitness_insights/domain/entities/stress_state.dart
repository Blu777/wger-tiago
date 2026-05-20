/// Unified stress model for workout adaptation.
///
/// All physiological stress signals (pain, fatigue, external load) are
/// normalised into a single [stressScore] in [0, 1], avoiding the
/// double-counting that occurs when independent multiplicative factors are
/// applied to the same CNS/neuromuscular readiness pool.
library;

// ---------------------------------------------------------------------------
//  Stress tiers — drive business rules, not just math
// ---------------------------------------------------------------------------

/// Qualitative tier derived from [StressState.stressScore].
/// Used to gate business rules (e.g. no weight increase above [moderate]).
enum StressTier {
  /// score < 0.25 — full performance, progression allowed.
  low,

  /// 0.25 ≤ score < 0.55 — reduced performance, maintenance or minor reduction.
  moderate,

  /// 0.55 ≤ score < 0.80 — significant impairment, volume/weight reduction required.
  high,

  /// score ≥ 0.80 — forced deload behaviour regardless of phase.
  critical,
}

// ---------------------------------------------------------------------------
//  StressState — unified readiness model
// ---------------------------------------------------------------------------

/// Unified, normalised readiness state computed from pre-workout checkin.
///
/// Design rationale
/// ────────────────
/// Pain, fatigue and external load all deplete the same finite CNS and
/// neuromuscular recovery budget.  Treating them as independent multipliers
/// (p × f × s) over-penalises the athlete because correlated signals compound
/// beyond their true physiological impact.
///
/// Instead we:
///   1. Normalise each raw signal to [0, 1].
///   2. Combine with a **weighted mean**, where weights reflect each signal's
///      *unique* contribution to readiness impairment:
///        • fatigue   — 0.40 (systemic, always present)
///        • soreness  — 0.35 (local; often overlaps with fatigue after hard sessions)
///        • externalLoad — 0.25 (situational; upcoming activity, lower weight
///                              because it is a *future* cost, not current impairment)
///   3. The resulting [stressScore] ∈ [0, 1] is the single input to both the
///      weight-factor formula and the sets-delta business rules.
class StressState {
  /// Normalised global fatigue: checkin.fatigue mapped from [1, 10] → [0, 1].
  final double fatigue;

  /// Normalised muscle soreness: max relevant-muscle pain from [0, 10] → [0, 1].
  final double soreness;

  /// Normalised external load: derived from [PlannedSportActivity] → [0, 1].
  final double externalLoad;

  const StressState({
    required this.fatigue,
    required this.soreness,
    required this.externalLoad,
  });

  // Combination weights — must sum to 1.0.
  static const _wFatigue = 0.40;
  static const _wSoreness = 0.35;
  static const _wExternal = 0.25;

  /// Unified stress score in [0, 1].
  ///
  /// Weighted mean: avoids double-counting correlated signals.
  /// Higher = more stressed = less capacity for adaptation.
  double get stressScore =>
      fatigue * _wFatigue + soreness * _wSoreness + externalLoad * _wExternal;

  /// Qualitative tier for business-rule gating.
  StressTier get tier {
    final s = stressScore;
    if (s >= 0.80) {
      return StressTier.critical;
    }
    if (s >= 0.55) {
      return StressTier.high;
    }
    if (s >= 0.25) {
      return StressTier.moderate;
    }
    return StressTier.low;
  }

  /// Weight retention factor derived from stress score.
  ///
  /// Maps stress linearly to a weight cap:
  ///   stress 0   → factor 1.00 (no reduction)
  ///   stress 0.5 → factor 0.88 (−12%)
  ///   stress 1.0 → factor 0.70 (−30%, the system-wide cap)
  ///
  /// Clipped at [_minWeightFactor] to match the ±30% system guardrail.
  double get weightRetentionFactor {
    const minFactor = 0.70;
    return (1.0 - stressScore * 0.30).clamp(minFactor, 1.0);
  }

  /// Maximum allowed sets delta given current stress.
  ///
  ///   low      → +2  (full volume increase allowed)
  ///   moderate → +0  (maintenance; no increase)
  ///   high     → −1  (volume reduction required)
  ///   critical → −2  (forced deload)
  int get maxSetsDelta {
    switch (tier) {
      case StressTier.low:
        return 2;
      case StressTier.moderate:
        return 0;
      case StressTier.high:
        return -1;
      case StressTier.critical:
        return -2;
    }
  }

  @override
  String toString() =>
      'StressState(fatigue: ${fatigue.toStringAsFixed(2)}, '
      'soreness: ${soreness.toStringAsFixed(2)}, '
      'externalLoad: ${externalLoad.toStringAsFixed(2)}, '
      'score: ${stressScore.toStringAsFixed(2)}, '
      'tier: $tier)';
}

// ---------------------------------------------------------------------------
//  Explanation system
// ---------------------------------------------------------------------------

/// Describes how a single factor contributed to the adaptation outcome.
class FactorContribution {
  /// Display name of the signal (e.g. 'Dolor muscular', 'Fatiga sistémica').
  final String label;

  /// The raw input value for this factor (e.g. pain score, stress score).
  final double inputValue;

  /// The impact this factor had on the final weight or sets (signed).
  /// For weight: expressed as a percentage change (e.g. −0.12 = −12%).
  /// For sets: expressed as integer delta.
  final double impact;

  /// Human-readable description for the UI.
  final String explanation;

  const FactorContribution({
    required this.label,
    required this.inputValue,
    required this.impact,
    required this.explanation,
  });
}

/// Full explanation of why the adaptation was computed as it was.
///
/// Designed to be surfaced directly in the UI — each [contributions] entry
/// maps to a visible line item showing the user exactly what drove the result.
class AdaptationExplanation {
  /// Ordered list of factors that contributed to the final adaptation.
  /// Only factors with non-zero impact are included.
  final List<FactorContribution> contributions;

  /// One-sentence coaching summary suitable for display at the top of the
  /// adaptation preview screen.
  final String summary;

  /// Confidence score in [0, 1] — how reliable this adaptation is given
  /// data quality and signal consistency.
  final double confidenceScore;

  /// Human-readable confidence label for the UI.
  final String confidenceLabel;

  const AdaptationExplanation({
    required this.contributions,
    required this.summary,
    required this.confidenceScore,
    required this.confidenceLabel,
  });
}
