/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (c) 2020 - 2026 wger Team
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/models/measurements/measurement_category.dart';
import 'package:wger/models/nutrition/nutritional_plan.dart';
import 'package:wger/providers/measurement_riverpod.dart';
import 'package:wger/screens/form_screen.dart';
import 'package:wger/widgets/measurements/charts.dart';
import 'package:wger/widgets/measurements/helpers.dart';

import 'forms.dart';

class EntriesList extends ConsumerWidget {
  final MeasurementCategory category;
  final List<NutritionalPlan> plans;

  const EntriesList({required this.category, required this.plans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numberFormat = NumberFormat.decimalPattern(Localizations.localeOf(context).toString());
    final entriesAll = category.entries
        .map((e) => MeasurementChartEntry(e.value, e.date))
        .toList();
    final entries7dAvg = moving7dAverage(entriesAll);
    final datetimeFormat = DateFormat.yMd(Localizations.localeOf(context).languageCode).add_Hm();

    return Column(
      children: [
        ...getOverviewWidgetsSeries(
          category.name,
          entriesAll,
          entries7dAvg,
          plans,
          category.unit,
          context,
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: category.entries.length,
            itemBuilder: (context, index) {
              final currentEntry = category.entries[index];

              return Card(
                child: ListTile(
                  title: Text('${numberFormat.format(currentEntry.value)} ${category.unit}'),
                  subtitle: Text(datetimeFormat.format(currentEntry.date)),
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
                              MeasurementEntryForm(
                                currentEntry.category,
                                currentEntry,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          child: Text(AppLocalizations.of(context).delete),
                          onTap: () async {
                            await ref.read(measurementProvider.notifier).deleteEntry(
                              currentEntry.id!,
                              currentEntry.category,
                            );

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
      ],
    );
  }
}
