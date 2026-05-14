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

import 'package:wger/features/trophies/data/api/trophy_api_service.dart';
import 'package:wger/features/trophies/domain/repositories/i_trophy_repository.dart';
import 'package:wger/models/trophies/trophy.dart';
import 'package:wger/models/trophies/user_trophy.dart';
import 'package:wger/models/trophies/user_trophy_progression.dart';

class TrophyRepository implements ITrophyRepository {
  final TrophyApiService _api;

  TrophyRepository(this._api);

  @override
  Future<List<Trophy>> fetchTrophies({String? language}) async {
    return _api.fetchTrophies(language: language);
  }

  @override
  Future<List<UserTrophy>> fetchUserTrophies({
    Map<String, String>? filterQuery,
    String? language,
  }) async {
    return _api.fetchUserTrophies(filterQuery: filterQuery, language: language);
  }

  @override
  Future<List<UserTrophyProgression>> fetchProgression({
    Map<String, String>? filterQuery,
    String? language,
  }) async {
    return _api.fetchProgression(filterQuery: filterQuery, language: language);
  }

  @override
  List<Trophy> filterByType(List<Trophy> list, TrophyType type) =>
      list.where((t) => t.type == type).toList();
}
