import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_item.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_plan.dart';
import 'package:wger/features/fitness_insights/domain/entities/coach_state.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/muscle_analysis.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_goal.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_score_breakdown.dart';
import 'package:wger/features/fitness_insights/presentation/providers/fitness_coach_v2_provider.dart';

/// Enhanced coaching screen (V2) that surfaces:
/// - Training goal selector
/// - Training score + breakdown
/// - Action plan (top 3)
/// - Muscle analysis per group
/// - Exercise insights
/// - Coach summary
///
/// Does NOT modify or replace the existing V1/legacy screens.
class FitnessCoachV2Screen extends ConsumerWidget {
  const FitnessCoachV2Screen({super.key});

  static const routeName = '/fitness-coach-v2';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightAsync = ref.watch(fitnessCoachV2Provider);
    final goal = ref.watch(trainingGoalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach V2'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(fitnessCoachV2Provider),
            tooltip: 'Reanalizar',
          ),
        ],
      ),
      body: insightAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 8),
                Text('Error: $error', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        data: (insight) => _buildBody(context, ref, insight, goal),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    FitnessInsight insight,
    TrainingGoal goal,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _goalSelector(context, ref, goal),
        const SizedBox(height: 16),
        _scoreCard(context, insight),
        if (insight.trainingScoreBreakdown != null) ...[
          const SizedBox(height: 12),
          _scoreBreakdown(context, insight.trainingScoreBreakdown!),
        ],
        if (insight.coachSummary != null) ...[
          const SizedBox(height: 16),
          _coachSummaryCard(context, insight),
        ],
        if (insight.actionPlan.actions.isNotEmpty) ...[
          const SizedBox(height: 20),
          _actionPlanSection(context, insight.actionPlan),
        ],
        if (insight.muscleAnalysis.isNotEmpty) ...[
          const SizedBox(height: 20),
          _muscleAnalysisSection(context, insight.muscleAnalysis),
        ],
        if (insight.exerciseInsights.isNotEmpty) ...[
          const SizedBox(height: 20),
          _exerciseInsightsSection(context, insight.exerciseInsights),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  // ------------------------------------------------------------------
  // Training Goal Selector
  // ------------------------------------------------------------------

  Widget _goalSelector(BuildContext context, WidgetRef ref, TrainingGoal current) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.flag_outlined, size: 20),
            const SizedBox(width: 8),
            Text('Objetivo:', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(width: 12),
            Expanded(
              child: SegmentedButton<TrainingGoal>(
                segments: TrainingGoal.values.map((g) {
                  return ButtonSegment(
                    value: g,
                    label: Text(_goalLabel(g), style: const TextStyle(fontSize: 11)),
                  );
                }).toList(),
                selected: {current},
                onSelectionChanged: (selected) {
                  ref.read(trainingGoalProvider.notifier).setGoal(selected.first);
                },
                showSelectedIcon: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // Score Card
  // ------------------------------------------------------------------

  Widget _scoreCard(BuildContext context, FitnessInsight insight) {
    final score = insight.trainingScore.toInt();
    Color color;
    if (score >= 70) {
      color = Colors.green;
    } else if (score >= 40) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  score.toString(),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(width: 8),
                Text('/100', style: TextStyle(fontSize: 16, color: Colors.grey[500])),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_statusIcon(insight.status), color: color, size: 18),
                const SizedBox(width: 4),
                Text(_statusLabel(insight.status), style: TextStyle(color: color, fontWeight: FontWeight.w600)),
              ],
            ),
            if (insight.trainingPhase != null) ...[
              const SizedBox(height: 4),
              Text(
                'Fase: ${_phaseLabel(insight.trainingPhase!)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // Score Breakdown
  // ------------------------------------------------------------------

  Widget _scoreBreakdown(BuildContext context, TrainingScoreBreakdown breakdown) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score Breakdown', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            _breakdownBar('Progreso', breakdown.progressScore, 40, Colors.green),
            _breakdownBar('Adherencia', breakdown.adherenceScore, 25, Colors.blue),
            _breakdownBar('Fatiga', breakdown.fatigueScore, 20, Colors.orange),
            _breakdownBar('Calidad datos', breakdown.dataQualityScore, 15, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _breakdownBar(String label, num value, num max, Color color) {
    final pct = max > 0 ? (value / max).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 12))),
          Expanded(
            child: LinearProgressIndicator(
              value: pct,
              color: color,
              backgroundColor: color.withAlpha(30),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text(
              '${value.toStringAsFixed(0)}/${max.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // Coach Summary
  // ------------------------------------------------------------------

  Widget _coachSummaryCard(BuildContext context, FitnessInsight insight) {
    final summary = insight.coachSummary!;
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(40),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology, size: 18),
                const SizedBox(width: 6),
                Text('Coach', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(summary.situation, style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(summary.directive),
            if (summary.note != null) ...[
              const SizedBox(height: 4),
              Text(summary.note!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // Action Plan (top 3)
  // ------------------------------------------------------------------

  Widget _actionPlanSection(BuildContext context, ActionPlan actionPlan) {
    final actions = actionPlan.actions.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.checklist, size: 20),
            const SizedBox(width: 6),
            Text('Plan de Acción', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        if (actionPlan.summary.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(actionPlan.summary, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ),
        ...actions.asMap().entries.map((entry) {
          final i = entry.key;
          final action = entry.value;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: _priorityColor(action.priority),
                child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              title: Text(action.reason, style: const TextStyle(fontSize: 13)),
              trailing: Chip(
                label: Text(_actionTypeLabel(action.type), style: const TextStyle(fontSize: 10)),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),
            ),
          );
        }),
      ],
    );
  }

  // ------------------------------------------------------------------
  // Muscle Analysis
  // ------------------------------------------------------------------

  Widget _muscleAnalysisSection(BuildContext context, Map<String, MuscleAnalysis> muscleAnalysis) {
    final sorted = muscleAnalysis.values.toList()
      ..sort((a, b) => a.status.index.compareTo(b.status.index));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.fitness_center, size: 20),
            const SizedBox(width: 6),
            Text('Análisis Muscular', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ...sorted.map((m) {
          Color statusColor;
          switch (m.status) {
            case MuscleTrainingStatus.optimal:
              statusColor = Colors.green;
            case MuscleTrainingStatus.undertraining:
              statusColor = Colors.orange;
            case MuscleTrainingStatus.overtraining:
              statusColor = Colors.red;
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: ListTile(
              dense: true,
              leading: Icon(Icons.circle, color: statusColor, size: 12),
              title: Text(m.muscleName),
              subtitle: Text(
                '${m.weeklySets.toStringAsFixed(1)} sets/sem · ${m.weeklyFrequency.toStringAsFixed(1)}x freq',
                style: const TextStyle(fontSize: 11),
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(20),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _muscleStatusLabel(m.status),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ------------------------------------------------------------------
  // Exercise Insights
  // ------------------------------------------------------------------

  Widget _exerciseInsightsSection(BuildContext context, List<ExerciseInsight> insights) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.insights, size: 20),
            const SizedBox(width: 6),
            Text('Ejercicios', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        ...insights.map((insight) {
          IconData icon;
          Color color;
          switch (insight.progressStatus) {
            case ExerciseProgressStatus.progressing:
              icon = Icons.trending_up;
              color = Colors.green;
            case ExerciseProgressStatus.regression:
              icon = Icons.trending_down;
              color = Colors.red;
            case ExerciseProgressStatus.stalled:
              icon = Icons.trending_flat;
              color = Colors.orange;
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 3),
            child: ExpansionTile(
              dense: true,
              leading: Icon(icon, color: color, size: 20),
              title: Text(insight.exerciseName, style: const TextStyle(fontSize: 13)),
              trailing: Text(
                '${(insight.e1rmChangePercent * 100).toStringAsFixed(1)}%',
                style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'e1RM: ${insight.previousE1rm.toStringAsFixed(1)} → ${insight.currentE1rm.toStringAsFixed(1)} kg',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${insight.sessionCount} sesiones · ${insight.totalVolume.toStringAsFixed(0)} kg vol.',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(insight.recommendation, style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ------------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------------

  String _goalLabel(TrainingGoal goal) {
    switch (goal) {
      case TrainingGoal.strength:
        return 'Fuerza';
      case TrainingGoal.hypertrophy:
        return 'Hipert.';
      case TrainingGoal.fatLoss:
        return 'Déficit';
      case TrainingGoal.maintenance:
        return 'Manten.';
    }
  }

  String _statusLabel(FitnessStatus status) {
    switch (status) {
      case FitnessStatus.goodProgress:
        return 'Buen progreso';
      case FitnessStatus.stalled:
        return 'Estancado';
      case FitnessStatus.overtraining:
        return 'Sobreentrenamiento';
      case FitnessStatus.inconsistent:
        return 'Inconsistente';
    }
  }

  IconData _statusIcon(FitnessStatus status) {
    switch (status) {
      case FitnessStatus.goodProgress:
        return Icons.check_circle_outline;
      case FitnessStatus.stalled:
        return Icons.pause_circle_outline;
      case FitnessStatus.overtraining:
        return Icons.warning_amber;
      case FitnessStatus.inconsistent:
        return Icons.help_outline;
    }
  }

  String _phaseLabel(TrainingPhase phase) {
    switch (phase) {
      case TrainingPhase.accumulation:
        return 'Acumulación';
      case TrainingPhase.intensification:
        return 'Intensificación';
      case TrainingPhase.deload:
        return 'Deload';
      case TrainingPhase.recovery:
        return 'Recuperación';
    }
  }

  String _muscleStatusLabel(MuscleTrainingStatus status) {
    switch (status) {
      case MuscleTrainingStatus.optimal:
        return 'Óptimo';
      case MuscleTrainingStatus.undertraining:
        return 'Bajo';
      case MuscleTrainingStatus.overtraining:
        return 'Exceso';
    }
  }

  Color _priorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _actionTypeLabel(ActionType type) {
    switch (type) {
      case ActionType.increaseWeight:
        return '↑ Peso';
      case ActionType.addReps:
        return '+ Reps';
      case ActionType.addSets:
        return '+ Sets';
      case ActionType.reduceVolume:
        return '↓ Vol.';
      case ActionType.deload:
        return 'Deload';
      case ActionType.maintain:
        return 'Mantener';
    }
  }
}
