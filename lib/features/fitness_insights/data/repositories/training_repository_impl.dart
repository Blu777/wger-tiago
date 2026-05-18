import 'package:flutter/foundation.dart';
import 'package:wger/features/fitness_insights/data/mappers/training_session_mapper.dart';
import 'package:wger/features/fitness_insights/data/repositories/training_repository.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/workouts/log.dart';
import 'package:wger/models/workouts/session.dart';
import 'package:wger/providers/base_provider.dart';
import 'package:wger/providers/exercises.dart';

/// Concrete implementation of [ITrainingRepository].
/// Fetches raw [WorkoutSession] objects directly from the wger API,
/// then joins logs from the `workoutlog` endpoint (the session endpoint
/// does NOT include logs) and maps to clean domain entities.
class TrainingRepositoryImpl implements ITrainingRepository {
  final WgerBaseProvider _baseProvider;
  final ExercisesProvider _exercisesProvider;

  static const _sessionUrlPath = 'workoutsession';
  static const _logUrlPath = 'workoutlog';

  TrainingRepositoryImpl(this._baseProvider, this._exercisesProvider);

  @override
  Future<List<TrainingSession>> fetchSessions({int? routineId}) async {
    // Only fetch logs from the analysis window (~5 weeks) to avoid
    // paginating through the user's entire history.
    final cutoff = DateTime.now().subtract(const Duration(days: 35));
    final cutoffStr =
        '${cutoff.year}-${cutoff.month.toString().padLeft(2, '0')}-${cutoff.day.toString().padLeft(2, '0')}';

    // Auto-detect the active routine if none was provided
    if (routineId == null) {
      try {
        final routines = await _baseProvider.fetchPaginated(
          _baseProvider.makeUrl('routine', query: {
            'limit': '1',
            'ordering': '-creation_date',
            'is_template': 'false',
          }),
        );
        if (routines.isNotEmpty) {
          routineId = routines.first['id'] as int?;
        }
      } catch (e, st) {
        debugPrint('[TrainingRepository] routine fetch failed: $e\n$st');
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
    for (final log in logs) {
      final exercise = exerciseMap[log.exerciseId];
      if (exercise != null) {
        log.exerciseBase = exercise;
      }
    }

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

    return sessions.map(mapWorkoutSession).toList();
  }
}
