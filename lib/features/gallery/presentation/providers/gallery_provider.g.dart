// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(galleryRepository)
final galleryRepositoryProvider = GalleryRepositoryProvider._();

final class GalleryRepositoryProvider
    extends
        $FunctionalProvider<
          IGalleryRepository,
          IGalleryRepository,
          IGalleryRepository
        >
    with $Provider<IGalleryRepository> {
  GalleryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'galleryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$galleryRepositoryHash();

  @$internal
  @override
  $ProviderElement<IGalleryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  IGalleryRepository create(Ref ref) {
    return galleryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IGalleryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IGalleryRepository>(value),
    );
  }
}

String _$galleryRepositoryHash() => r'f927f4269c8006b73d36d5e697ab7235373c9454';

@ProviderFor(GalleryNotifier)
final galleryProvider = GalleryNotifierProvider._();

final class GalleryNotifierProvider
    extends $AsyncNotifierProvider<GalleryNotifier, List<gallery.Image>> {
  GalleryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'galleryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$galleryNotifierHash();

  @$internal
  @override
  GalleryNotifier create() => GalleryNotifier();
}

String _$galleryNotifierHash() => r'0a12575116be5cbd8d4131dde6140e156c101517';

abstract class _$GalleryNotifier extends $AsyncNotifier<List<gallery.Image>> {
  FutureOr<List<gallery.Image>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<gallery.Image>>, List<gallery.Image>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<gallery.Image>>, List<gallery.Image>>,
              AsyncValue<List<gallery.Image>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
