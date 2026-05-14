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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wger/features/body_weight/domain/models/weight_entry.dart';
import 'package:wger/features/body_weight/presentation/providers/body_weight_provider.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/l10n/generated/app_localizations.dart';

class WeightForm extends ConsumerStatefulWidget {
  final WeightEntry? initialEntry;

  const WeightForm({super.key, this.initialEntry});

  @override
  ConsumerState<WeightForm> createState() => _WeightFormState();
}

class _WeightFormState extends ConsumerState<WeightForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _timeController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.decimalPattern(Localizations.localeOf(context).toString());
    final dateFormat = DateFormat.yMd(Localizations.localeOf(context).languageCode);
    final timeFormat = DateFormat.Hm(Localizations.localeOf(context).languageCode);
    final entry = widget.initialEntry;

    if (_weightController.text.isEmpty && entry != null && entry.weight != 0) {
      _weightController.text = numberFormat.format(entry.weight);
    }
    if (_dateController.text.isEmpty) {
      _dateController.text = dateFormat.format(entry?.date ?? DateTime.now());
    }
    if (_timeController.text.isEmpty) {
      _timeController.text = TimeOfDay.fromDateTime(entry?.date ?? DateTime.now()).format(context);
    }

    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            key: const Key('dateInput'),
            readOnly: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).date,
              suffixIcon: const Icon(
                Icons.calendar_today,
                key: Key('calendarIcon'),
              ),
            ),
            enableInteractiveSelection: false,
            controller: _dateController,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: entry?.date ?? DateTime.now(),
                firstDate: DateTime(DateTime.now().year - 10),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                _dateController.text = dateFormat.format(pickedDate);
              }
            },
          ),
          TextFormField(
            key: const Key('timeInput'),
            readOnly: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).time,
              suffixIcon: const Icon(
                Icons.access_time_outlined,
                key: Key('clockIcon'),
              ),
            ),
            enableInteractiveSelection: false,
            controller: _timeController,
            onTap: () async {
              final pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(entry?.date ?? DateTime.now()),
              );
              if (!context.mounted) {
                return;
              }
              if (pickedTime != null) {
                _timeController.text = pickedTime.format(context);
              }
            },
          ),
          TextFormField(
            key: const Key('weightInput'),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).weight,
              prefix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const Key('quickMinus'),
                    icon: const FaIcon(FontAwesomeIcons.circleMinus),
                    onPressed: () {
                      try {
                        final newValue = numberFormat.parse(_weightController.text) - 1;
                        _weightController.text = numberFormat.format(newValue);
                      } on FormatException {}
                    },
                  ),
                  IconButton(
                    key: const Key('quickMinusSmall'),
                    icon: const FaIcon(FontAwesomeIcons.minus),
                    onPressed: () {
                      try {
                        final newValue = numberFormat.parse(_weightController.text) - 0.1;
                        _weightController.text = numberFormat.format(newValue);
                      } on FormatException {}
                    },
                  ),
                ],
              ),
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    key: const Key('quickPlusSmall'),
                    icon: const FaIcon(FontAwesomeIcons.plus),
                    onPressed: () {
                      try {
                        final newValue = numberFormat.parse(_weightController.text) + 0.1;
                        _weightController.text = numberFormat.format(newValue);
                      } on FormatException {}
                    },
                  ),
                  IconButton(
                    key: const Key('quickPlus'),
                    icon: const FaIcon(FontAwesomeIcons.circlePlus),
                    onPressed: () {
                      try {
                        final newValue = numberFormat.parse(_weightController.text) + 1;
                        _weightController.text = numberFormat.format(newValue);
                      } on FormatException {}
                    },
                  ),
                ],
              ),
            ),
            controller: _weightController,
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
          ElevatedButton(
            key: const Key(SUBMIT_BUTTON_KEY_NAME),
            child: Text(AppLocalizations.of(context).save),
            onPressed: () async {
              if (!_form.currentState!.validate()) {
                return;
              }

              final parsedDate = dateFormat.parse(_dateController.text);
              final parsedTime = timeFormat.parse(_timeController.text);
              final parsedWeight = numberFormat.parse(_weightController.text);

              final newEntry = WeightEntry(
                id: entry?.id,
                weight: parsedWeight,
                date: DateTime(
                  parsedDate.year,
                  parsedDate.month,
                  parsedDate.day,
                  parsedTime.hour,
                  parsedTime.minute,
                  parsedTime.second,
                ),
              );

              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                final notifier = ref.read(bodyWeightProvider.notifier);
                if (newEntry.id == null) {
                  await notifier.addEntry(newEntry);
                } else {
                  await notifier.editEntry(newEntry);
                }

                if (mounted) {
                  navigator.pop();
                }
              } catch (e) {
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
