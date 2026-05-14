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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wger/features/body_weight/presentation/providers/body_weight_provider.dart';
import 'package:wger/features/body_weight/presentation/screens/weight_screen.dart';
import 'package:wger/features/body_weight/presentation/widgets/weight_form.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/models/nutrition/nutritional_plan.dart';
import 'package:wger/models/user/profile.dart';
import 'package:wger/screens/form_screen.dart';
import 'package:wger/widgets/dashboard/widgets/nothing_found.dart';
import 'package:wger/widgets/measurements/charts.dart';
import 'package:wger/widgets/measurements/helpers.dart';

class DashboardWeightWidget extends ConsumerWidget {
  final Profile profile;
  final List<NutritionalPlan> plans;

  const DashboardWeightWidget({required this.profile, required this.plans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(bodyWeightProvider);

    return entriesAsync.when(
      loading: () => const Card(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Card(child: Center(child: Text('Error: $err'))),
      data: (entries) {
        final (entriesAll, entries7dAvg) = sensibleRange(
          entries.map((e) => MeasurementChartEntry(e.weight, e.date)).toList(),
        );

        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context).weight,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                leading: FaIcon(
                  FontAwesomeIcons.weightScale,
                  color: Theme.of(context).textTheme.headlineSmall!.color,
                ),
              ),
              Column(
                children: [
                  if (entries.isNotEmpty)
                    Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: MeasurementChartWidgetFl(
                            entriesAll,
                            weightUnit(profile.isMetric, context),
                            avgs: entries7dAvg,
                          ),
                        ),
                        if (entries7dAvg.isNotEmpty)
                          MeasurementOverallChangeWidget(
                            entries7dAvg.first,
                            entries7dAvg.last,
                            weightUnit(profile.isMetric, context),
                          ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      child: Text(
                                        AppLocalizations.of(context).goToDetailPage,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => WeightScreen(
                                              profile: profile,
                                              plans: plans,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        final notifier = ref.read(bodyWeightProvider.notifier);
                                        Navigator.pushNamed(
                                          context,
                                          FormScreen.routeName,
                                          arguments: FormScreenArguments(
                                            AppLocalizations.of(context).newEntry,
                                            WeightForm(
                                              initialEntry: notifier.getNewestEntry()?.copyWith(
                                                id: null,
                                                date: DateTime.now(),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  else
                    NothingFound(
                      AppLocalizations.of(context).noWeightEntries,
                      AppLocalizations.of(context).newEntry,
                      const WeightForm(),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
