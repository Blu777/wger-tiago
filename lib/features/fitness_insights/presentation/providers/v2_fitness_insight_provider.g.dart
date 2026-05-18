// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v2_fitness_insight_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Clean v2 provider for [ITrainingRepository].
/// Fetches raw workout sessions from the API and maps them to
/// domain [TrainingSession] entities.

@ProviderFor(trainingRepository)
final trainingRepositoryProvider = TrainingRepositoryProvider._();

/// Clean v2 provider for [ITrainingRepository].
/// Fetches raw workout sessions from the API and maps them to
/// domain [TrainingSession] entities.

final class TrainingRepositoryProvider
    extends
        $FunctionalProvider<
          ITrainingRepository,
          ITrainingRepository,
          ITrainingRepository
        >
    with $Provider<ITrainingRepository> {
  /// Clean v2 provider for [ITrainingRepository].
  /// Fetches raw workout sessions from the API and maps them to
  /// domain [TrainingSession] entities.
  TrainingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ITrainingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ITrainingRepository create(Ref ref) {
    return trainingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITrainingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITrainingRepository>(value),
    );
  }
}

String _$trainingRepositoryHash() =>
    r'3cd4d23a98bb13eb077956338e60a17323e26b22';

/// Clean v2 pipeline that produces a [FitnessInsight].
///
/// Steps:
/// 1. Fetches [WorkoutSession] from API via [ITrainingRepository]
///    and maps them to [TrainingSession] internally.
/// 2. Fetches body-weight entries.
/// 3. Runs the [AnalyzeTrainingV2] use case with the user's goal.
/// 4. Returns [AsyncValue<FitnessInsight>].

@ProviderFor(V2FitnessInsight)
final v2FitnessInsightProvider = V2FitnessInsightProvider._();

/// Clean v2 pipeline that produces a [FitnessInsight].
///
/// Steps:
/// 1. Fetches [WorkoutSession] from API via [ITrainingRepository]
///    and maps them to [TrainingSession] internally.
/// 2. Fetches body-weight entries.
/// 3. Runs the [AnalyzeTrainingV2] use case with the user's goal.
/// 4. Returns [AsyncValue<FitnessInsight>].
final class V2FitnessInsightProvider
    extends $AsyncNotifierProvider<V2FitnessInsight, FitnessInsight> {
  /// Clean v2 pipeline that produces a [FitnessInsight].
  ///
  /// Steps:
  /// 1. Fetches [WorkoutSession] from API via [ITrainingRepository]
  ///    and maps them to [TrainingSession] internally.
  /// 2. Fetches body-weight entries.
  /// 3. Runs the [AnalyzeTrainingV2] use case with the user's goal.
  /// 4. Returns [AsyncValue<FitnessInsight>].
  V2FitnessInsightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'v2FitnessInsightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$v2FitnessInsightHash();

  @$internal
  @override
  V2FitnessInsight create() => V2FitnessInsight();
}

String _$v2FitnessInsightHash() => r'e00497aaa751745e2ec3c4a6dc4c162720f7f5a2';

/// Clean v2 pipeline that produces a [FitnessInsight].
///
/// Steps:
/// 1. Fetches [WorkoutSession] from API via [ITrainingRepository]
///    and maps them to [TrainingSession] internally.
/// 2. Fetches body-weight entries.
/// 3. Runs the [AnalyzeTrainingV2] use case with the user's goal.
/// 4. Returns [AsyncValue<FitnessInsight>].

abstract class _$V2FitnessInsight extends $AsyncNotifier<FitnessInsight> {
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
