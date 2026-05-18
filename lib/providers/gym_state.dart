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

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_adaptation.dart';
import 'package:wger/helpers/shared_preferences.dart';
import 'package:wger/helpers/uuid.dart';
import 'package:wger/models/exercises/exercise.dart';
import 'package:wger/models/workouts/day_data.dart';
import 'package:wger/models/workouts/log.dart';
import 'package:wger/models/workouts/routine.dart';
import 'package:wger/models/workouts/set_config_data.dart';
import 'package:wger/providers/gym_log_state.dart';

part 'gym_state.g.dart';

const DEFAULT_DURATION = Duration(hours: 5);

const PREFS_SHOW_EXERCISES = 'showExercisePrefs';
const PREFS_SHOW_TIMER = 'showTimerPrefs';
const PREFS_ALERT_COUNTDOWN = 'alertCountdownPrefs';
const PREFS_USE_COUNTDOWN_BETWEEN_SETS = 'useCountdownBetweenSetsPrefs';
const PREFS_COUNTDOWN_DURATION = 'countdownDurationSecondsPrefs';

/// In seconds
const DEFAULT_COUNTDOWN_DURATION = 180;
const MIN_COUNTDOWN_DURATION = 10;
const MAX_COUNTDOWN_DURATION = 1800;

enum PageType {
  start,
  set,
  session,
  workoutSummary,
}

enum SlotPageType {
  exerciseOverview,
  log,
  timer,
}

class PageEntry {
  final String uuid;

  final PageType type;

  /// Absolute page index
  final int pageIndex;

  final List<SlotPageEntry> slotPages;

  PageEntry({
    required this.type,
    required this.pageIndex,
    this.slotPages = const [],
    String? uuid,
  }) : uuid = uuid ?? uuidV4(),
       assert(
         slotPages.isEmpty || type == PageType.set,
         'SlotEntries can only be set for set pages',
       );

  PageEntry copyWith({
    String? uuid,
    PageType? type,
    int? pageIndex,
    List<SlotPageEntry>? slotPages,
  }) {
    return PageEntry(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      pageIndex: pageIndex ?? this.pageIndex,
      slotPages: slotPages ?? this.slotPages,
    );
  }

  List<Exercise> get exercises {
    final exerciseSet = <Exercise>{};
    for (final entry in slotPages) {
      exerciseSet.add(entry.setConfigData!.exercise);
    }
    return exerciseSet.toList();
  }

  // Whether all sub-pages (e.g. log pages) are marked as done.
  bool get allLogsDone =>
      slotPages.where((entry) => entry.type == SlotPageType.log).every((entry) => entry.logDone);

  @override
  String toString() => 'PageEntry(type: $type, pageIndex: $pageIndex)';
}

class SlotPageEntry {
  final String uuid;

  final SlotPageType type;

  /// index within a set for overview (e.g. "1 of 5 sets")
  final int setIndex;

  /// Absolute page index
  final int pageIndex;

  /// Whether the log page has been marked as done
  final bool logDone;

  /// The associated SetConfigData
  final SetConfigData? setConfigData;

  SlotPageEntry({
    required this.type,
    required this.pageIndex,
    required this.setIndex,
    this.setConfigData,
    this.logDone = false,
    String? uuid,
  }) : assert(
         type != SlotPageType.log || setConfigData != null,
         'You need to set setConfigData for SlotPageType.log',
       ),
       uuid = uuid ?? uuidV4();

  SlotPageEntry copyWith({
    String? uuid,
    SlotPageType? type,
    int? exerciseId,
    int? setIndex,
    int? pageIndex,
    SetConfigData? setConfigData,
    bool? logDone,
  }) {
    return SlotPageEntry(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      setIndex: setIndex ?? this.setIndex,
      pageIndex: pageIndex ?? this.pageIndex,
      setConfigData: setConfigData ?? this.setConfigData,
      logDone: logDone ?? this.logDone,
    );
  }

  @override
  String toString() =>
      'SlotPageEntry('
      'uuid: $uuid, '
      'type: $type, '
      'setIndex: $setIndex, '
      'pageIndex: $pageIndex, '
      'logDone: $logDone'
      ')';
}

class GymModeState {
  // Navigation data
  final bool isInitialized;

  final List<PageEntry> pages;
  final int currentPage;

  final TimeOfDay startTime;
  final DateTime validUntil;

  // User settings
  final bool showExercisePages;
  final bool showTimerPages;
  final bool alertOnCountdownEnd;
  final bool useCountdownBetweenSets;
  final Duration countdownDuration;

  // Routine data
  late final int dayId;
  late final int iteration;
  late final Routine routine;

  // Adaptation data (session-scoped, never persisted)
  final bool isAdaptedSession;
  final WorkoutAdaptation? adaptation;
  final Map<String, SetConfigData> originalSetConfigs;

  // Coach recommendation hints per exercise name (session-scoped)
  final Map<String, String> coachHints;

  GymModeState({
    this.isInitialized = false,
    this.pages = const [],
    this.currentPage = 0,

    this.showExercisePages = true,
    this.showTimerPages = true,
    this.alertOnCountdownEnd = true,
    this.useCountdownBetweenSets = false,
    this.countdownDuration = const Duration(seconds: DEFAULT_COUNTDOWN_DURATION),

    int? dayId,
    int? iteration,
    Routine? routine,

    this.isAdaptedSession = false,
    this.adaptation,
    this.originalSetConfigs = const {},
    this.coachHints = const {},

    DateTime? validUntil,
    TimeOfDay? startTime,
  }) : validUntil = validUntil ?? clock.now().add(DEFAULT_DURATION),
       startTime = startTime ?? TimeOfDay.fromDateTime(clock.now()) {
    if (dayId != null) {
      this.dayId = dayId;
    }

    if (iteration != null) {
      this.iteration = iteration;
    }

    if (routine != null) {
      this.routine = routine;
    }
  }

  GymModeState copyWith({
    // Navigation data
    bool? isInitialized,
    List<PageEntry>? pages,
    int? currentPage,

    // Routine data
    int? dayId,
    int? iteration,
    DateTime? validUntil,
    TimeOfDay? startTime,
    Routine? routine,

    // User settings
    bool? showExercisePages,
    bool? showTimerPages,
    bool? alertOnCountdownEnd,
    bool? useCountdownBetweenSets,
    int? countdownDuration,

    // Adaptation
    bool? isAdaptedSession,
    WorkoutAdaptation? adaptation,
    Map<String, SetConfigData>? originalSetConfigs,
    Map<String, String>? coachHints,
  }) {
    return GymModeState(
      isInitialized: isInitialized ?? this.isInitialized,
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,

      dayId: dayId ?? this.dayId,
      iteration: iteration ?? this.iteration,
      validUntil: validUntil ?? this.validUntil,
      startTime: startTime ?? this.startTime,
      routine: routine ?? this.routine,

      showExercisePages: showExercisePages ?? this.showExercisePages,
      showTimerPages: showTimerPages ?? this.showTimerPages,
      alertOnCountdownEnd: alertOnCountdownEnd ?? this.alertOnCountdownEnd,
      useCountdownBetweenSets: useCountdownBetweenSets ?? this.useCountdownBetweenSets,
      countdownDuration: Duration(
        seconds: countdownDuration ?? this.countdownDuration.inSeconds,
      ),

      isAdaptedSession: isAdaptedSession ?? this.isAdaptedSession,
      adaptation: adaptation ?? this.adaptation,
      originalSetConfigs: originalSetConfigs ?? this.originalSetConfigs,
      coachHints: coachHints ?? this.coachHints,
    );
  }

  int get totalPages {
    // Main pages (start, session, etc.)
    var count = pages.where((p) => p.type != PageType.set).length;

    // Add all other sub pages (sets, timer, etc.)
    count += pages.fold(0, (prev, e) => prev + e.slotPages.length);

    return count;
  }

  DayData get dayDataGym =>
      routine.dayDataGym.where((e) => e.iteration == iteration && e.day?.id == dayId).first;

  DayData get dayDataDisplay => routine.dayData.firstWhere(
    (e) => e.iteration == iteration && e.day?.id == dayId,
  );

  PageEntry? getPageByIndex([int? pageIndex]) {
    final index = pageIndex ?? currentPage;

    for (final page in pages) {
      for (final slotPage in page.slotPages) {
        if (slotPage.pageIndex == index) {
          return page;
        }
      }
    }
    return null;
  }

  SlotPageEntry? getSlotEntryPageByIndex([int? pageIndex]) {
    final index = pageIndex ?? currentPage;

    for (final slotPage in pages.expand((p) => p.slotPages)) {
      if (slotPage.pageIndex == index) {
        return slotPage;
      }
    }
    return null;
  }

  SlotPageEntry? getSlotPageByUUID(String uuid) {
    for (final slotPage in pages.expand((p) => p.slotPages)) {
      if (slotPage.uuid == uuid) {
        return slotPage;
      }
    }
    return null;
  }

  double get ratioCompleted {
    if (totalPages == 0) {
      return 0.0;
    }

    // Note: add 1 to currentPage to make it 1-based
    return (currentPage + 1) / totalPages;
  }

  @override
  String toString() {
    return 'GymState('
        'currentPage: $currentPage, '
        'validUntil: $validUntil '
        'startTime: $startTime, '
        'showExercisePages: $showExercisePages, '
        'showTimerPages: $showTimerPages, '
        ')';
  }
}

@Riverpod(keepAlive: true)
class GymStateNotifier extends _$GymStateNotifier {
  final _logger = Logger('GymStateNotifier');

  @override
  GymModeState build() {
    _logger.finer('Initializing GymStateNotifier');
    return GymModeState();
  }

  Future<void> loadPrefs() async {
    final prefs = PreferenceHelper.asyncPref;

    final showExercise = await prefs.getBool(PREFS_SHOW_EXERCISES);
    if (showExercise != null && showExercise != state.showExercisePages) {
      state = state.copyWith(showExercisePages: showExercise);
    }

    final showTimer = await prefs.getBool(PREFS_SHOW_TIMER);
    if (showTimer != null && showTimer != state.showTimerPages) {
      state = state.copyWith(showTimerPages: showTimer);
    }

    final alertOnCountdownEnd = await prefs.getBool(PREFS_ALERT_COUNTDOWN);
    if (alertOnCountdownEnd != null && alertOnCountdownEnd != state.alertOnCountdownEnd) {
      state = state.copyWith(alertOnCountdownEnd: alertOnCountdownEnd);
    }

    final useCountdownBetweenSets = await prefs.getBool(PREFS_USE_COUNTDOWN_BETWEEN_SETS);
    if (useCountdownBetweenSets != null &&
        useCountdownBetweenSets != state.useCountdownBetweenSets) {
      state = state.copyWith(useCountdownBetweenSets: useCountdownBetweenSets);
    }

    final defaultCountdownDurationSeconds = await prefs.getInt(PREFS_COUNTDOWN_DURATION);
    if (defaultCountdownDurationSeconds != null &&
        defaultCountdownDurationSeconds != state.countdownDuration.inSeconds) {
      state = state.copyWith(
        countdownDuration: defaultCountdownDurationSeconds,
      );
    }

    _logger.finer(
      'Loaded saved preferences: '
      'showExercise=$showExercise '
      'showTimer=$showTimer '
      'alertOnCountdownEnd=$alertOnCountdownEnd '
      'useCountdownBetweenSets=$useCountdownBetweenSets '
      'defaultCountdownDurationSeconds=$defaultCountdownDurationSeconds',
    );
  }

  Future<void> _savePrefs() async {
    final prefs = PreferenceHelper.asyncPref;
    await prefs.setBool(PREFS_SHOW_EXERCISES, state.showExercisePages);
    await prefs.setBool(PREFS_SHOW_TIMER, state.showTimerPages);
    await prefs.setBool(PREFS_ALERT_COUNTDOWN, state.alertOnCountdownEnd);
    await prefs.setBool(PREFS_USE_COUNTDOWN_BETWEEN_SETS, state.useCountdownBetweenSets);
    await prefs.setInt(
      PREFS_COUNTDOWN_DURATION,
      state.countdownDuration.inSeconds,
    );
    _logger.finer(
      'Saved preferences: '
      'showExercise=${state.showExercisePages} '
      'showTimer=${state.showTimerPages} '
      'alertOnCountdownEnd=${state.alertOnCountdownEnd} '
      'useCountdownBetweenSets=${state.useCountdownBetweenSets} '
      'defaultCountdownDuration=${state.countdownDuration.inSeconds}',
    );
  }

  /// Calculates the page entries
  void calculatePages() {
    var pageIndex = 0;

    final List<PageEntry> pages = [
      // Start page
      PageEntry(type: PageType.start, pageIndex: pageIndex),
    ];

    pageIndex++;
    for (final slotData in state.dayDataGym.slots) {
      final slotPageIndex = pageIndex;
      final slotEntries = <SlotPageEntry>[];
      int setIndex = 0;

      // exercise overview page
      if (state.showExercisePages) {
        // Add one overview page per exercise in the slot (e.g. for supersets)
        for (final exerciseId in slotData.exerciseIds) {
          final setConfig = slotData.setConfigs.firstWhereOrNull((c) => c.exerciseId == exerciseId);
          if (setConfig == null) {
            _logger.warning('Exercise with ID $exerciseId not found in slotData!!');
            continue;
          }

          slotEntries.add(
            SlotPageEntry(
              type: SlotPageType.exerciseOverview,
              setIndex: setIndex,
              pageIndex: pageIndex,
              setConfigData: setConfig,
            ),
          );
          pageIndex++;
        }
      }

      for (final config in slotData.setConfigs) {
        // Log page
        slotEntries.add(
          SlotPageEntry(
            type: SlotPageType.log,
            setIndex: setIndex,
            pageIndex: pageIndex,
            setConfigData: config,
          ),
        );
        pageIndex++;
        setIndex++;

        // Timer page
        if (state.showTimerPages) {
          slotEntries.add(
            SlotPageEntry(
              type: SlotPageType.timer,
              setIndex: setIndex,
              pageIndex: pageIndex,
              setConfigData: config,
            ),
          );
          pageIndex++;
        }
      }

      pages.add(
        PageEntry(
          type: PageType.set,
          pageIndex: slotPageIndex,
          slotPages: slotEntries,
        ),
      );
    }

    // Session and summary page
    pages.add(PageEntry(type: PageType.session, pageIndex: pageIndex));
    pages.add(PageEntry(type: PageType.workoutSummary, pageIndex: pageIndex + 1));

    state = state.copyWith(pages: pages);
    // print(readPageStructure());
    _logger.finer('Initialized ${state.pages.length} pages');
  }

  // Recalculates the indices of all pages
  void recalculateIndices() {
    var pageIndex = 0;
    final updatedPages = <PageEntry>[];

    for (final page in state.pages) {
      final slotPageIndex = pageIndex;
      var setIndex = 0;
      final updatedSlotPages = <SlotPageEntry>[];

      for (final slotPage in page.slotPages) {
        updatedSlotPages.add(
          slotPage.copyWith(
            pageIndex: pageIndex,
            setIndex: setIndex,
          ),
        );
        setIndex++;
        pageIndex++;
      }

      if (page.type != PageType.set) {
        pageIndex++;
      }

      updatedPages.add(
        page.copyWith(
          pageIndex: slotPageIndex,
          slotPages: updatedSlotPages,
        ),
      );
    }

    state = state.copyWith(pages: updatedPages);
    // _logger.fine(readPageStructure());
    _logger.fine('Recalculated page indices');
  }

  /// Reads the current page structure for debugging purposes
  String readPageStructure() {
    final List<String> out = [];
    out.add('GymModeState structure:');
    for (final page in state.pages) {
      out.add('Page ${page.pageIndex}: ${page.type}');
      for (final slotPage in page.slotPages) {
        out.add(
          '  SlotPage ${slotPage.pageIndex.toString().padLeft(2, ' ')} (set index ${slotPage.setIndex}): ${slotPage.type}',
        );
      }
    }

    return out.join('\n');
  }

  int initData(Routine routine, int dayId, int iteration) {
    final validUntil = state.validUntil;
    final currentPage = state.currentPage;

    final shouldReset =
        (!state.isInitialized || state.isInitialized && dayId != state.dayId) ||
        validUntil.isBefore(DateTime.now());
    if (shouldReset) {
      _logger.fine('Day ID mismatch or expired validUntil date. Resetting to page 0.');
    }
    final initialPage = shouldReset ? 0 : currentPage;

    // set dayId and initial page
    state = state.copyWith(
      isInitialized: true,
      dayId: dayId,
      routine: routine,
      iteration: iteration,
      currentPage: initialPage,
    );

    // Calculate the pages.
    // Note that this is only done if we need to reset, otherwise we keep the
    // existing state like the exercises that have already been done
    if (shouldReset) {
      calculatePages();
    }

    _logger.fine('Initialized GymModeState, initialPage=$initialPage');
    return initialPage;
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);

    // Ensure that there is a log entry for the current slot entry
    final slotEntryPage = state.getSlotEntryPageByIndex();
    if (slotEntryPage == null || slotEntryPage.setConfigData == null) {
      return;
    }

    final log = Log.fromSetConfigData(slotEntryPage.setConfigData!);
    final routineId = state.routine.id;
    if (routineId != null) {
      log.routineId = routineId;
    }
    log.iteration = state.iteration;

    // In adapted sessions, the setConfigData already holds adapted values
    // (weight/reps as defaults). Override the targets with original values
    // so the user sees what was originally planned.
    if (state.isAdaptedSession) {
      final originalConfig = _findOriginalConfig(slotEntryPage);
      if (originalConfig != null) {
        log.weightTarget = originalConfig.weight;
        log.repetitionsTarget = originalConfig.repetitions;
      }
    }

    ref.read(gymLogProvider.notifier).setLog(log);
  }

  SetConfigData? _findOriginalConfig(SlotPageEntry slotPage) {
    // Walk the page structure to find matching slotIndex-configIndex key
    int slotIndex = 0;
    for (final pageEntry in state.pages) {
      if (pageEntry.type != PageType.set) {
        continue;
      }

      int configIndex = 0;
      for (final sp in pageEntry.slotPages) {
        if (sp.type == SlotPageType.log) {
          if (sp.uuid == slotPage.uuid) {
            final key = '$slotIndex-$configIndex';
            return state.originalSetConfigs[key];
          }
          configIndex++;
        }
      }
      slotIndex++;
    }
    return null;
  }

  void setShowExercisePages(bool value) {
    state = state.copyWith(showExercisePages: value);
    calculatePages();
    _savePrefs();
  }

  void setShowTimerPages(bool value) {
    state = state.copyWith(showTimerPages: value);
    calculatePages();
    _savePrefs();
  }

  void setAlertOnCountdownEnd(bool value) {
    state = state.copyWith(alertOnCountdownEnd: value);
    _savePrefs();
  }

  void setUseCountdownBetweenSets(bool value) {
    state = state.copyWith(useCountdownBetweenSets: value);
    _savePrefs();
  }

  void setCountdownDuration(int duration) {
    state = state.copyWith(countdownDuration: duration);
    _savePrefs();
  }

  void setCoachHints(Map<String, String> hints) {
    state = state.copyWith(coachHints: hints);
  }

  void markSlotPageAsDone(String uuid, {required bool isDone}) {
    final slotPage = state.getSlotPageByUUID(uuid);
    if (slotPage == null) {
      _logger.warning('No slot page found for UUID $uuid');
      return;
    }

    final updatedSlotPage = slotPage.copyWith(logDone: isDone);

    final updatedPages = state.pages.map((page) {
      if (page.type != PageType.set) {
        return page;
      }

      final updatedSlotPages = page.slotPages.map((sp) {
        if (sp.uuid == uuid) {
          return updatedSlotPage;
        }
        return sp;
      }).toList();

      return page.copyWith(slotPages: updatedSlotPages);
    }).toList();

    state = state.copyWith(pages: updatedPages);
    _logger.fine('Set logDone=$isDone for slot page UUID $uuid');
  }

  void replaceExercises(
    String pageEntryUUID, {
    required int originalExerciseId,
    required Exercise newExercise,
  }) {
    final updatedPages = state.pages.map((page) {
      if (page.type != PageType.set) {
        return page;
      }

      if (page.uuid != pageEntryUUID) {
        return page;
      }

      final updatedSlotPages = page.slotPages.map((slotPage) {
        if (slotPage.setConfigData != null &&
            slotPage.setConfigData!.exercise.id == originalExerciseId) {
          final updatedSetConfigData = slotPage.setConfigData!.copyWith(
            exerciseId: newExercise.id ?? slotPage.setConfigData!.exerciseId,
            exercise: newExercise,
          );
          return slotPage.copyWith(setConfigData: updatedSetConfigData);
        }
        return slotPage;
      }).toList();

      return page.copyWith(slotPages: updatedSlotPages);
    }).toList();

    // TODO: this should not be done in-place!
    state.routine.replaceExercise(originalExerciseId, newExercise);
    state = state.copyWith(
      pages: updatedPages,
    );
    _logger.fine('Replaced exercise $originalExerciseId with ${newExercise.id}');
  }

  void addExerciseAfterPage(
    String pageEntryUUID, {
    required Exercise newExercise,
  }) {
    final List<PageEntry> pages = [];
    for (final page in state.pages) {
      pages.add(page);

      if (page.uuid == pageEntryUUID) {
        final firstSlotPage = page.slotPages.first;
        if (firstSlotPage.setConfigData == null) {
          continue;
        }
        final setConfigData = firstSlotPage.setConfigData!;

        final List<SlotPageEntry> newSlotPages = [];
        for (var i = 1; i <= 4; i++) {
          newSlotPages.add(
            SlotPageEntry(
              type: SlotPageType.log,
              pageIndex: 1,
              setIndex: 0,
              setConfigData: SetConfigData(
                textRepr: '-/-',
                exerciseId: newExercise.id ?? 0,
                exercise: newExercise,
                slotEntryId: setConfigData.slotEntryId,
              ),
            ),
          );
        }

        final newPage = PageEntry(type: PageType.set, pageIndex: 1, slotPages: newSlotPages);

        pages.add(newPage);
      }
    }

    state = state.copyWith(
      pages: pages,
    );

    recalculateIndices();
  }

  void applyAdaptation(WorkoutAdaptation adaptation) {
    if (!adaptation.hasModifications) {
      _logger.fine('No modifications in adaptation, skipping');
      return;
    }

    // Build a lookup: slotIndex → adapted SetConfigData list
    final adaptedSlots = adaptation.adaptedSlots;

    // Store original set configs keyed by "slotIndex-configIndex"
    final originals = <String, SetConfigData>{};

    final updatedPages = <PageEntry>[];
    int slotIndex = 0;

    for (final page in state.pages) {
      if (page.type != PageType.set) {
        updatedPages.add(page);
        if (page.type == PageType.start) {
          // slotIndex advances after start page (slots begin)
        }
        continue;
      }

      // Each PageType.set corresponds to a slot in order
      if (slotIndex >= adaptedSlots.length) {
        updatedPages.add(page);
        slotIndex++;
        continue;
      }

      final adaptedSlot = adaptedSlots[slotIndex];
      int configIndex = 0;

      final updatedSlotPages = <SlotPageEntry>[];
      for (final slotPage in page.slotPages) {
        if (slotPage.setConfigData != null &&
            slotPage.type == SlotPageType.log &&
            configIndex < adaptedSlot.setConfigs.length) {
          final key = '$slotIndex-$configIndex';
          originals[key] = slotPage.setConfigData!;

          final adaptedConfig = adaptedSlot.setConfigs[configIndex];
          updatedSlotPages.add(
            slotPage.copyWith(setConfigData: adaptedConfig),
          );
          configIndex++;
        } else {
          updatedSlotPages.add(slotPage);
        }
      }

      updatedPages.add(page.copyWith(slotPages: updatedSlotPages));
      slotIndex++;
    }

    // Build coach hints from modifications (exercise name → reason)
    final hints = <String, String>{};
    for (final mod in adaptation.modifications) {
      // Keep only the first (most important) hint per exercise
      hints.putIfAbsent(mod.exerciseName, () => mod.reason);
    }

    state = state.copyWith(
      pages: updatedPages,
      isAdaptedSession: true,
      adaptation: adaptation,
      originalSetConfigs: originals,
      coachHints: hints,
    );
    _logger.fine(
      'Applied adaptation with ${adaptation.modifications.length} modifications, '
      '${hints.length} coach hints',
    );
  }

  void clear() {
    _logger.fine('Clearing state');
    state = state.copyWith(
      isInitialized: false,
      pages: [],
      currentPage: 0,

      validUntil: clock.now().add(DEFAULT_DURATION),
      startTime: null,
    );
  }
}
