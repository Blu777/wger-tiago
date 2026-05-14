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
import 'package:wger/features/gallery/data/api/gallery_api_service.dart';
import 'package:wger/features/gallery/domain/repositories/i_gallery_repository.dart';
import 'package:wger/models/gallery/image.dart' as gallery;

class GalleryRepository implements IGalleryRepository {
  final GalleryApiService _api;

  GalleryRepository(this._api);

  @override
  Future<List<gallery.Image>> fetchGallery() async {
    return _api.fetchGallery();
  }

  @override
  Future<gallery.Image> addImage(gallery.Image image, XFile imageFile) async {
    return _api.addImage(image, imageFile);
  }

  @override
  Future<gallery.Image> editImage(gallery.Image image, XFile? imageFile) async {
    final responseData = await _api.editImage(image, imageFile);
    image.url = responseData['image'];
    return image;
  }

  @override
  Future<void> deleteImage(int id) async {
    await _api.deleteImage(id);
  }
}
