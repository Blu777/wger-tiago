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
import 'package:wger/core/wide_screen_wrapper.dart';
import 'package:wger/features/body_weight/presentation/widgets/weight_form.dart';
import 'package:wger/features/body_weight/presentation/widgets/weight_overview.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/models/nutrition/nutritional_plan.dart';
import 'package:wger/models/user/profile.dart';
import 'package:wger/screens/form_screen.dart';
import 'package:wger/widgets/core/app_bar.dart';

class WeightScreen extends StatelessWidget {
  final Profile profile;
  final List<NutritionalPlan> plans;

  const WeightScreen({required this.profile, required this.plans});

  static const routeName = '/weight';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EmptyAppBar(AppLocalizations.of(context).weight),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(
            context,
            FormScreen.routeName,
            arguments: FormScreenArguments(
              AppLocalizations.of(context).newEntry,
              const WeightForm(),
            ),
          );
        },
      ),
      body: WidescreenWrapper(
        child: SingleChildScrollView(
          child: WeightOverview(profile: profile, plans: plans),
        ),
      ),
    );
  }
}
