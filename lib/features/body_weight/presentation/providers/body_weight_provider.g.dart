// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'body_weight_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bodyWeightRepository)
final bodyWeightRepositoryProvider = BodyWeightRepositoryProvider._();

final class BodyWeightRepositoryProvider
    extends
        $FunctionalProvider<
          BodyWeightRepository,
          BodyWeightRepository,
          BodyWeightRepository
        >
    with $Provider<BodyWeightRepository> {
  BodyWeightRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyWeightRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyWeightRepositoryHash();

  @$internal
  @override
  $ProviderElement<BodyWeightRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BodyWeightRepository create(Ref ref) {
    return bodyWeightRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BodyWeightRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BodyWeightRepository>(value),
    );
  }
}

String _$bodyWeightRepositoryHash() =>
    r'a04f4442350da1441d71c2a6b09375c7278e9e4f';

@ProviderFor(BodyWeightNotifier)
final bodyWeightProvider = BodyWeightNotifierProvider._();

final class BodyWeightNotifierProvider
    extends $AsyncNotifierProvider<BodyWeightNotifier, List<WeightEntry>> {
  BodyWeightNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bodyWeightProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bodyWeightNotifierHash();

  @$internal
  @override
  BodyWeightNotifier create() => BodyWeightNotifier();
}

String _$bodyWeightNotifierHash() =>
    r'63a57827feb0e2b8753a753ce62df820da6cd1d3';

abstract class _$BodyWeightNotifier extends $AsyncNotifier<List<WeightEntry>> {
  FutureOr<List<WeightEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<WeightEntry>>, List<WeightEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WeightEntry>>, List<WeightEntry>>,
              AsyncValue<List<WeightEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
