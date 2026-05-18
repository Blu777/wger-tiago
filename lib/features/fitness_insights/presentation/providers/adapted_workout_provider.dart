import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/pre_workout_checkin.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_adaptation.dart';
import 'package:wger/features/fitness_insights/domain/usecases/adapt_workout_v2.dart';
import 'package:wger/features/fitness_insights/presentation/providers/fitness_coach_v2_provider.dart';
import 'package:wger/models/workouts/day_data.dart';

part 'adapted_workout_provider.g.dart';

/// Manages pre-workout checkin state and produces a [WorkoutAdaptation].
///
/// Usage:
/// 1. Call [setOriginalWorkout] with the planned [DayData].
/// 2. Call [updateCheckin] as the user adjusts pain/fatigue sliders.
/// 3. Watch [adaptedWorkoutProvider] for real-time [WorkoutAdaptation].
@riverpod
class AdaptedWorkout extends _$AdaptedWorkout {
  DayData? _originalWorkout;
  PreWorkoutCheckin _checkin = const PreWorkoutCheckin();

  @override
  Future<WorkoutAdaptation> build() async {
    if (_originalWorkout == null) {
      return const WorkoutAdaptation();
    }
    return _compute();
  }

  /// Sets the planned workout to be adapted.
  void setOriginalWorkout(DayData dayData) {
    _originalWorkout = dayData;
    state = AsyncValue.data(_compute());
  }

  /// Updates the user's pre-workout checkin and recomputes adaptation.
  void updateCheckin(PreWorkoutCheckin checkin) {
    _checkin = checkin;
    if (_originalWorkout != null) {
      state = AsyncValue.data(_compute());
    }
  }

  WorkoutAdaptation _compute() {
    // Try to get the latest FitnessInsight from the V2 coach.
    // If unavailable (loading/error), fall back to null (V1-like rules only).
    FitnessInsight? insight;
    final coachState = ref.read(fitnessCoachV2Provider);
    coachState.whenData((data) => insight = data);

    final adapt = AdaptWorkoutV2();
    return adapt(
      originalWorkout: _originalWorkout!,
      checkin: _checkin,
      insight: insight,
    );
  }
}
