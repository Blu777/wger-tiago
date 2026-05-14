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
import 'package:intl/intl.dart';
import 'package:wger/features/body_weight/presentation/providers/body_weight_provider.dart';
import 'package:wger/features/body_weight/presentation/widgets/weight_form.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/models/nutrition/nutritional_plan.dart';
import 'package:wger/models/user/profile.dart';
import 'package:wger/screens/form_screen.dart';
import 'package:wger/screens/measurement_categories_screen.dart';
import 'package:wger/widgets/measurements/charts.dart';
import 'package:wger/widgets/measurements/helpers.dart';

class WeightOverview extends ConsumerWidget {
  final Profile profile;
  final List<NutritionalPlan> plans;

  const WeightOverview({required this.profile, required this.plans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormat = NumberFormat.decimalPattern(Localizations.localeOf(context).toString());
    final unit = weightUnit(profile.isMetric, context);
    final entriesAsync = ref.watch(bodyWeightProvider);

    return entriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (entries) {
        final entriesAll = entries.map((e) => MeasurementChartEntry(e.weight, e.date)).toList();
        final entries7dAvg = moving7dAverage(entriesAll);

        return Column(
          children: [
            ...getOverviewWidgetsSeries(
              AppLocalizations.of(context).weight,
              entriesAll,
              entries7dAvg,
              plans,
              unit,
              context,
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(
                context,
                MeasurementCategoriesScreen.routeName,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(AppLocalizations.of(context).measurements),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              child: RefreshIndicator(
                onRefresh: () => ref.read(bodyWeightProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final currentEntry = entries[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          '${numberFormat.format(currentEntry.weight)} ${weightUnit(profile.isMetric, context)}',
                        ),
                        subtitle: Text(
                          DateFormat.yMd(
                            Localizations.localeOf(context).languageCode,
                          ).add_Hm().format(currentEntry.date),
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                child: Text(AppLocalizations.of(context).edit),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  FormScreen.routeName,
                                  arguments: FormScreenArguments(
                                    AppLocalizations.of(context).edit,
                                    WeightForm(initialEntry: currentEntry),
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: Text(AppLocalizations.of(context).delete),
                                onTap: () async {
                                  await ref.read(bodyWeightProvider.notifier).deleteEntry(currentEntry.id!);

                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          AppLocalizations.of(context).successfullyDeleted,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ];
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
