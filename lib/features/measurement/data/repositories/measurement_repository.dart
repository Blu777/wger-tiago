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

import 'package:wger/features/measurement/data/api/measurement_api_service.dart';
import 'package:wger/features/measurement/domain/repositories/i_measurement_repository.dart';
import 'package:wger/models/measurements/measurement_category.dart';
import 'package:wger/models/measurements/measurement_entry.dart';

class MeasurementRepository implements IMeasurementRepository {
  final MeasurementApiService _api;

  MeasurementRepository(this._api);

  @override
  Future<List<MeasurementCategory>> fetchCategories() async {
    return _api.fetchCategories();
  }

  @override
  Future<List<MeasurementEntry>> fetchEntries(int categoryId) async {
    return _api.fetchEntries(categoryId);
  }

  @override
  Future<MeasurementCategory> addCategory(MeasurementCategory category) async {
    final result = await _api.addCategory(category);
    return result;
  }

  @override
  Future<void> deleteCategory(int id) async {
    await _api.deleteCategory(id);
  }

  @override
  Future<MeasurementCategory> editCategory(MeasurementCategory category) async {
    final result = await _api.editCategory(category);
    return result;
  }

  @override
  Future<MeasurementEntry> addEntry(MeasurementEntry entry) async {
    final result = await _api.addEntry(entry);
    return result;
  }

  @override
  Future<void> deleteEntry(int id) async {
    await _api.deleteEntry(id);
  }

  @override
  Future<MeasurementEntry> editEntry(MeasurementEntry entry) async {
    final result = await _api.editEntry(entry);
    return result;
  }
}
