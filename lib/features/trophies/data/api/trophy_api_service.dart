/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (c)  2026 wger Team
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
import 'package:wger/models/trophies/trophy.dart';
import 'package:wger/models/trophies/user_trophy.dart';
import 'package:wger/models/trophies/user_trophy_progression.dart';
import 'package:wger/providers/base_provider.dart';

class TrophyApiService {
  final _logger = Logger('TrophyApiService');
  final WgerBaseProvider _base;

  TrophyApiService(this._base);

  static const _trophyUrl = 'trophy';
  static const _userTrophyUrl = 'user-trophy';
  static const _progressionUrl = 'trophy/progress';

  Future<List<Trophy>> fetchTrophies({String? language}) async {
    _logger.info('Fetching all trophies');
    final data = await _base.fetchPaginated(
      _base.makeUrl(
        _trophyUrl,
        query: {'limit': API_MAX_PAGE_SIZE},
      ),
      language: language,
    );
    return data.map((e) => Trophy.fromJson(e)).toList();
  }

  Future<List<UserTrophy>> fetchUserTrophies({
    Map<String, String>? filterQuery,
    String? language,
  }) async {
    _logger.info('Fetching user trophies');
    final query = {'limit': API_MAX_PAGE_SIZE};
    if (filterQuery != null) {
      query.addAll(filterQuery);
    }
    final data = await _base.fetchPaginated(
      _base.makeUrl(
        _userTrophyUrl,
        query: query,
      ),
      language: language,
    );
    return data.map((e) => UserTrophy.fromJson(e)).toList();
  }

  Future<List<UserTrophyProgression>> fetchProgression({
    Map<String, String>? filterQuery,
    String? language,
  }) async {
    _logger.info('Fetching trophy progression');
    final data = await _base.fetch(
      _base.makeUrl(
        _progressionUrl,
        query: filterQuery,
      ),
      language: language,
    );
    return (data as List<dynamic>).map((e) => UserTrophyProgression.fromJson(e)).toList();
  }
}
