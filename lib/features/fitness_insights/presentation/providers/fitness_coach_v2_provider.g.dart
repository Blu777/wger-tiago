// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_coach_v2_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the user's selected [TrainingGoal], persisted via SharedPreferences.

@ProviderFor(TrainingGoalNotifier)
final trainingGoalProvider = TrainingGoalNotifierProvider._();

/// Manages the user's selected [TrainingGoal], persisted via SharedPreferences.
final class TrainingGoalNotifierProvider
    extends $NotifierProvider<TrainingGoalNotifier, TrainingGoal> {
  /// Manages the user's selected [TrainingGoal], persisted via SharedPreferences.
  TrainingGoalNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainingGoalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainingGoalNotifierHash();

  @$internal
  @override
  TrainingGoalNotifier create() => TrainingGoalNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrainingGoal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrainingGoal>(value),
    );
  }
}

String _$trainingGoalNotifierHash() =>
    r'6c5abf55933dcbb3234dfd93880ac1b05e0f6a42';

/// Manages the user's selected [TrainingGoal], persisted via SharedPreferences.

abstract class _$TrainingGoalNotifier extends $Notifier<TrainingGoal> {
  TrainingGoal build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TrainingGoal, TrainingGoal>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrainingGoal, TrainingGoal>,
              TrainingGoal,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(trainingRepositoryV2)
final trainingRepositoryV2Provider = TrainingRepositoryV2Provider._();

final class TrainingRepositoryV2Provider
    extends
        $FunctionalProvider<
          ITrainingRepository,
          ITrainingRepository,
          ITrainingRepository
        >
    with $Provider<ITrainingRepository> {
  TrainingRepositoryV2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainingRepositoryV2Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainingRepositoryV2Hash();

  @$internal
  @override
  $ProviderElement<ITrainingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ITrainingRepository create(Ref ref) {
    return trainingRepositoryV2(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITrainingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITrainingRepository>(value),
    );
  }
}

String _$trainingRepositoryV2Hash() =>
    r'712c1ad3174ebef68741b594c78c9fd7b86ab062';

/// V2 coaching pipeline that:
/// 1. Fetches sessions + body-weight from API.
/// 2. Runs [AnalyzeTrainingV2] with the user's [TrainingGoal].
/// 3. Caches the result locally for fast app-start.

@ProviderFor(FitnessCoachV2)
final fitnessCoachV2Provider = FitnessCoachV2Provider._();

/// V2 coaching pipeline that:
/// 1. Fetches sessions + body-weight from API.
/// 2. Runs [AnalyzeTrainingV2] with the user's [TrainingGoal].
/// 3. Caches the result locally for fast app-start.
final class FitnessCoachV2Provider
    extends $AsyncNotifierProvider<FitnessCoachV2, FitnessInsight> {
  /// V2 coaching pipeline that:
  /// 1. Fetches sessions + body-weight from API.
  /// 2. Runs [AnalyzeTrainingV2] with the user's [TrainingGoal].
  /// 3. Caches the result locally for fast app-start.
  FitnessCoachV2Provider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fitnessCoachV2Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fitnessCoachV2Hash();

  @$internal
  @override
  FitnessCoachV2 create() => FitnessCoachV2();
}

String _$fitnessCoachV2Hash() => r'0ac71b01c5865b036f6ecf1a6798bf9b96f446ee';

/// V2 coaching pipeline that:
/// 1. Fetches sessions + body-weight from API.
/// 2. Runs [AnalyzeTrainingV2] with the user's [TrainingGoal].
/// 3. Caches the result locally for fast app-start.

abstract class _$FitnessCoachV2 extends $AsyncNotifier<FitnessInsight> {
  FutureOr<FitnessInsight> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<FitnessInsight>, FitnessInsight>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<FitnessInsight>, FitnessInsight>,
              AsyncValue<FitnessInsight>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
