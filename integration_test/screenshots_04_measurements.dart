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
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/models/measurements/measurement_category.dart';
import 'package:wger/features/measurement/presentation/providers/measurement_provider.dart';
import 'package:wger/features/measurement/presentation/screens/measurement_categories_screen.dart';
import 'package:wger/theme/theme.dart';

import '../test_data/measurements.dart';

class MockMeasurementNotifier extends MeasurementNotifier {
  @override
  Future<List<MeasurementCategory>> build() async => getMeasurementCategories();
}

Widget createMeasurementScreen({Locale? locale}) {
  locale ??= const Locale('en');

  return ProviderScope(
    overrides: [
      measurementProvider.overrideWith(() => MockMeasurementNotifier()),
    ],
    child: MediaQuery(
      data: MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).copyWith(
        padding: EdgeInsets.zero,
        viewPadding: EdgeInsets.zero,
        viewInsets: EdgeInsets.zero,
      ),
      child: MaterialApp(
        locale: locale,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: wgerLightTheme,
        home: const MeasurementCategoriesScreen(),
      ),
    ),
  );
}
