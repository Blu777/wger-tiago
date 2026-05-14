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

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wger/features/trophies/data/api/trophy_api_service.dart';
import 'package:wger/features/trophies/data/repositories/trophy_repository.dart';
import 'package:wger/features/trophies/domain/repositories/i_trophy_repository.dart';
import 'package:wger/models/trophies/trophy.dart';
import 'package:wger/models/trophies/user_trophy.dart';
import 'package:wger/models/trophies/user_trophy_progression.dart';
import 'package:wger/providers/wger_base_riverpod.dart';

part 'trophy_provider.g.dart';

class TrophyState {
  final List<Trophy> trophies;
  final List<UserTrophy> userTrophies;
  final List<UserTrophyProgression> trophyProgression;

  TrophyState({
    this.trophies = const [],
    this.userTrophies = const [],
    this.trophyProgression = const [],
  });

  TrophyState copyWith({
    List<Trophy>? trophies,
    List<UserTrophy>? userTrophies,
    List<UserTrophyProgression>? trophyProgression,
  }) {
    return TrophyState(
      trophies: trophies ?? this.trophies,
      userTrophies: userTrophies ?? this.userTrophies,
      trophyProgression: trophyProgression ?? this.trophyProgression,
    );
  }

  List<UserTrophy> get prTrophies =>
      userTrophies.where((t) => t.trophy.type == TrophyType.pr).toList();

  List<UserTrophy> get nonPrTrophies =>
      userTrophies.where((t) => t.trophy.type != TrophyType.pr).toList();
}

@Riverpod(keepAlive: true)
ITrophyRepository trophyRepository(Ref ref) {
  final base = ref.watch(wgerBaseProvider);
  final api = TrophyApiService(base);
  return TrophyRepository(api);
}

@Riverpod(keepAlive: true)
class TrophyNotifier extends _$TrophyNotifier {
  @override
  Future<TrophyState> build() async {
    final repository = ref.watch(trophyRepositoryProvider);
    return _fetchAll(repository: repository);
  }

  Future<TrophyState> _fetchAll({
    required ITrophyRepository repository,
    String? language,
  }) async {
    final results = await Future.wait([
      repository.fetchTrophies(language: language),
      repository.fetchUserTrophies(
        filterQuery: {'trophy__is_hidden': 'false'},
        language: language,
      ),
      repository.fetchProgression(language: language),
    ]);

    return TrophyState(
      trophies: results[0] as List<Trophy>,
      userTrophies: results[1] as List<UserTrophy>,
      trophyProgression: results[2] as List<UserTrophyProgression>,
    );
  }

  Future<void> refresh({String? language}) async {
    final repository = ref.read(trophyRepositoryProvider);
    final result = await AsyncValue.guard(
      () => _fetchAll(repository: repository, language: language),
    );
    if (!ref.mounted) {
      return;
    }
    state = result;
  }

  Future<void> fetchTrophies({String? language}) async {
    final repository = ref.read(trophyRepositoryProvider);
    final previous = state.asData?.value ?? TrophyState();

    try {
      final result = await repository.fetchTrophies(language: language);
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous.copyWith(trophies: result));
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncError(err, stack);
      return Future.error(err, stack);
    }
  }

  Future<void> fetchUserTrophies({String? language}) async {
    final repository = ref.read(trophyRepositoryProvider);
    final previous = state.asData?.value ?? TrophyState();

    try {
      final result = await repository.fetchUserTrophies(
        filterQuery: {'trophy__is_hidden': 'false'},
        language: language,
      );
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous.copyWith(userTrophies: result));
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncError(err, stack);
      return Future.error(err, stack);
    }
  }

  Future<void> fetchProgression({String? language}) async {
    final repository = ref.read(trophyRepositoryProvider);
    final previous = state.asData?.value ?? TrophyState();

    try {
      final result = await repository.fetchProgression(language: language);
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous.copyWith(trophyProgression: result));
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncError(err, stack);
      return Future.error(err, stack);
    }
  }
}
