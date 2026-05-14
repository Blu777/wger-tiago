/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
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

import 'package:logging/logging.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/measurements/measurement_category.dart';
import 'package:wger/models/measurements/measurement_entry.dart';
import 'package:wger/providers/base_provider.dart';

class MeasurementApiService {
  final _logger = Logger('MeasurementApiService');
  final WgerBaseProvider _base;

  MeasurementApiService(this._base);

  static const _categoryUrl = 'measurement-category';
  static const _entryUrl = 'measurement';

  Future<List<MeasurementCategory>> fetchCategories() async {
    _logger.info('Fetching all measurement categories');
    final data = await _base.fetchPaginated(
      _base.makeUrl(
        _categoryUrl,
        query: {'limit': API_MAX_PAGE_SIZE},
      ),
    );
    return data.map((e) => MeasurementCategory.fromJson(e)).toList();
  }

  Future<List<MeasurementEntry>> fetchEntries(int categoryId) async {
    _logger.info('Fetching measurement entries for category $categoryId');
    final data = await _base.fetchPaginated(
      _base.makeUrl(
        _entryUrl,
        query: {'category': categoryId.toString(), 'limit': API_MAX_PAGE_SIZE},
      ),
    );
    return data.map((e) => MeasurementEntry.fromJson(e)).toList();
  }

  Future<MeasurementCategory> addCategory(MeasurementCategory category) async {
    final data = await _base.post(category.toJson(), _base.makeUrl(_categoryUrl));
    return MeasurementCategory.fromJson(data);
  }

  Future<void> deleteCategory(int id) async {
    await _base.deleteRequest(_categoryUrl, id);
  }

  Future<MeasurementCategory> editCategory(MeasurementCategory category) async {
    final data = await _base.patch(
      category.toJson(),
      _base.makeUrl(_categoryUrl, id: category.id),
    );
    return MeasurementCategory.fromJson(data);
  }

  Future<MeasurementEntry> addEntry(MeasurementEntry entry) async {
    final data = await _base.post(entry.toJson(), _base.makeUrl(_entryUrl));
    return MeasurementEntry.fromJson(data);
  }

  Future<void> deleteEntry(int id) async {
    await _base.deleteRequest(_entryUrl, id);
  }

  Future<MeasurementEntry> editEntry(MeasurementEntry entry) async {
    final data = await _base.patch(
      entry.toJson(),
      _base.makeUrl(_entryUrl, id: entry.id),
    );
    return MeasurementEntry.fromJson(data);
  }
}
