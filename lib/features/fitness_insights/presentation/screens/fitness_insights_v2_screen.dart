import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_item.dart';
import 'package:wger/features/fitness_insights/domain/entities/action_plan.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/muscle_analysis.dart';
import 'package:wger/features/fitness_insights/presentation/providers/fitness_coach_v2_provider.dart';

class FitnessInsightsV2Screen extends ConsumerWidget {
  const FitnessInsightsV2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightAsync = ref.watch(fitnessCoachV2Provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Insights V2'),
      ),
      body: insightAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $error'),
          ),
        ),
        data: (insight) => _buildBody(context, insight),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FitnessInsight insight) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _scoreCard(context, insight),
        const SizedBox(height: 16),
        _statusSection(context, insight),
        if (insight.dataQualityScore < 60) ...[
          const SizedBox(height: 16),
          _dataProgressCard(context, insight),
        ],
        if (insight.actionPlan.actions.isNotEmpty) ...[
          const SizedBox(height: 24),
          _actionPlanSection(context, insight.actionPlan),
        ],
        if (insight.muscleAnalysis.isNotEmpty) ...[
          const SizedBox(height: 24),
          _muscleAnalysisSection(context, insight.muscleAnalysis),
        ],
        if (insight.exerciseInsights.isNotEmpty) ...[
          const SizedBox(height: 24),
          _exerciseInsightsSection(context, insight.exerciseInsights),
        ],
      ],
    );
  }

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
            Text(
              'Training Score',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              score.toString(),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _statusLabel(insight.status),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusSection(BuildContext context, FitnessInsight insight) {
    return Text(
      _statusMessage(insight),
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _actionPlanSection(BuildContext context, ActionPlan actionPlan) {
    final topActions = actionPlan.actions.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan de acción',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...topActions.map((action) => Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Icon(
                    _actionIcon(action.type),
                    color: action.priority == 1 ? Colors.orange : Colors.amber,
                  ),
                  title: Text(
                    action.reason,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  children: [
                    if (action.detailReason.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          action.detailReason,
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  IconData _actionIcon(ActionType type) {
    switch (type) {
      case ActionType.increaseWeight:
        return Icons.trending_up;
      case ActionType.addReps:
        return Icons.repeat;
      case ActionType.addSets:
        return Icons.add_circle_outline;
      case ActionType.reduceVolume:
        return Icons.trending_down;
      case ActionType.deload:
        return Icons.hotel;
      case ActionType.maintain:
        return Icons.check_circle_outline;
    }
  }

  Widget _muscleAnalysisSection(
    BuildContext context,
    Map<String, MuscleAnalysis> muscleAnalysis,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Muscle Analysis',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...muscleAnalysis.entries.map((entry) {
          final m = entry.value;
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
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(Icons.fitness_center, color: statusColor),
              title: Text(m.muscleName),
              subtitle: Text(
                '${m.weeklySets.toStringAsFixed(1)} sets/week · '
                '${m.weeklyFrequency.toStringAsFixed(1)}x freq',
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _muscleStatusLabel(m.status),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _exerciseInsightsSection(
    BuildContext context,
    List<ExerciseInsight> exerciseInsights,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercise Insights',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...exerciseInsights.map((insight) {
          IconData icon;
          Color color;
          String label;
          switch (insight.progressStatus) {
            case ExerciseProgressStatus.progressing:
              icon = Icons.trending_up;
              color = Colors.green;
              label = 'Progresando';
            case ExerciseProgressStatus.regression:
              icon = Icons.trending_down;
              color = Colors.red;
              label = 'Bajando';
            case ExerciseProgressStatus.stalled:
              icon = Icons.trending_flat;
              color = Colors.orange;
              label = 'Estancado';
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Icon(icon, color: color),
              title: Text(insight.exerciseName),
              subtitle: Text(label),
              trailing: Text(
                '${(insight.e1rmChangePercent * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          );
        }),
      ],
    );
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
        return 'Datos insuficientes';
    }
  }

  Widget _dataProgressCard(BuildContext context, FitnessInsight insight) {
    const requiredSessions = 3;
    const requiredExercises = 2;
    final sessions = insight.sessionCount.clamp(0, requiredSessions);
    final exercises = insight.uniqueExerciseCount.clamp(0, requiredExercises);
    final sessionsProgress = sessions / requiredSessions;
    final exercisesProgress = exercises / requiredExercises;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insights, color: Colors.blue[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Progreso hacia coaching completo',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _progressRow(
              context,
              label: 'Sesiones registradas',
              current: sessions,
              required_: requiredSessions,
              progress: sessionsProgress,
            ),
            const SizedBox(height: 12),
            _progressRow(
              context,
              label: 'Ejercicios distintos',
              current: exercises,
              required_: requiredExercises,
              progress: exercisesProgress,
            ),
            const SizedBox(height: 12),
            Text(
              sessionsProgress >= 1.0 && exercisesProgress >= 1.0
                  ? 'Casi listo — seguí entrenando para afinar las recomendaciones.'
                  : 'Registrá más sesiones para desbloquear coaching personalizado.',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressRow(
    BuildContext context, {
    required String label,
    required int current,
    required int required_,
    required double progress,
  }) {
    final done = progress >= 1.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text(
              '$current / $required_',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: done ? Colors.green : Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(
              done ? Colors.green : Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  String _statusMessage(FitnessInsight insight) {
    if (insight.dataQualityScore < 60) {
      return 'Estamos recopilando datos de tu entrenamiento.';
    } else if (insight.status == FitnessStatus.goodProgress) {
      return 'Tu entrenamiento va por buen camino. Seguí así.';
    } else if (insight.status == FitnessStatus.stalled) {
      return 'Algunos ejercicios están estancados. Revisá las recomendaciones.';
    } else if (insight.status == FitnessStatus.overtraining) {
      return 'Detectamos señales de sobreentrenamiento. Priorizá la recuperación.';
    } else {
      return 'Tu progreso es irregular. Intentá mantener una frecuencia constante.';
    }
  }

  String _muscleStatusLabel(MuscleTrainingStatus status) {
    switch (status) {
      case MuscleTrainingStatus.optimal:
        return 'Optimal';
      case MuscleTrainingStatus.undertraining:
        return 'Under';
      case MuscleTrainingStatus.overtraining:
        return 'Over';
    }
  }
}
