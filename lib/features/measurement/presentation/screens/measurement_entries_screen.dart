/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (c)  2025 wger Team
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:wger/core/wide_screen_wrapper.dart';
import 'package:wger/features/measurement/presentation/providers/measurement_provider.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/models/measurements/measurement_category.dart';
import 'package:wger/models/nutrition/nutritional_plan.dart';
import 'package:wger/providers/nutrition.dart';
import 'package:wger/screens/form_screen.dart';
import 'package:wger/widgets/measurements/entries.dart';
import 'package:wger/widgets/measurements/forms.dart';

enum MeasurementOptions {
  edit,
  delete,
}

class MeasurementEntriesScreen extends ConsumerWidget {
  const MeasurementEntriesScreen();

  static const routeName = '/measurement-entries';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryId = ModalRoute.of(context)!.settings.arguments as int;
    final categoriesAsync = ref.watch(measurementProvider);
    final plans = context.read<NutritionPlansProvider>().items;

    return categoriesAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
      data: (categories) {
        final category = categories.firstWhereOrNull((c) => c.id == categoryId);

        if (category == null) {
          Future.microtask(() {
            if (context.mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
          return const SizedBox();
        }

        return _MeasurementEntriesBody(
          category: category,
          categoryId: categoryId,
          plans: plans,
        );
      },
    );
  }
}

class _MeasurementEntriesBody extends StatelessWidget {
  final MeasurementCategory category;
  final int categoryId;
  final List<NutritionalPlan> plans;

  const _MeasurementEntriesBody({
    required this.category,
    required this.categoryId,
    required this.plans,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          PopupMenuButton<MeasurementOptions>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case MeasurementOptions.edit:
                  Navigator.pushNamed(
                    context,
                    FormScreen.routeName,
                    arguments: FormScreenArguments(
                      AppLocalizations.of(context).edit,
                      MeasurementCategoryForm(category),
                    ),
                  );
                  break;

                case MeasurementOptions.delete:
                  showDialog(
                    context: context,
                    builder: (BuildContext contextDialog) {
                      return AlertDialog(
                        content: Text(
                          AppLocalizations.of(context).confirmDelete(category.name),
                        ),
                        actions: [
                          TextButton(
                            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                            onPressed: () => Navigator.of(contextDialog).pop(),
                          ),
                          TextButton(
                            child: Text(
                              AppLocalizations.of(context).delete,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(contextDialog).pop();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(context).successfullyDeleted,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MeasurementOptions>(
                  value: MeasurementOptions.edit,
                  child: Text(AppLocalizations.of(context).edit),
                ),
                PopupMenuItem<MeasurementOptions>(
                  value: MeasurementOptions.delete,
                  child: Text(AppLocalizations.of(context).delete),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(
            context,
            FormScreen.routeName,
            arguments: FormScreenArguments(
              AppLocalizations.of(context).newEntry,
              MeasurementEntryForm(categoryId),
            ),
          );
        },
      ),
      body: WidescreenWrapper(
        child: SingleChildScrollView(
          child: EntriesList(category: category, plans: plans),
        ),
      ),
    );
  }
}
