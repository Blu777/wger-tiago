// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adapted_workout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages pre-workout checkin state and produces a [WorkoutAdaptation].
///
/// Usage:
/// 1. Call [setOriginalWorkout] with the planned [DayData].
/// 2. Call [updateCheckin] as the user adjusts pain/fatigue sliders.
/// 3. Watch [adaptedWorkoutProvider] for real-time [WorkoutAdaptation].

@ProviderFor(AdaptedWorkout)
final adaptedWorkoutProvider = AdaptedWorkoutProvider._();

/// Manages pre-workout checkin state and produces a [WorkoutAdaptation].
///
/// Usage:
/// 1. Call [setOriginalWorkout] with the planned [DayData].
/// 2. Call [updateCheckin] as the user adjusts pain/fatigue sliders.
/// 3. Watch [adaptedWorkoutProvider] for real-time [WorkoutAdaptation].
final class AdaptedWorkoutProvider
    extends $AsyncNotifierProvider<AdaptedWorkout, WorkoutAdaptation> {
  /// Manages pre-workout checkin state and produces a [WorkoutAdaptation].
  ///
  /// Usage:
  /// 1. Call [setOriginalWorkout] with the planned [DayData].
  /// 2. Call [updateCheckin] as the user adjusts pain/fatigue sliders.
  /// 3. Watch [adaptedWorkoutProvider] for real-time [WorkoutAdaptation].
  AdaptedWorkoutProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adaptedWorkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adaptedWorkoutHash();

  @$internal
  @override
  AdaptedWorkout create() => AdaptedWorkout();
}

String _$adaptedWorkoutHash() => r'0ba630cda905e9d08092eafbd1244a6c91e57b6c';

/// Manages pre-workout checkin state and produces a [WorkoutAdaptation].
///
/// Usage:
/// 1. Call [setOriginalWorkout] with the planned [DayData].
/// 2. Call [updateCheckin] as the user adjusts pain/fatigue sliders.
/// 3. Watch [adaptedWorkoutProvider] for real-time [WorkoutAdaptation].

abstract class _$AdaptedWorkout extends $AsyncNotifier<WorkoutAdaptation> {
  FutureOr<WorkoutAdaptation> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<WorkoutAdaptation>, WorkoutAdaptation>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WorkoutAdaptation>, WorkoutAdaptation>,
              AsyncValue<WorkoutAdaptation>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
