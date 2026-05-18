import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_modification.dart';
import 'package:wger/features/fitness_insights/presentation/providers/adapted_workout_provider.dart';

/// Screen that shows the workout modifications produced by the pre-workout
/// checkin. Displays original vs adapted values and the reasons.
class AdaptedWorkoutPreviewScreen extends ConsumerWidget {
  const AdaptedWorkoutPreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adaptationAsync = ref.watch(adaptedWorkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrenamiento Adaptado'),
      ),
      body: adaptationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (adaptation) => _buildBody(context, adaptation),
      ),
    );
  }

  Widget _buildBody(BuildContext context, adaptation) {
    if (!adaptation.hasModifications) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(
                'Sin modificaciones',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Tu condición actual no requiere ajustes. '
                'Seguí con el entrenamiento planeado.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _summaryCard(context, adaptation),
        const SizedBox(height: 24),
        Text(
          'Modificaciones',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        ...adaptation.modifications.map((m) => _modificationTile(context, m)),
      ],
    );
  }

  Widget _summaryCard(BuildContext context, adaptation) {
    final checkin = adaptation.checkin;
    final modCount = adaptation.modifications.length;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Resumen de adaptación',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _summaryItem(
                  context,
                  icon: Icons.battery_alert,
                  label: 'Fatiga',
                  value: '${checkin.fatigue}/10',
                  color: checkin.fatigue >= 8
                      ? Colors.red
                      : checkin.fatigue >= 6
                          ? Colors.orange
                          : Colors.green,
                ),
                _summaryItem(
                  context,
                  icon: Icons.edit,
                  label: 'Ajustes',
                  value: modCount.toString(),
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _modificationTile(BuildContext context, WorkoutModification mod) {
    final isReduction = mod.adaptedValue < mod.originalValue;
    final delta = (mod.adaptedValue - mod.originalValue).abs();
    final deltaStr = mod.field == 'weight'
        ? '${isReduction ? '-' : '+'}${delta.toStringAsFixed(1)}'
        : '${isReduction ? '-' : '+'}${delta.toStringAsFixed(0)}';
    final color = isReduction ? Colors.orange : Colors.green;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isReduction ? Icons.trending_down : Icons.trending_up,
                  color: color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mod.exerciseName,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${mod.field}: $deltaStr',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _valueChip('Original', mod.originalValue.toStringAsFixed(1)),
                const Icon(Icons.arrow_forward, size: 16),
                _valueChip('Adaptado', mod.adaptedValue.toStringAsFixed(1)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              mod.reason,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _valueChip(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
