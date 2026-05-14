import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';
import 'package:wger/features/fitness_insights/presentation/providers/fitness_insight_provider.dart';

/// Temporary debug screen that renders the full state of the fitness insight engine.
/// No styling — purely functional visualization.
class FitnessInsightsScreen extends ConsumerWidget {
  const FitnessInsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncInsight = ref.watch(fitnessInsightProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Insights (Debug)'),
      ),
      body: asyncInsight.when(
        data: (insight) => _buildBody(insight),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $err\n\n$stack'),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(FitnessInsight insight) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // --- 1. Header ---
        _sectionTitle('Header'),
        _kv('Training Score', insight.trainingScore.toStringAsFixed(1)),
        _kv('Status', insight.status.name),
        _kv('Fatigue Level', insight.fatigueLevel != null
            ? '${insight.fatigueLevel!.toStringAsFixed(1)} / 10'
            : 'N/A'),

        const Divider(),

        // --- 2. Action Plan ---
        _sectionTitle('Action Plan'),
        if (insight.actionPlan.actions.isEmpty)
          _kv('Actions', 'None')
        else
          ...insight.actionPlan.actions.take(3).map((a) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _kv('Type', a.type.name),
                  _kv('Target', a.target),
                  _kv('Value', a.value.toString()),
                  _kv('Reason', a.reason),
                  const SizedBox(height: 8),
                ],
              )),

        const Divider(),

        // --- 3. Exercise Insights ---
        _sectionTitle('Exercise Insights'),
        if (insight.exerciseInsights.isEmpty) _kv('Insights', 'None'),
        ...insight.exerciseInsights.map((e) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kv('Exercise', e.exerciseName),
                _kv('Progress', e.progressStatus.name),
                _kv('e1RM Change', '${(e.e1rmChangePercent * 100).toStringAsFixed(1)}%'),
                _kv('Recommendation', e.recommendation),
                const SizedBox(height: 8),
              ],
            )),

        const Divider(),

        // --- 4. Muscle Analysis ---
        _sectionTitle('Muscle Analysis'),
        if (insight.muscleAnalysis.isEmpty) _kv('Muscles', 'None'),
        ...insight.muscleAnalysis.values.map((m) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _kv('Muscle', m.muscleName),
                _kv('Weekly Sets', m.weeklySets.toStringAsFixed(1)),
                _kv('Status', m.status.name),
                const SizedBox(height: 8),
              ],
            )),

        const Divider(),

        // --- 5. Debug Info ---
        _sectionTitle('Debug Info'),
        _kv('Data Quality', insight.dataQualityScore.toStringAsFixed(1)),
        _kv('Fatigue Trend', insight.fatigueTrend != null
            ? insight.fatigueTrend!.toStringAsFixed(2)
            : 'N/A'),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _kv(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
