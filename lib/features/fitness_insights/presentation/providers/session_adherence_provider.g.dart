// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_adherence_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
    r'c9337e0ae414d0cdddeeba22e7833240494efb55';

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
