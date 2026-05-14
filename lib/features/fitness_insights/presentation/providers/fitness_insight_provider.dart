import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wger/features/fitness_insights/domain/entities/subjective_feedback.dart';

part 'fitness_insight_provider.g.dart';

/// Stub provider for subjective feedback.
/// Returns an empty list until a real data source is wired in.
@riverpod
List<SubjectiveFeedback> subjectiveFeedback(Ref ref) {
  return [];
}
