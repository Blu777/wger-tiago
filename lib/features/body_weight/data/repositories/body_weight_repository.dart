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

import 'package:wger/features/body_weight/data/api/body_weight_api_service.dart';
import 'package:wger/features/body_weight/domain/models/weight_entry.dart';

class BodyWeightRepository {
  final BodyWeightApiService _api;

  BodyWeightRepository(this._api);

  Future<List<WeightEntry>> fetchEntries() async {
    return _api.fetchEntries();
  }

  Future<WeightEntry> addEntry(WeightEntry entry) async {
    final result = await _api.addEntry(entry);
    return result;
  }

  Future<void> editEntry(WeightEntry entry) async {
    await _api.editEntry(entry);
  }

  Future<void> deleteEntry(int id) async {
    await _api.deleteEntry(id);
  }
}
