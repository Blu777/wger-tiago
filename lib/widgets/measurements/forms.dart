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

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/models/measurements/measurement_category.dart';
import 'package:wger/models/measurements/measurement_entry.dart';
import 'package:wger/providers/measurement_riverpod.dart';

class MeasurementCategoryForm extends ConsumerWidget {
  final _form = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final unitController = TextEditingController();

  final MeasurementCategory? _initial;

  MeasurementCategoryForm([MeasurementCategory? initial]) : _initial = initial {
    if (initial != null) {
      unitController.text = initial.unit;
      nameController.text = initial.name;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).name,
              helperText: AppLocalizations.of(context).measurementCategoriesHelpText,
            ),
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).enterValue;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).unit,
              helperText: AppLocalizations.of(context).measurementEntriesHelpText,
            ),
            controller: unitController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).enterValue;
              }
              return null;
            },
          ),
          ElevatedButton(
            child: Text(AppLocalizations.of(context).save),
            onPressed: () async {
              if (!_form.currentState!.validate()) {
                return;
              }

              final notifier = ref.read(measurementProvider.notifier);
              if (_initial == null) {
                await notifier.addCategory(
                  MeasurementCategory(
                    id: null,
                    name: nameController.text,
                    unit: unitController.text,
                  ),
                );
              } else {
                await notifier.editCategory(
                  _initial.copyWith(
                    name: nameController.text,
                    unit: unitController.text,
                  ),
                );
              }

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}

class MeasurementEntryForm extends ConsumerWidget {
  final _form = GlobalKey<FormState>();
  final int _categoryId;
  final _valueController = TextEditingController();
  final _dateController = TextEditingController(text: '');
  final _timeController = TextEditingController(text: '');
  final _notesController = TextEditingController();

  final MeasurementEntry? _initial;

  MeasurementEntryForm(this._categoryId, [this._initial]) {
    _notesController.text = _initial?.notes ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat.yMd(Localizations.localeOf(context).languageCode);
    final timeFormat = DateFormat.Hm(Localizations.localeOf(context).languageCode);
    final numberFormat = NumberFormat.decimalPattern(Localizations.localeOf(context).toString());

    final categoriesAsync = ref.watch(measurementProvider);
    final measurementCategory = categoriesAsync.asData?.value
        .firstWhereOrNull((category) => category.id == _categoryId);

    final entry = _initial;
    final initialDate = entry?.date ?? DateTime.now();

    if (_dateController.text.isEmpty) {
      _dateController.text = dateFormat.format(initialDate);
    }
    if (_timeController.text.isEmpty) {
      _timeController.text = timeFormat.format(initialDate);
    }
    if (_valueController.text.isEmpty && entry != null) {
      _valueController.text = numberFormat.format(entry.value);
    }

    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).date,
              suffixIcon: const Icon(
                Icons.calendar_today,
                key: Key('calendarIcon'),
              ),
            ),
            readOnly: true,
            controller: _dateController,
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(DateTime.now().year - 10),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                _dateController.text = dateFormat.format(pickedDate);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).enterValue;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).time,
              suffixIcon: const Icon(
                Icons.access_time_outlined,
                key: Key('clockIcon'),
              ),
            ),
            readOnly: true,
            controller: _timeController,
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(initialDate),
              );
              if (pickedTime != null) {
                final now = DateTime.now();
                final dt = DateTime(
                  now.year,
                  now.month,
                  now.day,
                  pickedTime.hour,
                  pickedTime.minute,
                );
                _timeController.text = timeFormat.format(dt);
              }
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).value,
              suffixIcon: Text(measurementCategory?.unit ?? ''),
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            ),
            controller: _valueController,
            keyboardType: textInputTypeDecimal,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context).enterValue;
              }
              try {
                numberFormat.parse(value);
              } catch (error) {
                return AppLocalizations.of(context).enterValidNumber;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: AppLocalizations.of(context).notes),
            controller: _notesController,
            validator: (value) {
              const minLength = 0;
              const maxLength = 100;
              if (value != null && value.isNotEmpty && (value.length < minLength || value.length > maxLength)) {
                return AppLocalizations.of(context).enterCharacters(
                  minLength.toString(),
                  maxLength.toString(),
                );
              }
              return null;
            },
          ),
          ElevatedButton(
            child: Text(AppLocalizations.of(context).save),
            onPressed: () async {
              if (!_form.currentState!.validate()) {
                return;
              }

              final parsedDate = dateFormat.parse(_dateController.text);
              final parsedTime = timeFormat.parse(_timeController.text);
              final parsedValue = numberFormat.parse(_valueController.text);

              final newEntry = MeasurementEntry(
                id: entry?.id,
                category: _categoryId,
                date: DateTime(
                  parsedDate.year,
                  parsedDate.month,
                  parsedDate.day,
                  parsedTime.hour,
                  parsedTime.minute,
                  parsedTime.second,
                ),
                value: parsedValue,
                notes: _notesController.text,
              );

              final notifier = ref.read(measurementProvider.notifier);
              if (newEntry.id == null) {
                await notifier.addEntry(newEntry);
              } else {
                await notifier.editEntry(newEntry);
              }

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
