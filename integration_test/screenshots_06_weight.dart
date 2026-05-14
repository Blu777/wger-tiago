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

// ignore_for_file: scoped_providers_should_specify_dependencies

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:wger/features/body_weight/domain/models/weight_entry.dart';
import 'package:wger/features/body_weight/presentation/providers/body_weight_provider.dart';
import 'package:wger/features/body_weight/presentation/screens/weight_screen.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/providers/nutrition.dart';
import 'package:wger/providers/user.dart';
import 'package:wger/screens/form_screen.dart';
import 'package:wger/theme/theme.dart';

import '../test/exercises/contribute_exercise_test.mocks.dart';
import '../test/nutrition/nutritional_meal_form_test.mocks.dart';
import '../test_data/body_weight.dart';
import '../test_data/nutritional_plans.dart';
import '../test_data/profile.dart';

class MockBodyWeightNotifier extends BodyWeightNotifier {
  final List<WeightEntry> _entries;
  MockBodyWeightNotifier(this._entries);

  @override
  Future<List<WeightEntry>> build() async => _entries;
}

Widget createWeightScreen({Locale? locale}) {
  locale ??= const Locale('en');

  final mockUserProvider = MockUserProvider();
  when(mockUserProvider.profile).thenReturn(tProfile1);

  final mockNutritionPlansProvider = MockNutritionPlansProvider();
  when(mockNutritionPlansProvider.currentPlan).thenReturn(null);
  when(mockNutritionPlansProvider.items).thenReturn([getNutritionalPlan()]);

  return ProviderScope(
    overrides: [
      bodyWeightProvider.overrideWith(() => MockBodyWeightNotifier(getScreenshotWeightEntries())),
    ],
    child: MediaQuery(
      data: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).copyWith(
        padding: EdgeInsets.zero,
        viewPadding: EdgeInsets.zero,
        viewInsets: EdgeInsets.zero,
      ),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (context) => mockUserProvider,
          ),
          ChangeNotifierProvider<NutritionPlansProvider>(
            create: (context) => mockNutritionPlansProvider,
          ),
        ],
        child: MaterialApp(
          locale: locale,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: wgerLightTheme,
          home: WeightScreen(
            profile: mockUserProvider.profile!,
            plans: mockNutritionPlansProvider.items,
          ),
          routes: {FormScreen.routeName: (ctx) => const FormScreen()},
        ),
      ),
    ),
  );
}
