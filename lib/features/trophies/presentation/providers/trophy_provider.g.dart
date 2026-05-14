// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trophy_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(trophyRepository)
final trophyRepositoryProvider = TrophyRepositoryProvider._();

final class TrophyRepositoryProvider
    extends
        $FunctionalProvider<
          ITrophyRepository,
          ITrophyRepository,
          ITrophyRepository
        >
    with $Provider<ITrophyRepository> {
  TrophyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trophyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trophyRepositoryHash();

  @$internal
  @override
  $ProviderElement<ITrophyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ITrophyRepository create(Ref ref) {
    return trophyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ITrophyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ITrophyRepository>(value),
    );
  }
}

String _$trophyRepositoryHash() => r'dcbe9352c0fbb1db60efedfe24a7540880dd92a9';

@ProviderFor(TrophyNotifier)
final trophyProvider = TrophyNotifierProvider._();

final class TrophyNotifierProvider
    extends $AsyncNotifierProvider<TrophyNotifier, TrophyState> {
  TrophyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trophyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trophyNotifierHash();

  @$internal
  @override
  TrophyNotifier create() => TrophyNotifier();
}

String _$trophyNotifierHash() => r'e686c25b4c76708ab5866bee0e4468cbb8d13fbe';

abstract class _$TrophyNotifier extends $AsyncNotifier<TrophyState> {
  FutureOr<TrophyState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TrophyState>, TrophyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TrophyState>, TrophyState>,
              AsyncValue<TrophyState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
