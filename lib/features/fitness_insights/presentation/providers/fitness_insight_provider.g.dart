// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fitness_insight_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Repository provider — clean, swappable, no legacy Provider dependency.

@ProviderFor(trainingRepository)
final trainingRepositoryProvider = TrainingRepositoryProvider._();

/// Repository provider — clean, swappable, no legacy Provider dependency.

final class TrainingRepositoryProvider
    extends
        $FunctionalProvider<
          TrainingRepositoryImpl,
          TrainingRepositoryImpl,
          TrainingRepositoryImpl
        >
    with $Provider<TrainingRepositoryImpl> {
  /// Repository provider — clean, swappable, no legacy Provider dependency.
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
  $ProviderElement<TrainingRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TrainingRepositoryImpl create(Ref ref) {
    return trainingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrainingRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrainingRepositoryImpl>(value),
    );
  }
}

String _$trainingRepositoryHash() =>
    r'ba3ea9d224832cef5133f37b3782c1583437c81b';

/// Fetches domain-level [TrainingSession] entities from the API.

@ProviderFor(trainingSessions)
final trainingSessionsProvider = TrainingSessionsProvider._();

/// Fetches domain-level [TrainingSession] entities from the API.

final class TrainingSessionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TrainingSession>>,
          List<TrainingSession>,
          FutureOr<List<TrainingSession>>
        >
    with
        $FutureModifier<List<TrainingSession>>,
        $FutureProvider<List<TrainingSession>> {
  /// Fetches domain-level [TrainingSession] entities from the API.
  TrainingSessionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainingSessionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainingSessionsHash();

  @$internal
  @override
  $FutureProviderElement<List<TrainingSession>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TrainingSession>> create(Ref ref) {
    return trainingSessions(ref);
  }
}

String _$trainingSessionsHash() => r'a5dfb59b329db800f815528a6a226eeeba020a2a';

/// Stub provider for subjective feedback.
/// Returns an empty list until a real data source is wired in.

@ProviderFor(subjectiveFeedback)
final subjectiveFeedbackProvider = SubjectiveFeedbackProvider._();

/// Stub provider for subjective feedback.
/// Returns an empty list until a real data source is wired in.

final class SubjectiveFeedbackProvider
    extends
        $FunctionalProvider<
          List<SubjectiveFeedback>,
          List<SubjectiveFeedback>,
          List<SubjectiveFeedback>
        >
    with $Provider<List<SubjectiveFeedback>> {
  /// Stub provider for subjective feedback.
  /// Returns an empty list until a real data source is wired in.
  SubjectiveFeedbackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subjectiveFeedbackProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subjectiveFeedbackHash();

  @$internal
  @override
  $ProviderElement<List<SubjectiveFeedback>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<SubjectiveFeedback> create(Ref ref) {
    return subjectiveFeedback(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SubjectiveFeedback> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SubjectiveFeedback>>(value),
    );
  }
}

String _$subjectiveFeedbackHash() =>
    r'5cc831e1aadd9b89d73e9a0386f67a4345c52ee7';

/// Central insight provider that aggregates weight, training and feedback
/// data, runs the pure [AnalyzeTraining] use case, and exposes the result.

@ProviderFor(fitnessInsight)
final fitnessInsightProvider = FitnessInsightProvider._();

/// Central insight provider that aggregates weight, training and feedback
/// data, runs the pure [AnalyzeTraining] use case, and exposes the result.

final class FitnessInsightProvider
    extends
        $FunctionalProvider<
          AsyncValue<FitnessInsight>,
          FitnessInsight,
          FutureOr<FitnessInsight>
        >
    with $FutureModifier<FitnessInsight>, $FutureProvider<FitnessInsight> {
  /// Central insight provider that aggregates weight, training and feedback
  /// data, runs the pure [AnalyzeTraining] use case, and exposes the result.
  FitnessInsightProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fitnessInsightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fitnessInsightHash();

  @$internal
  @override
  $FutureProviderElement<FitnessInsight> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FitnessInsight> create(Ref ref) {
    return fitnessInsight(ref);
  }
}

String _$fitnessInsightHash() => r'ed2eeb3e80dde2d8f83fd6a162af8a54be91fa55';
