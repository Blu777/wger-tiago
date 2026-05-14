import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';

/// Repository contract for fetching training sessions.
/// Clean Architecture: defined in the data layer, consumed by the
/// presentation layer through a Riverpod provider.
abstract interface class ITrainingRepository {
  /// Fetches all workout sessions and returns them as domain entities.
  Future<List<TrainingSession>> fetchSessions();
}
