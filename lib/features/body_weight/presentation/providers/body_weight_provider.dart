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

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wger/features/body_weight/data/api/body_weight_api_service.dart';
import 'package:wger/features/body_weight/data/repositories/body_weight_repository.dart';
import 'package:wger/features/body_weight/domain/models/weight_entry.dart';
import 'package:wger/providers/wger_base_riverpod.dart';

part 'body_weight_provider.g.dart';

@riverpod
BodyWeightRepository bodyWeightRepository(Ref ref) {
  final base = ref.watch(wgerBaseProvider);
  final api = BodyWeightApiService(base);
  return BodyWeightRepository(api);
}

@Riverpod(name: 'bodyWeightProvider')
class BodyWeightNotifier extends _$BodyWeightNotifier {
  @override
  Future<List<WeightEntry>> build() async {
    return ref.watch(bodyWeightRepositoryProvider).fetchEntries();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(bodyWeightRepositoryProvider).fetchEntries(),
    );
  }

  Future<void> addEntry(WeightEntry entry) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(
      [...previous, entry]..sort((a, b) => b.date.compareTo(a.date)),
    );

    try {
      final newEntry = await ref.read(bodyWeightRepositoryProvider).addEntry(entry);
      final current = state.asData?.value ?? [];
      state = AsyncValue.data(
        [
          ...current.where(
            (e) => entry.id == null ? e.id != null : e.id != entry.id,
          ),
          newEntry,
        ]..sort((a, b) => b.date.compareTo(a.date)),
      );
    } catch (err, stackTrace) {
      state = AsyncValue.data(previous);
      Error.throwWithStackTrace(err, stackTrace);
    }
  }

  Future<void> editEntry(WeightEntry entry) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(
      previous.map((e) => e.id == entry.id ? entry : e).toList(),
    );

    try {
      await ref.read(bodyWeightRepositoryProvider).editEntry(entry);
    } catch (err, stackTrace) {
      state = AsyncValue.data(previous);
      Error.throwWithStackTrace(err, stackTrace);
    }
  }

  Future<void> deleteEntry(int id) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(previous.where((e) => e.id != id).toList());

    try {
      await ref.read(bodyWeightRepositoryProvider).deleteEntry(id);
    } catch (err, stackTrace) {
      state = AsyncValue.data(previous);
      Error.throwWithStackTrace(err, stackTrace);
    }
  }

  WeightEntry? getNewestEntry() => state.asData?.value.firstOrNull;

  void clear() => state = const AsyncValue.data([]);
}
