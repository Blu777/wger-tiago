// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(measurementRepository)
final measurementRepositoryProvider = MeasurementRepositoryProvider._();

final class MeasurementRepositoryProvider
    extends
        $FunctionalProvider<
          IMeasurementRepository,
          IMeasurementRepository,
          IMeasurementRepository
        >
    with $Provider<IMeasurementRepository> {
  MeasurementRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'measurementRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$measurementRepositoryHash();

  @$internal
  @override
  $ProviderElement<IMeasurementRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IMeasurementRepository create(Ref ref) {
    return measurementRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IMeasurementRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IMeasurementRepository>(value),
    );
  }
}

String _$measurementRepositoryHash() =>
    r'7594262c77073a41d4d7a2c2e929df9f065fd693';

@ProviderFor(MeasurementNotifier)
final measurementProvider = MeasurementNotifierProvider._();

final class MeasurementNotifierProvider
    extends
        $AsyncNotifierProvider<MeasurementNotifier, List<MeasurementCategory>> {
  MeasurementNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'measurementProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$measurementNotifierHash();

  @$internal
  @override
  MeasurementNotifier create() => MeasurementNotifier();
}

String _$measurementNotifierHash() =>
    r'378d05f42f7d54e4150ae1629d1c8b9836e85452';

abstract class _$MeasurementNotifier
    extends $AsyncNotifier<List<MeasurementCategory>> {
  FutureOr<List<MeasurementCategory>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<MeasurementCategory>>,
              List<MeasurementCategory>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<MeasurementCategory>>,
                List<MeasurementCategory>
              >,
              AsyncValue<List<MeasurementCategory>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
