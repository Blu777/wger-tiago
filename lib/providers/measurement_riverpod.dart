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

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/measurements/measurement_category.dart';
import 'package:wger/models/measurements/measurement_entry.dart';
import 'package:wger/providers/base_provider.dart';
import 'package:wger/providers/wger_base_riverpod.dart';

part 'measurement_riverpod.g.dart';

class MeasurementRepository {
  final WgerBaseProvider _base;

  static const _categoryUrl = 'measurement-category';
  static const _entryUrl = 'measurement';

  MeasurementRepository(this._base);

  Future<List<MeasurementCategory>> fetchCategories() async {
    final requestUrl = _base.makeUrl(_categoryUrl, query: {'limit': API_MAX_PAGE_SIZE});
    final data = await _base.fetchPaginated(requestUrl);
    return data.map((e) => MeasurementCategory.fromJson(e)).toList();
  }

  Future<List<MeasurementEntry>> fetchEntries(int categoryId) async {
    final requestUrl = _base.makeUrl(
      _entryUrl,
      query: {'category': categoryId.toString(), 'limit': API_MAX_PAGE_SIZE},
    );
    final data = await _base.fetchPaginated(requestUrl);
    return data.map((e) => MeasurementEntry.fromJson(e)).toList();
  }

  Future<MeasurementCategory> addCategory(MeasurementCategory category) async {
    final uri = _base.makeUrl(_categoryUrl);
    final response = await _base.post(category.toJson(), uri);
    return MeasurementCategory.fromJson(response);
  }

  Future<void> deleteCategory(int id) async {
    await _base.deleteRequest(_categoryUrl, id);
  }

  Future<MeasurementCategory> editCategory(MeasurementCategory category) async {
    final response = await _base.patch(
      category.toJson(),
      _base.makeUrl(_categoryUrl, id: category.id),
    );
    return MeasurementCategory.fromJson(response);
  }

  Future<MeasurementEntry> addEntry(MeasurementEntry entry) async {
    final uri = _base.makeUrl(_entryUrl);
    final response = await _base.post(entry.toJson(), uri);
    return MeasurementEntry.fromJson(response);
  }

  Future<void> deleteEntry(int id) async {
    await _base.deleteRequest(_entryUrl, id);
  }

  Future<MeasurementEntry> editEntry(MeasurementEntry entry) async {
    final response = await _base.patch(
      entry.toJson(),
      _base.makeUrl(_entryUrl, id: entry.id),
    );
    return MeasurementEntry.fromJson(response);
  }
}

List<MeasurementCategory> _updateCategory(
  List<MeasurementCategory> categories,
  int categoryId,
  MeasurementCategory Function(MeasurementCategory) updater,
) {
  return categories.map((c) => c.id == categoryId ? updater(c) : c).toList();
}

@Riverpod(keepAlive: true)
class MeasurementNotifier extends _$MeasurementNotifier {
  late final MeasurementRepository _repo;

  @override
  Future<List<MeasurementCategory>> build() async {
    _repo = MeasurementRepository(ref.read(wgerBaseProvider));
    return _repo.fetchCategories();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    if (!ref.mounted) {
      return;
    }
    final result = await AsyncValue.guard(() async {
      final categories = await _repo.fetchCategories();
      final withEntries = await Future.wait(
        categories.map((c) async {
          final entries = await _repo.fetchEntries(c.id!);
          return c.copyWith(entries: entries);
        }),
      );
      return withEntries;
    });
    if (!ref.mounted) {
      return;
    }
    state = result;
  }

  Future<void> loadCategoryEntries(int categoryId) async {
    final previous = state.asData?.value ?? [];
    try {
      final entries = await _repo.fetchEntries(categoryId);
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(
        _updateCategory(previous, categoryId, (cat) => cat.copyWith(entries: entries)),
      );
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      return Future.error(err, stack);
    }
  }

  Future<void> addCategory(MeasurementCategory category) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data([...previous, category]..sort((a, b) => a.name.compareTo(b.name)));
    try {
      final newCategory = await _repo.addCategory(category);
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(
        [...previous, newCategory]..sort((a, b) => a.name.compareTo(b.name)),
      );
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous);
      return Future.error(err, stack);
    }
  }

  Future<void> deleteCategory(int id) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(previous.where((c) => c.id != id).toList());
    try {
      await _repo.deleteCategory(id);
      if (!ref.mounted) {
        return;
      }
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous);
      return Future.error(err, stack);
    }
  }

  Future<void> editCategory(MeasurementCategory category) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(
      previous.map((c) => c.id == category.id ? category : c).toList()
        ..sort((a, b) => a.name.compareTo(b.name)),
    );
    try {
      final updated = await _repo.editCategory(category);
      if (!ref.mounted) {
        return;
      }
      final old = previous.firstWhereOrNull((c) => c.id == category.id);
      state = AsyncValue.data(
        previous.map((c) => c.id == category.id ? updated.copyWith(entries: old?.entries ?? []) : c).toList()
          ..sort((a, b) => a.name.compareTo(b.name)),
      );
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous);
      return Future.error(err, stack);
    }
  }

  Future<void> addEntry(MeasurementEntry entry) async {
    final previous = state.asData?.value ?? [];
    final optimistic = _updateCategory(previous, entry.category, (cat) {
      final newEntries = [...cat.entries, entry]..sort((a, b) => b.date.compareTo(a.date));
      return cat.copyWith(entries: newEntries);
    });
    state = AsyncValue.data(optimistic);

    try {
      final newEntry = await _repo.addEntry(entry);
      if (!ref.mounted) {
        return;
      }
      final finalState = _updateCategory(previous, entry.category, (cat) {
        final newEntries = [...cat.entries.where((e) => e.id != entry.id), newEntry]
          ..sort((a, b) => b.date.compareTo(a.date));
        return cat.copyWith(entries: newEntries);
      });
      state = AsyncValue.data(finalState);
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous);
      return Future.error(err, stack);
    }
  }

  Future<void> editEntry(MeasurementEntry entry) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(
      _updateCategory(previous, entry.category, (cat) {
        final newEntries = cat.entries.map((e) => e.id == entry.id ? entry : e).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        return cat.copyWith(entries: newEntries);
      }),
    );
    try {
      await _repo.editEntry(entry);
      if (!ref.mounted) {
        return;
      }
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous);
      return Future.error(err, stack);
    }
  }

  Future<void> deleteEntry(int id, int categoryId) async {
    final previous = state.asData?.value ?? [];
    state = AsyncValue.data(
      _updateCategory(previous, categoryId, (cat) {
        return cat.copyWith(entries: cat.entries.where((e) => e.id != id).toList());
      }),
    );
    try {
      await _repo.deleteEntry(id);
      if (!ref.mounted) {
        return;
      }
    } catch (err, stack) {
      if (!ref.mounted) {
        return;
      }
      state = AsyncValue.data(previous);
      return Future.error(err, stack);
    }
  }

  MeasurementCategory? findCategoryById(int id) =>
    (state.asData?.value ?? []).firstWhereOrNull((c) => c.id == id);

  void clear() => state = const AsyncValue.data([]);
}
