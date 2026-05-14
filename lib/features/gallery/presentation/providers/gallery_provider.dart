/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (c) 2020 - 2026 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wger/features/gallery/data/api/gallery_api_service.dart';
import 'package:wger/features/gallery/data/repositories/gallery_repository.dart';
import 'package:wger/features/gallery/domain/repositories/i_gallery_repository.dart';
import 'package:wger/models/gallery/image.dart' as gallery;
import 'package:wger/providers/wger_base_riverpod.dart';

part 'gallery_provider.g.dart';

@riverpod
IGalleryRepository galleryRepository(Ref ref) {
  final base = ref.watch(wgerBaseProvider);
  final api = GalleryApiService(base);
  return GalleryRepository(api);
}

@riverpod
class GalleryNotifier extends _$GalleryNotifier {
  @override
  Future<List<gallery.Image>> build() async {
    return ref.watch(galleryRepositoryProvider).fetchGallery();
  }

  Future<void> refresh() async {
    final result = await AsyncValue.guard(
      () => ref.read(galleryRepositoryProvider).fetchGallery(),
    );
    if (!ref.mounted) {
      return;
    }
    state = result;
  }

  Future<void> addImage(gallery.Image image, XFile imageFile) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(
      [...previous, image]..sort((a, b) => b.date.compareTo(a.date)),
    );

    try {
      final newImage = await ref.read(galleryRepositoryProvider).addImage(image, imageFile);
      if (!ref.mounted) {
        return;
      }
      final current = state.asData?.value ?? [];
      state = AsyncValue.data(
        [
          ...current.where(
            (e) => image.id == null ? e.id != null : e.id != image.id,
          ),
          newImage,
        ]..sort((a, b) => b.date.compareTo(a.date)),
      );
    } catch (err, stackTrace) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous);
      state = AsyncError(err, stackTrace);
      Error.throwWithStackTrace(err, stackTrace);
    }
  }

  Future<void> editImage(gallery.Image image, XFile? imageFile) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(
      previous.map((e) => e.id == image.id ? image : e).toList(),
    );

    try {
      await ref.read(galleryRepositoryProvider).editImage(image, imageFile);
      if (!ref.mounted) {
        return;
      }
    } catch (err, stackTrace) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous);
      state = AsyncError(err, stackTrace);
      Error.throwWithStackTrace(err, stackTrace);
    }
  }

  Future<void> deleteImage(int id) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(previous.where((e) => e.id != id).toList());

    try {
      await ref.read(galleryRepositoryProvider).deleteImage(id);
      if (!ref.mounted) {
        return;
      }
    } catch (err, stackTrace) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous);
      state = AsyncError(err, stackTrace);
      Error.throwWithStackTrace(err, stackTrace);
    }
  }

  void clear() => state = const AsyncValue.data([]);
}
