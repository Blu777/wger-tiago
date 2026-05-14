/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wger/features/body_weight/presentation/screens/weight_screen.dart';
import 'package:wger/features/body_weight/presentation/widgets/weight_form.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/providers/base_provider.dart';
import 'package:wger/providers/wger_base_riverpod.dart';
import 'package:wger/screens/form_screen.dart';
import 'package:wger/widgets/measurements/charts.dart';

import '../../../../test_data/profile.dart';
import 'weight_screen_test.mocks.dart';

@GenerateMocks([WgerBaseProvider])
void main() {
  late MockWgerBaseProvider mockBaseProvider;

  setUp(() {
    mockBaseProvider = MockWgerBaseProvider();
  });

  Widget createWeightScreen({locale = 'en'}) {
    final uri = Uri(
      scheme: 'https',
      host: 'localhost',
      path: 'api/v2/weightentry/',
    );
    when(mockBaseProvider.makeUrl(any, query: anyNamed('query'))).thenReturn(uri);
    when(mockBaseProvider.fetchPaginated(uri)).thenAnswer(
      (_) => Future.value([
        {'id': 1, 'date': '2021-01-01', 'weight': '80.00'},
        {'id': 2, 'date': '2021-01-02', 'weight': '81.00'},
      ]),
    );
    when(mockBaseProvider.deleteRequest('weightentry', any)).thenAnswer(
      (_) => Future.value(
        // ignore: deprecated_member_use
        Response("{'id': 1, 'date': '2021-01-01', 'weight': '80.00'}", 204),
      ),
    );

    return ProviderScope(
      overrides: [
        wgerBaseProvider.overrideWithValue(mockBaseProvider),
      ],
      child: MaterialApp(
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: WeightScreen(
          profile: tProfile1,
          plans: const [],
        ),
        routes: {FormScreen.routeName: (_) => const FormScreen()},
      ),
    );
  }

  testWidgets('Test the widgets on the body weight screen', (WidgetTester tester) async {
    await tester.pumpWidget(createWeightScreen());
    await tester.pumpAndSettle();

    expect(find.text('Weight'), findsOneWidget);
    expect(find.byType(MeasurementChartWidgetFl), findsOneWidget);
    expect(find.byType(Card), findsNWidgets(2));
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('Test deleting an item using the Delete button', (WidgetTester tester) async {
    await tester.pumpWidget(createWeightScreen());
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNWidgets(2));
    await tester.tap(find.byTooltip('Show menu').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    // After deletion, only one ListTile should remain
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('Test the form on the body weight screen', (WidgetTester tester) async {
    await tester.pumpWidget(createWeightScreen());
    await tester.pumpAndSettle();

    expect(find.byType(WeightForm), findsNothing);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.byType(WeightForm), findsOneWidget);
  });

  testWidgets('Tests the localization of dates - EN', (WidgetTester tester) async {
    await tester.pumpWidget(createWeightScreen());
    await tester.pumpAndSettle();
    // these don't work because we only have 2 points, and to prevent overlaps we don't display their titles
    // expect(find.text('1/1'), findsOneWidget);
    // expect(find.text('1/10'), findsOneWidget);
  });

  testWidgets('Tests the localization of dates - DE', (WidgetTester tester) async {
    await tester.pumpWidget(createWeightScreen(locale: 'de'));
    await tester.pumpAndSettle();
    // these don't work because we only have 2 points, and to prevent overlaps we don't display their titles
    // expect(find.text('1.1.'), findsOneWidget);
    // expect(find.text('10.1.'), findsOneWidget);
  });
}
