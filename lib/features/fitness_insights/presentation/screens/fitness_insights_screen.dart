import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:wger/features/body_weight/presentation/providers/body_weight_provider.dart';
import 'package:wger/features/fitness_insights/data/mappers/training_session_mapper.dart';
import 'package:wger/features/fitness_insights/domain/entities/exercise_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/domain/entities/training_session.dart';
import 'package:wger/features/fitness_insights/domain/usecases/analyze_training.dart';
import 'package:wger/providers/routines.dart';

/// Pantalla de resumen de coaching. Muestra solo lo esencial:
/// - Score card con color
/// - Estado general en lenguaje humano
/// - Recomendaciones prácticas
/// - Ejercicios con progreso (solo si hay data suficiente)
class FitnessInsightsScreen extends ConsumerStatefulWidget {
  const FitnessInsightsScreen({super.key});

  @override
  ConsumerState<FitnessInsightsScreen> createState() => _FitnessInsightsScreenState();
}

class _FitnessInsightsScreenState extends ConsumerState<FitnessInsightsScreen> {
  Future<FitnessInsight>? _insightFuture;
  List<TrainingSession> _sessions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _insightFuture ??= _loadInsight();
  }

  Future<FitnessInsight> _loadInsight() async {
    final routines = provider.Provider.of<RoutinesProvider>(context, listen: false);

    if (routines.items.isEmpty || routines.items.every((r) => r.sessions.isEmpty)) {
      await routines.fetchAndSetAllRoutinesFull();
    }

    final sessions = <TrainingSession>[];
    for (final routine in routines.items) {
      for (final sessionApi in routine.sessions) {
        sessionApi.session.logs = sessionApi.logs;
        sessions.add(mapWorkoutSession(sessionApi.session));
      }
    }
    _sessions = sessions;

    final weights = await ref.read(bodyWeightProvider.future);

    final analyze = AnalyzeTraining();
    return analyze(
      weightEntries: weights,
      sessions: sessions,
      feedback: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Entrenamiento'),
      ),
      body: FutureBuilder<FitnessInsight>(
        future: _insightFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          final insight = snapshot.data!;
          return _buildBody(insight);
        },
      ),
    );
  }

  Widget _buildBody(FitnessInsight insight) {
    final lowData = insight.dataQualityScore < 60;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _scoreCard(insight),
        const SizedBox(height: 16),
        _statusMessage(insight, lowData),
        if (lowData) ...[
          const SizedBox(height: 24),
          _infoCard(
            icon: Icons.fitness_center,
            title: 'Datos insuficientes',
            body: 'Registrá al menos 3 sesiones y 2 ejercicios distintos '
                'para obtener coaching preciso.',
          ),
        ] else ...[
          if (insight.recommendations.isNotEmpty) ...[
            const SizedBox(height: 24),
            _sectionTitle('Recomendaciones'),
            ...insight.recommendations.take(3).map(_recommendationTile),
          ],
          if (insight.exerciseInsights.isNotEmpty) ...[
            const SizedBox(height: 24),
            _sectionTitle('Progreso por ejercicio'),
            ...insight.exerciseInsights.take(5).map(_exerciseTile),
          ],
        ],
      ],
    );
  }

  Widget _scoreCard(FitnessInsight insight) {
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
              insight.status == FitnessStatus.goodProgress
                  ? 'Buen progreso'
                  : insight.status == FitnessStatus.stalled
                      ? 'Estancado'
                      : insight.status == FitnessStatus.overtraining
                          ? 'Sobreentrenamiento'
                          : 'Datos insuficientes',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusMessage(FitnessInsight insight, bool lowData) {
    String message;
    if (lowData) {
      message = 'Todavía no tenemos suficientes datos para evaluar tu entrenamiento.';
    } else if (insight.status == FitnessStatus.goodProgress) {
      message = 'Tu entrenamiento va por buen camino. Seguí así.';
    } else if (insight.status == FitnessStatus.stalled) {
      message = 'Algunos ejercicios están estancados. Revisá las recomendaciones.';
    } else if (insight.status == FitnessStatus.overtraining) {
      message = 'Detectamos señales de sobreentrenamiento. Priorizá la recuperación.';
    } else {
      message = 'Tu progreso es irregular. Intentá mantener una frecuencia constante.';
    }

    return Text(
      message,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(body, style: TextStyle(color: Colors.grey[700])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _recommendationTile(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () => _showRecommendationDetail(text),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb_outline, size: 20, color: Colors.amber),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }

  Widget _exerciseTile(ExerciseInsight insight) {
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
        onTap: () => _showExerciseDetail(insight),
      ),
    );
  }

  void _showRecommendationDetail(String text) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              controller: scrollController,
              children: [
                Text(
                  'Recomendación',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(text),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showExerciseDetail(ExerciseInsight insight) {
    final history = _sessions
        .where(
          (s) => s.exercises.any((e) => e.exerciseName == insight.exerciseName),
        )
        .toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              controller: scrollController,
              children: [
                Text(
                  insight.exerciseName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      insight.progressStatus == ExerciseProgressStatus.progressing
                          ? Icons.trending_up
                          : insight.progressStatus == ExerciseProgressStatus.regression
                              ? Icons.trending_down
                              : Icons.trending_flat,
                      color: insight.progressStatus == ExerciseProgressStatus.progressing
                          ? Colors.green
                          : insight.progressStatus == ExerciseProgressStatus.regression
                              ? Colors.red
                              : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(insight.e1rmChangePercent * 100).toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Recomendación',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(insight.recommendation),
                const SizedBox(height: 24),
                Text(
                  'Historial',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                if (history.isEmpty)
                  const Text('No hay sesiones registradas para este ejercicio.')
                else
                  ...history.map((session) {
                    final performance = session.exercises
                        .firstWhere((e) => e.exerciseName == insight.exerciseName);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${session.date.day}/${session.date.month}/${session.date.year}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            ...performance.sets.map((set) {
                              return Text('${set.weight} x ${set.repetitions}');
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
    );
  }
}
