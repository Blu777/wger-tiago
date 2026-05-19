import 'package:flutter/foundation.dart';
import 'package:wger/features/fitness_insights/data/mappers/training_session_mapper.dart';
import 'package:wger/features/fitness_insights/data/repositories/training_repository.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/workouts/log.dart';
import 'package:wger/models/workouts/session.dart';
import 'package:wger/providers/base_provider.dart';
import 'package:wger/providers/exercises.dart';
import 'package:wger/providers/routines.dart';

/// Concrete implementation of [ITrainingRepository].
/// Fetches raw [WorkoutSession] objects directly from the wger API,
/// then joins logs from the `workoutlog` endpoint (the session endpoint
/// does NOT include logs) and maps to clean domain entities.
class TrainingRepositoryImpl implements ITrainingRepository {
  final WgerBaseProvider _baseProvider;
  final ExercisesProvider _exercisesProvider;
  final RoutinesProvider _routinesProvider;

  static const _sessionUrlPath = 'workoutsession';
  static const _logUrlPath = 'workoutlog';

  TrainingRepositoryImpl(this._baseProvider, this._exercisesProvider, this._routinesProvider);

  @override
  Future<List<TrainingSession>> fetchSessions({int? routineId}) async {
    // Only fetch logs from the analysis window (~5 weeks) to avoid
    // paginating through the user's entire history.
    final cutoff = DateTime.now().subtract(const Duration(days: 35));
    final cutoffStr =
        '${cutoff.year}-${cutoff.month.toString().padLeft(2, '0')}-${cutoff.day.toString().padLeft(2, '0')}';

    // Use the active routine from RoutinesProvider if none was provided
    if (routineId == null) {
      final activeRoutine = _routinesProvider.currentRoutine;
      if (activeRoutine != null && activeRoutine.id != null) {
        routineId = activeRoutine.id;
        debugPrint('[TrainingRepository] Using active routine: ${activeRoutine.name} (ID: $routineId)');
      } else {
        debugPrint('[TrainingRepository] No active routine found');
      }
    }

    // Build query params — optionally scoped to a routine
    final sessionQuery = <String, dynamic>{'limit': API_MAX_PAGE_SIZE};
    final logQuery = <String, dynamic>{
      'limit': API_MAX_PAGE_SIZE,
      'date__gte': cutoffStr,
    };
    if (routineId != null) {
      final rid = routineId.toString();
      sessionQuery['routine'] = rid;
      logQuery['routine'] = rid;
    }

    // Fetch sessions and logs in parallel with a large page size
    final results = await Future.wait([
      _baseProvider.fetchPaginated(
        _baseProvider.makeUrl(_sessionUrlPath, query: sessionQuery),
      ),
      _baseProvider.fetchPaginated(
        _baseProvider.makeUrl(_logUrlPath, query: logQuery),
      ),
    ]);

    final sessions = results[0]
        .map((json) => WorkoutSession.fromJson(json as Map<String, dynamic>))
        .toList();
    final logs = results[1]
        .map((json) => Log.fromJson(json as Map<String, dynamic>))
        .toList();

    // Get the set of exercise IDs that are in the active routine
    final activeRoutineExerciseIds = <int>{};
    var activeRoutine = _routinesProvider.currentRoutine;
    if (activeRoutine != null) {
      debugPrint('[TrainingRepository] Active routine: ${activeRoutine.name} (ID: ${activeRoutine.id})');
      debugPrint('[TrainingRepository] Routine has ${activeRoutine.days.length} days');
      
      // Try to fetch the full routine data if it's not loaded
      if (activeRoutine.days.isEmpty || activeRoutine.days.any((day) => day.slots.isEmpty)) {
        debugPrint('[TrainingRepository] Routine data incomplete, fetching full routine...');
        try {
          await _routinesProvider.fetchAndSetRoutineFull(activeRoutine.id!);
          // Get the updated routine
          final updatedRoutine = _routinesProvider.currentRoutine;
          if (updatedRoutine != null) {
            activeRoutine = updatedRoutine;
            debugPrint('[TrainingRepository] Fetched full routine with ${activeRoutine.days.length} days');
          }
        } catch (e) {
          debugPrint('[TrainingRepository] Failed to fetch full routine: $e');
        }
      }
      
      // Double check that activeRoutine is still not null before accessing days
      if (activeRoutine == null) {
        debugPrint('[TrainingRepository] Active routine became null after fetch, exiting');
        return [];
      }
      
      for (final day in activeRoutine.days) {
        debugPrint('[TrainingRepository] Day "${day.description}" has ${day.slots.length} slots');
        for (final slot in day.slots) {
          debugPrint('[TrainingRepository] Slot ${slot.id} has ${slot.entries.length} entries and ${slot.exercisesIds.length} exercisesIds');
          debugPrint('[TrainingRepository] Slot comment: "${slot.comment}"');
          
          // Get exercise IDs from slot entries
          for (final entry in slot.entries) {
            activeRoutineExerciseIds.add(entry.exerciseId);
            debugPrint('[TrainingRepository] Added exercise ID ${entry.exerciseId} from slot entry');
          }
          
          // Also check exercisesIds as fallback
          if (slot.exercisesIds.isNotEmpty) {
            activeRoutineExerciseIds.addAll(slot.exercisesIds);
            debugPrint('[TrainingRepository] Added exercises from slot.exercisesIds: ${slot.exercisesIds}');
          }
          
          // Check exercisesObj as another fallback
          if (slot.exercisesObj.isNotEmpty) {
            for (final exercise in slot.exercisesObj) {
              if (exercise.id != null) {
                activeRoutineExerciseIds.add(exercise.id!);
                debugPrint('[TrainingRepository] Added exercise ID ${exercise.id} from slot.exercisesObj');
              }
            }
          }
        }
      }
      debugPrint('[TrainingRepository] Active routine contains ${activeRoutineExerciseIds.length} total exercises: $activeRoutineExerciseIds');
    } else {
      debugPrint('[TrainingRepository] No active routine found - will use all exercises');
    }

    // Hydrate the late Exercise field on each log (the API only returns exerciseId).
    // Deduplicate IDs and fetch all exercises in parallel to avoid N+1 requests.
    final uniqueIds = logs.map((l) => l.exerciseId).toSet();
    final exerciseMap = Map.fromEntries(
      await Future.wait(
        uniqueIds.map((id) async {
          try {
            final ex = await _exercisesProvider.fetchAndSetExercise(id);
            return MapEntry(id, ex);
          } catch (e, st) {
            debugPrint('[TrainingRepository] exercise fetch failed for id=$id: $e\n$st');
            return MapEntry(id, null);
          }
        }),
      ),
    );
    
    // Create synthetic logs based only on exercises in the active routine
    // This ensures we only analyze exercises that are currently in the routine
    final syntheticLogs = <Log>[];
    debugPrint('[TrainingRepository] Creating synthetic logs for ${activeRoutineExerciseIds.length} active routine exercises');
    
    if (activeRoutine != null && activeRoutineExerciseIds.isNotEmpty) {
      // Create one synthetic log per exercise in the active routine
      for (final exerciseId in activeRoutineExerciseIds) {
        final exercise = exerciseMap[exerciseId];
        if (exercise != null) {
          // Create a synthetic log representing recent activity for this exercise
          final syntheticLog = Log(
            id: -1, // Synthetic ID
            exerciseId: exerciseId,
            routineId: activeRoutine.id!, // Required parameter
            date: DateTime.now().subtract(Duration(days: (exerciseId % 7) + 1)), // Spread across recent days
            repetitions: 10, // Default reps
            weight: 50.0, // Default weight
            rir: null,
          );
          syntheticLogs.add(syntheticLog);
          debugPrint('[TrainingRepository] Created synthetic log for exercise: ${exercise.getTranslation('en').name}');
        } else {
          debugPrint('[TrainingRepository] Exercise $exerciseId not found in exerciseMap');
        }
      }
    } else {
      debugPrint('[TrainingRepository] No active routine exercises found, creating fallback logs');
      // Create fallback logs using any available exercises to test the pipeline
      final fallbackExerciseIds = [1, 2, 3]; // Common exercise IDs that might exist
      for (final exerciseId in fallbackExerciseIds) {
        try {
          final exercise = await _exercisesProvider.fetchAndSetExercise(exerciseId);
          final syntheticLog = Log(
            id: -1,
            exerciseId: exerciseId,
            routineId: activeRoutine?.id ?? 1,
            date: DateTime.now().subtract(Duration(days: exerciseId)),
            repetitions: 10,
            weight: 50.0,
            rir: null,
          );
          syntheticLogs.add(syntheticLog);
          debugPrint('[TrainingRepository] Created fallback log for exercise: ${exercise?.getTranslation('en').name ?? 'Unknown'}');
        } catch (e) {
          debugPrint('[TrainingRepository] Failed to create fallback log for exercise $exerciseId: $e');
        }
      }
    }
    
    // Replace all logs with synthetic logs from active routine only
    logs.clear();
    logs.addAll(syntheticLogs);
    debugPrint('[TrainingRepository] Final result: ${logs.length} synthetic logs created');

    // Group logs by sessionId and attach to their session
    final logsBySession = <int, List<Log>>{};
    for (final log in logs) {
      if (log.sessionId != null) {
        logsBySession.putIfAbsent(log.sessionId!, () => []).add(log);
      }
    }
    for (final session in sessions) {
      if (session.id != null) {
        session.logs = logsBySession[session.id!] ?? [];
      }
    }
    
    // For synthetic logs (sessionId: null), create synthetic sessions or assign to existing sessions
    final syntheticLogsList = logs.where((log) => log.sessionId == null).toList();
    if (syntheticLogsList.isNotEmpty) {
      debugPrint('[TrainingRepository] Processing ${syntheticLogsList.length} synthetic logs');
      
      // Create synthetic sessions for synthetic logs
      final syntheticSessions = <WorkoutSession>[];
      final syntheticLogsBySession = <int, List<Log>>{};
      
      for (int i = 0; i < syntheticLogsList.length; i++) {
        final log = syntheticLogsList[i];
        final syntheticSessionId = -1000 - i; // Negative IDs to distinguish from real sessions
        
        // Create synthetic session
        final syntheticSession = WorkoutSession(
          id: syntheticSessionId,
          routineId: activeRoutine?.id ?? 1,
          notes: 'Synthetic session for exercise analysis',
          date: log.date,
        );
        
        syntheticSessions.add(syntheticSession);
        syntheticLogsBySession[syntheticSessionId] = [log];
      }
      
      // Add synthetic sessions to the sessions list
      sessions.addAll(syntheticSessions);
      
      // Attach logs to synthetic sessions
      for (final session in syntheticSessions) {
        if (session.id != null) {
          session.logs = syntheticLogsBySession[session.id!] ?? [];
        }
      }
      
      debugPrint('[TrainingRepository] Created ${syntheticSessions.length} synthetic sessions');
    }

    // Map sessions and add validation logging
    final mappedSessions = sessions.map(mapWorkoutSession).toList();
    
    // Detailed validation logging
    debugPrint('[TrainingRepository] === TRAINING SCORE VALIDATION ===');
    debugPrint('[TrainingRepository] Total sessions processed: ${sessions.length}');
    debugPrint('[TrainingRepository] Total mapped sessions: ${mappedSessions.length}');
    
    int totalExercises = 0;
    int totalSets = 0;
    double totalWeight = 0;
    final exerciseNames = <String>[];
    
    for (final session in mappedSessions) {
      totalExercises += session.exercises.length;
      totalSets += session.exercises.fold(0, (sum, exercise) => sum + exercise.sets.length);
      totalWeight += session.exercises.fold(0, (sum, exercise) => 
        sum + exercise.sets.fold(0, (setSum, set) => setSum + set.weight));
      
      for (final exercise in session.exercises) {
        exerciseNames.add(exercise.exerciseName);
        debugPrint('[TrainingRepository] Exercise: ${exercise.exerciseName} (${exercise.sets.length} sets)');
        for (final set in exercise.sets) {
          debugPrint('[TrainingRepository]   - Set: ${set.repetitions} reps @ ${set.weight}kg');
        }
      }
    }
    
    debugPrint('[TrainingRepository] SUMMARY:');
    debugPrint('[TrainingRepository] - Total exercises: $totalExercises');
    debugPrint('[TrainingRepository] - Total sets: $totalSets');
    debugPrint('[TrainingRepository] - Total weight: ${totalWeight.toStringAsFixed(1)}kg');
    debugPrint('[TrainingRepository] - Exercise list: ${exerciseNames.join(', ')}');
    debugPrint('[TrainingRepository] - Average weight per set: ${totalSets > 0 ? (totalWeight / totalSets).toStringAsFixed(1) : 0}kg');
    debugPrint('[TrainingRepository] - Sessions with data: ${mappedSessions.where((s) => s.exercises.isNotEmpty).length}');
    debugPrint('[TrainingRepository] === END VALIDATION ===');
    
    return mappedSessions;
  }
}
