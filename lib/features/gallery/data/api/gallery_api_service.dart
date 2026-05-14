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

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/helpers/json.dart';
import 'package:wger/models/gallery/image.dart' as gallery;
import 'package:wger/providers/base_provider.dart';

class GalleryApiService {
  final _logger = Logger('GalleryApiService');
  final WgerBaseProvider _base;

  GalleryApiService(this._base);

  static const _galleryUrlPath = 'gallery';

  Future<List<gallery.Image>> fetchGallery() async {
    _logger.info('Fetching gallery images');
    final data = await _base.fetchPaginated(
      _base.makeUrl(
        _galleryUrlPath,
        query: {'limit': API_MAX_PAGE_SIZE},
      ),
    );
    return data.map((e) => gallery.Image.fromJson(e)).toList();
  }

  Future<gallery.Image> addImage(gallery.Image image, XFile imageFile) async {
    final request = http.MultipartRequest('POST', _base.makeUrl(_galleryUrlPath));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token ${_base.auth.token}',
      HttpHeaders.userAgentHeader: _base.auth.getAppNameHeader(),
    });
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    request.fields['date'] = dateToYYYYMMDD(image.date) ?? '';
    request.fields['description'] = image.description;

    final res = await request.send();
    final respStr = await res.stream.bytesToString();
    return gallery.Image.fromJson(json.decode(respStr));
  }

  Future<Map<String, dynamic>> editImage(gallery.Image image, XFile? imageFile) async {
    final request = http.MultipartRequest(
      'PATCH',
      _base.makeUrl(_galleryUrlPath, id: image.id),
    );
    request.headers.addAll({
      HttpHeaders.authorizationHeader: 'Token ${_base.auth.token}',
      HttpHeaders.userAgentHeader: _base.auth.getAppNameHeader(),
    });

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final data = image.toJson();
    request.fields['id'] = data['id'].toString();
    request.fields['date'] = data['date'];
    request.fields['description'] = data['description'];

    final res = await request.send();
    final respStr = await res.stream.bytesToString();
    return json.decode(respStr);
  }

  Future<void> deleteImage(int id) async {
    await _base.deleteRequest(_galleryUrlPath, id);
  }
}
