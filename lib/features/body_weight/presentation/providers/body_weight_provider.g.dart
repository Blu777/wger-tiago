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
          IBodyWeightRepository,
          IBodyWeightRepository,
          IBodyWeightRepository
        >
    with $Provider<IBodyWeightRepository> {
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
  $ProviderElement<IBodyWeightRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IBodyWeightRepository create(Ref ref) {
    return bodyWeightRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IBodyWeightRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IBodyWeightRepository>(value),
    );
  }
}

String _$bodyWeightRepositoryHash() =>
    r'b73f4aa51bc8fa690fd24167ef4487211e74feaf';

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
    r'0b479d718c94d2e7fc6941bc57554ffd3cf6b88c';

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
