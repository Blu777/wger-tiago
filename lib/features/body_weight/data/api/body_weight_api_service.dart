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
import 'package:wger/features/body_weight/domain/models/weight_entry.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/providers/base_provider.dart';

class BodyWeightApiService {
  final _logger = Logger('BodyWeightApiService');
  final WgerBaseProvider _base;

  BodyWeightApiService(this._base);

  static const _path = 'weightentry';

  Future<List<WeightEntry>> fetchEntries() async {
    _logger.info('Fetching all body weight entries');
    final data = await _base.fetchPaginated(
      _base.makeUrl(
        _path,
        query: {'ordering': '-date', 'limit': API_MAX_PAGE_SIZE},
      ),
    );
    return data.map((e) => WeightEntry.fromJson(e)).toList();
  }

  Future<WeightEntry> addEntry(WeightEntry entry) async {
    final data = await _base.post(entry.toJson(), _base.makeUrl(_path));
    return WeightEntry.fromJson(data);
  }

  Future<void> editEntry(WeightEntry entry) async {
    await _base.patch(
      entry.toJson(),
      _base.makeUrl(_path, id: entry.id),
    );
  }

  Future<void> deleteEntry(int id) async {
    await _base.deleteRequest(_path, id);
  }
}
