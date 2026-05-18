import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';

/// Repository contract for fetching training sessions.
/// Clean Architecture: defined in the data layer, consumed by the
/// presentation layer through a Riverpod provider.
abstract interface class ITrainingRepository {
  /// Fetches workout sessions and returns them as domain entities.
  /// If [routineId] is provided, only sessions for that routine are returned.
  Future<List<TrainingSession>> fetchSessions({int? routineId});
}
