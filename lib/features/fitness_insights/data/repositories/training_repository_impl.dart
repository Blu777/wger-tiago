import 'package:wger/features/fitness_insights/data/mappers/training_session_mapper.dart';
import 'package:wger/features/fitness_insights/data/repositories/training_repository.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';
import 'package:wger/models/workouts/session.dart';
import 'package:wger/providers/base_provider.dart';

/// Concrete implementation of [ITrainingRepository].
/// Fetches raw [WorkoutSession] objects directly from the wger API,
/// then maps them to clean domain entities via [mapWorkoutSession].
class TrainingRepositoryImpl implements ITrainingRepository {
  final WgerBaseProvider _baseProvider;

  static const _sessionUrlPath = 'workoutsession';

  TrainingRepositoryImpl(this._baseProvider);

  @override
  Future<List<TrainingSession>> fetchSessions() async {
    final data = await _baseProvider.fetchPaginated(
      _baseProvider.makeUrl(_sessionUrlPath),
    );

    final sessions = data.map((json) => WorkoutSession.fromJson(json)).toList();
    return sessions.map(mapWorkoutSession).toList();
  }
}
