import 'package:flutter_test/flutter_test.dart';
import 'package:wger/features/body_weight/domain/models/weight_entry.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_item.dart';
import 'package:wger/features/fitness_insights/domain/entities/coach_state.dart';
import 'package:wger/features/fitness_insights/domain/entities/coach_summary.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_performance.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_set.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/muscle_analysis.dart';
import 'package:wger/features/fitness_insights/domain/entities/subjective_feedback.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';
import 'package:wger/features/fitness_insights/domain/usecases/analyze_training.dart';

void main() {
  group('AnalyzeTraining', () {
    final analyze = AnalyzeTraining();

    test('returns inconsistent when no data', () {
      final result = analyze(
        weightEntries: [],
        sessions: [],
        feedback: [],
      );

      expect(result.status, FitnessStatus.inconsistent);
      expect(result.weeklyWeightChange, isNull);
      expect(result.isStrengthProgressing, isFalse);
      expect(result.trainingScore, 0);
    });

    test('returns goodProgress with perfect data', () {
      final now = DateTime.now();
      final weightEntries = [
        WeightEntry(weight: 80, date: now.subtract(const Duration(days: 28))),
        WeightEntry(weight: 79, date: now.subtract(const Duration(days: 14))),
        WeightEntry(weight: 78, date: now),
      ];

      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 105, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 82, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 110, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 84, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 115, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 86, repetitions: 8)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: weightEntries,
        sessions: sessions,
        feedback: [],
      );

      expect(result.status, FitnessStatus.goodProgress);
      expect(result.isStrengthProgressing, isTrue);
      expect(result.weeklyWeightChange, lessThan(0));
      expect(result.trainingScore, greaterThan(50));
    });

    test('detects stalled exercise via e1RM', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      expect(result.stalledExercises, contains('Bench'));
      expect(result.status, FitnessStatus.stalled);
    });

    test('detects regression via e1RM drop', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 150, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 140, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 120, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
      ];

      final feedback = [
        SubjectiveFeedback(date: now, fatigue: 9, energy: 2),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: feedback,
      );

      expect(result.droppedExercises, contains('Deadlift'));
      expect(result.fatigueLevel, greaterThanOrEqualTo(6));
      expect(result.status, FitnessStatus.overtraining);
    });

    test('computes e1RM correctly', () {
      // e1RM = weight * (1 + reps / 30)
      // 100kg x 5 reps = 100 * 1.1667 = 116.7
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 105, repetitions: 5)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      final squatInsight = result.exerciseInsights.firstWhere((e) => e.exerciseName == 'Squat');
      expect(squatInsight.currentE1rm, closeTo(105 * (1 + 5 / 30), 0.1));
      expect(squatInsight.previousE1rm, closeTo(100 * (1 + 5 / 30), 0.1));
      expect(squatInsight.progressStatus, ExerciseProgressStatus.progressing);
    });

    test('computes total exercise volumes via exerciseInsights', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [
              ExerciseSet(weight: 100, repetitions: 5),
              ExerciseSet(weight: 100, repetitions: 5),
            ]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 105, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      final squat = result.exerciseInsights.firstWhere((e) => e.exerciseName == 'Squat');
      expect(squat.totalVolume, equals(100 * 5 + 100 * 5 + 105 * 5));
    });

    test('computes data quality score', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      expect(result.dataQualityScore, lessThan(60));
    });

    test('detects fatigue trend from explicit feedback', () {
      final now = DateTime.now();
      final feedback = [
        SubjectiveFeedback(
          date: now.subtract(const Duration(days: 14)),
          fatigue: 4,
          energy: 7,
        ),
        SubjectiveFeedback(
          date: now.subtract(const Duration(days: 7)),
          fatigue: 6,
          energy: 5,
        ),
        SubjectiveFeedback(date: now, fatigue: 8, energy: 3),
      ];

      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 102, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 82, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 105, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 84, repetitions: 8)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: feedback,
      );

      expect(result.fatigueTrend, greaterThan(0));
      expect(result.recommendations, anyElement(contains('Fatiga')));
    });

    test('generates specific exercise recommendations', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      expect(result.recommendations, isNotEmpty);
      expect(result.recommendations, anyElement(contains('Sin mejora')));
    });

    test('strict status priority: overtraining beats stalled', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Bench', [ExerciseSet(weight: 70, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Bench', [ExerciseSet(weight: 60, repetitions: 8)]),
          ],
        ),
      ];

      final feedback = [
        SubjectiveFeedback(date: now, fatigue: 9, energy: 2),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: feedback,
      );

      expect(result.status, FitnessStatus.overtraining);
    });

    test('computes muscle analysis', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)], muscles: ['Quadriceps', 'Gluteus']),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 105, repetitions: 5)], muscles: ['Quadriceps', 'Gluteus']),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      expect(result.muscleAnalysis, contains('Quadriceps'));
      expect(result.muscleAnalysis['Quadriceps']!.status, MuscleTrainingStatus.undertraining);
    });

    test('computes training score', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 105, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 110, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 115, repetitions: 5)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      expect(result.trainingScore, greaterThanOrEqualTo(0));
      expect(result.trainingScore, lessThanOrEqualTo(100));
      expect(result.trainingScore, greaterThan(40));
    });

    test('generates action plan for regression', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 150, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 140, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 120, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      expect(result.actionPlan.actions, isNotEmpty);
      expect(result.actionPlan.actions.first.type, ActionType.reduceVolume);
      expect(result.actionPlan.actions.first.target, 'Deadlift');
    });

    test('generates action plan for stalled with high intensity', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Bench', [ExerciseSet(weight: 60, repetitions: 12)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Bench', [ExerciseSet(weight: 60, repetitions: 12)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Bench', [ExerciseSet(weight: 60, repetitions: 12)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Bench', [ExerciseSet(weight: 60, repetitions: 12)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      // 60kg x 12 reps → e1RM ~84kg. Single-set sessions have ~100% intensity.
      // Stalled + high intensity → reduce volume for recovery.
      expect(result.actionPlan.actions, isNotEmpty);
      expect(result.actionPlan.actions.first.type, ActionType.reduceVolume);
    });

    test('training score breakdown sums to total', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 105, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 110, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 115, repetitions: 5)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      final bd = result.trainingScoreBreakdown;
      expect(bd, isNotNull);
      expect(
        bd!.progressScore + bd.adherenceScore + bd.fatigueScore + bd.dataQualityScore,
        closeTo(bd.total, 0.01),
      );
    });

    test('limits action plan to max 3 actions', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 80, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 70, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 60, repetitions: 8)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
            _buildPerf('Bench', [ExerciseSet(weight: 50, repetitions: 8)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      expect(result.actionPlan.actions.length, lessThanOrEqualTo(3));
    });

    test('detects deload phase with high fatigue and regression', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 150, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 140, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 120, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
      ];

      final feedback = [
        SubjectiveFeedback(date: now, fatigue: 9, energy: 2),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: feedback,
      );

      expect(result.trainingPhase, TrainingPhase.deload);
      expect(result.coachSummary, isNotNull);
      expect(result.coachSummary!.situation, contains('deload'));
    });

    test('detects intensification phase with progress', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 105, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 110, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 115, repetitions: 5)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      expect(result.trainingPhase, TrainingPhase.intensification);
      expect(result.coachSummary!.directive, contains('subir peso'));
    });

    test('avoids repeating same action with previousState', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
      ];

      final previousState = CoachState(
        lastActions: [
          ActionItem(
            type: ActionType.increaseWeight,
            target: 'Squat',
            value: 2,
            reason: 'test',
          ),
        ],
      );

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
        previousState: previousState,
      );

      // The stalled + low-intensity increaseWeight action should be skipped
      // because it was already applied last week
      final squatActions = result.actionPlan.actions.where((a) => a.target == 'Squat');
      if (squatActions.isNotEmpty) {
        expect(squatActions.first.type, isNot(ActionType.increaseWeight));
      }
    });

    test('persists coachState with lastPhase and lastActions', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 105, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Squat', [ExerciseSet(weight: 110, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Squat', [ExerciseSet(weight: 115, repetitions: 5)]),
          ],
        ),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: [],
      );

      expect(result.coachState, isNotNull);
      expect(result.coachState!.lastPhase, isNotNull);
      expect(result.coachState!.lastActions.length, lessThanOrEqualTo(2));
    });

    test('deload action plan reduces volume 40%', () {
      final now = DateTime.now();
      final sessions = [
        _buildSession(
          now.subtract(const Duration(days: 21)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 150, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 14)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 140, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now.subtract(const Duration(days: 7)),
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 120, repetitions: 5)]),
          ],
        ),
        _buildSession(
          now,
          [
            _buildPerf('Deadlift', [ExerciseSet(weight: 100, repetitions: 5)]),
          ],
        ),
      ];

      final feedback = [
        SubjectiveFeedback(date: now, fatigue: 9, energy: 2),
      ];

      final result = analyze(
        weightEntries: [],
        sessions: sessions,
        feedback: feedback,
      );

      expect(result.trainingPhase, TrainingPhase.deload);
      expect(result.actionPlan.actions, isNotEmpty);
      expect(result.actionPlan.actions.first.type, ActionType.deload);
      expect(result.actionPlan.actions.first.value, 40);
    });
  });
}

TrainingSession _buildSession(DateTime date, List<ExercisePerformance> exercises) {
  return TrainingSession(
    date: date,
    exercises: exercises,
    impression: 2,
  );
}

ExercisePerformance _buildPerf(String name, List<ExerciseSet> sets, {List<String> muscles = const []}) {
  return ExercisePerformance(
    exerciseId: name.hashCode,
    exerciseName: name,
    sets: sets,
    muscleNames: muscles,
  );
}
