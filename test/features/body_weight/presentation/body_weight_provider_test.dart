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

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wger/features/body_weight/domain/models/weight_entry.dart';
import 'package:wger/features/body_weight/presentation/providers/body_weight_provider.dart';
import 'package:wger/providers/base_provider.dart';
import 'package:wger/providers/wger_base_riverpod.dart';

import '../../../fixtures/fixture_reader.dart';
import 'body_weight_provider_test.mocks.dart';

@GenerateMocks([WgerBaseProvider])
void main() {
  late MockWgerBaseProvider mockBaseProvider;
  late ProviderContainer container;

  setUp(() {
    mockBaseProvider = MockWgerBaseProvider();
    container = ProviderContainer(
      overrides: [
        wgerBaseProvider.overrideWithValue(mockBaseProvider),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('BodyWeightNotifier', () {
    test('fetches entries on build', () async {
      final uri = Uri(
        scheme: 'https',
        host: 'localhost',
        path: 'api/v2/weightentry/',
      );
      when(mockBaseProvider.makeUrl(any, query: anyNamed('query'))).thenReturn(uri);
      final Map<String, dynamic> weightEntries = jsonDecode(
        fixture('weight/weight_entries.json'),
      );

      when(mockBaseProvider.fetchPaginated(uri)).thenAnswer(
        (_) => Future.value(weightEntries['results']),
      );

      await container.read(bodyWeightProvider.future);
      final state = container.read(bodyWeightProvider);

      expect(state.value, isA<List<WeightEntry>>());
      expect(state.value?.length, 11);
    });

    test('adds a new weight entry', () async {
      final uri = Uri(
        scheme: 'https',
        host: 'localhost',
        path: 'api/v2/weightentry/',
      );
      when(mockBaseProvider.makeUrl(any, query: anyNamed('query'))).thenReturn(uri);
      when(
        mockBaseProvider.post(
          {'id': null, 'weight': '80', 'date': '2021-01-01T00:00:00.000Z'},
          uri,
        ),
      ).thenAnswer((_) => Future.value({'id': 25, 'date': '2021-01-01', 'weight': '80'}));

      final weightEntry = WeightEntry(date: DateTime.utc(2021, 1, 1), weight: 80);
      await container.read(bodyWeightProvider.notifier).addEntry(weightEntry);

      final state = container.read(bodyWeightProvider);
      expect(state.value?.length, 1);
      expect(state.value?.first.id, 25);
      expect(state.value?.first.weight, 80);
    });

    test('deletes an existing weight entry', () async {
      final uri = Uri(
        scheme: 'https',
        host: 'localhost',
        path: 'api/v2/weightentry/4/',
      );
      when(mockBaseProvider.makeUrl(any, query: anyNamed('query'))).thenReturn(uri);
      when(mockBaseProvider.deleteRequest('weightentry', 4)).thenAnswer(
        (_) => Future.value(Response("{'id': 4, 'date': '2021-01-01', 'weight': '80'}", 204)),
      );

      // Seed the state with an entry via addEntry then delete it
      final notifier = container.read(bodyWeightProvider.notifier);
      when(
        mockBaseProvider.post(any, uri),
      ).thenAnswer((_) => Future.value({'id': 4, 'date': '2021-01-01', 'weight': '80'}));

      await notifier.addEntry(WeightEntry(id: 4, date: DateTime(2021, 1, 1), weight: 80));
      await notifier.deleteEntry(4);

      final state = container.read(bodyWeightProvider);
      expect(state.value?.length, 0);
    });

    test('rolls back state on addEntry exception', () async {
      final uri = Uri(
        scheme: 'https',
        host: 'localhost',
        path: 'api/v2/weightentry/',
      );
      when(mockBaseProvider.makeUrl(any, query: anyNamed('query'))).thenReturn(uri);

      // Seed the state with one entry
      when(mockBaseProvider.post(any, uri)).thenAnswer(
        (_) => Future.value({'id': 1, 'date': '2021-01-01', 'weight': '70'}),
      );
      final notifier = container.read(bodyWeightProvider.notifier);
      await notifier.addEntry(WeightEntry(date: DateTime(2021, 1, 1), weight: 70));
      final previousState = container.read(bodyWeightProvider);
      expect(previousState.value?.length, 1);

      // Force addEntry to throw
      when(mockBaseProvider.post(any, uri)).thenThrow(Exception('network error'));

      final newEntry = WeightEntry(date: DateTime(2021, 1, 2), weight: 80);
      await expectLater(notifier.addEntry(newEntry), throwsException);

      final state = container.read(bodyWeightProvider);
      expect(state.value?.length, 1);
      expect(state.value?.first.weight, 70);
    });

    test('rolls back state on editEntry exception', () async {
      final uri = Uri(
        scheme: 'https',
        host: 'localhost',
        path: 'api/v2/weightentry/',
      );
      final patchUri = Uri(
        scheme: 'https',
        host: 'localhost',
        path: 'api/v2/weightentry/1/',
      );
      when(mockBaseProvider.makeUrl(any, query: anyNamed('query'))).thenReturn(uri);
      when(mockBaseProvider.makeUrl('weightentry', id: 1)).thenReturn(patchUri);

      // Seed the state with one entry
      when(mockBaseProvider.post(any, uri)).thenAnswer(
        (_) => Future.value({'id': 1, 'date': '2021-01-01', 'weight': '70'}),
      );
      final notifier = container.read(bodyWeightProvider.notifier);
      await notifier.addEntry(WeightEntry(date: DateTime(2021, 1, 1), weight: 70));
      final previousState = container.read(bodyWeightProvider);
      expect(previousState.value?.length, 1);
      expect(previousState.value?.first.weight, 70);

      // Force editEntry to throw
      when(mockBaseProvider.patch(any, patchUri)).thenThrow(Exception('network error'));

      final updatedEntry = WeightEntry(id: 1, date: DateTime(2021, 1, 1), weight: 75);
      await expectLater(notifier.editEntry(updatedEntry), throwsException);

      final state = container.read(bodyWeightProvider);
      expect(state.value?.length, 1);
      expect(state.value?.first.weight, 70);
    });

    test('rolls back state on deleteEntry exception', () async {
      final uri = Uri(
        scheme: 'https',
        host: 'localhost',
        path: 'api/v2/weightentry/',
      );
      when(mockBaseProvider.makeUrl(any, query: anyNamed('query'))).thenReturn(uri);

      // Seed the state with one entry
      when(mockBaseProvider.post(any, uri)).thenAnswer(
        (_) => Future.value({'id': 5, 'date': '2021-01-01', 'weight': '70'}),
      );
      final notifier = container.read(bodyWeightProvider.notifier);
      await notifier.addEntry(WeightEntry(date: DateTime(2021, 1, 1), weight: 70));
      final previousState = container.read(bodyWeightProvider);
      expect(previousState.value?.length, 1);

      // Force deleteEntry to throw
      when(mockBaseProvider.deleteRequest('weightentry', 5)).thenThrow(Exception('network error'));

      await expectLater(notifier.deleteEntry(5), throwsException);

      final state = container.read(bodyWeightProvider);
      expect(state.value?.length, 1);
      expect(state.value?.first.id, 5);
    });
  });
}
