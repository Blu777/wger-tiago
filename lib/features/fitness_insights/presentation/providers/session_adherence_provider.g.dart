// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_adherence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Async gate: resolves once the persisted adherence history has been loaded
/// into [sessionAdherenceProvider]. [FitnessCoachV2] awaits this before reading
/// the sync notifier, preventing the race condition on cold start.

@ProviderFor(sessionAdherenceReady)
final sessionAdherenceReadyProvider = SessionAdherenceReadyProvider._();

/// Async gate: resolves once the persisted adherence history has been loaded
/// into [sessionAdherenceProvider]. [FitnessCoachV2] awaits this before reading
/// the sync notifier, preventing the race condition on cold start.

final class SessionAdherenceReadyProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Async gate: resolves once the persisted adherence history has been loaded
  /// into [sessionAdherenceProvider]. [FitnessCoachV2] awaits this before reading
  /// the sync notifier, preventing the race condition on cold start.
  SessionAdherenceReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionAdherenceReadyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionAdherenceReadyHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return sessionAdherenceReady(ref);
  }
}

String _$sessionAdherenceReadyHash() =>
    r'298abd999d3f5399cdac664825ff19d25b080fb8';

/// Manages adherence tracking: computes planned-vs-executed after each session
/// and persists a rolling history for the feedback loop.

@ProviderFor(SessionAdherenceNotifier)
final sessionAdherenceProvider = SessionAdherenceNotifierProvider._();

/// Manages adherence tracking: computes planned-vs-executed after each session
/// and persists a rolling history for the feedback loop.
final class SessionAdherenceNotifierProvider
    extends
        $NotifierProvider<
          SessionAdherenceNotifier,
          List<SessionAdherenceRecord>
        > {
  /// Manages adherence tracking: computes planned-vs-executed after each session
  /// and persists a rolling history for the feedback loop.
  SessionAdherenceNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionAdherenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionAdherenceNotifierHash();

  @$internal
  @override
  SessionAdherenceNotifier create() => SessionAdherenceNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SessionAdherenceRecord> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<SessionAdherenceRecord>>(value),
    );
  }
}

String _$sessionAdherenceNotifierHash() =>
    r'160dedec00693c72b256959e4329a9f94e43ebe9';

/// Manages adherence tracking: computes planned-vs-executed after each session
/// and persists a rolling history for the feedback loop.

abstract class _$SessionAdherenceNotifier
    extends $Notifier<List<SessionAdherenceRecord>> {
  List<SessionAdherenceRecord> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<List<SessionAdherenceRecord>, List<SessionAdherenceRecord>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                List<SessionAdherenceRecord>,
                List<SessionAdherenceRecord>
              >,
              List<SessionAdherenceRecord>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
