// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_riverpod.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
        isAutoDispose: false,
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
    r'4b22548867e09e4aca2c3dd29387c4f4a9291531';

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
