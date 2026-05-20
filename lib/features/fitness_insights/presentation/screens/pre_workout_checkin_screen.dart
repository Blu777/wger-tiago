import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wger/features/fitness_insights/domain/entities/pre_workout_checkin.dart';
import 'package:wger/features/fitness_insights/presentation/providers/adapted_workout_provider.dart';
import 'package:wger/features/fitness_insights/presentation/providers/fitness_coach_v2_provider.dart';
import 'package:wger/features/fitness_insights/presentation/screens/adapted_workout_preview_screen.dart';
import 'package:wger/models/workouts/day_data.dart';

/// Screen where the user reports current pain per muscle and global fatigue
/// before starting a workout.
class PreWorkoutCheckinScreen extends ConsumerStatefulWidget {
  final DayData dayData;

  const PreWorkoutCheckinScreen({super.key, required this.dayData});

  @override
  ConsumerState<PreWorkoutCheckinScreen> createState() =>
      _PreWorkoutCheckinScreenState();
}

class _PreWorkoutCheckinScreenState
    extends ConsumerState<PreWorkoutCheckinScreen> {
  late PreWorkoutCheckin _checkin;

  List<String> get _muscles {
    final names = <String>{};
    for (final slot in widget.dayData.slots) {
      for (final config in slot.setConfigs) {
        final ex = config.exercise;
        for (final m in [...ex.muscles, ...ex.musclesSecondary]) {
          names.add(m.name);
        }
      }
    }
    return names.toList()..sort();
  }

  @override
  void initState() {
    super.initState();
    _checkin = const PreWorkoutCheckin();
    // Seed provider with original workout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(adaptedWorkoutProvider.notifier)
          .setOriginalWorkout(widget.dayData);
    });
  }

  void _updatePain(String muscle, double value) {
    setState(() {
      final pain = Map<String, int>.from(_checkin.musclePain);
      pain[muscle] = value.toInt();
      _checkin = _checkin.copyWith(musclePain: pain);
    });
    ref.read(adaptedWorkoutProvider.notifier).updateCheckin(_checkin);
  }

  void _updateFatigue(double value) {
    setState(() {
      _checkin = _checkin.copyWith(fatigue: value.toInt());
    });
    ref.read(adaptedWorkoutProvider.notifier).updateCheckin(_checkin);
  }

  void _updateSportActivity(PlannedSportActivity activity) {
    setState(() {
      _checkin = _checkin.copyWith(plannedSportActivity: activity);
    });
    ref.read(adaptedWorkoutProvider.notifier).updateCheckin(_checkin);
  }

  @override
  Widget build(BuildContext context) {
    final muscles = _muscles;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in Pre-Entreno'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '¿Cómo te sentís hoy?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Ajustá los sliders según tu condición actual. '
            'El entrenamiento se adaptará automáticamente.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          _fatigueCard(),
          const SizedBox(height: 16),
          _sportActivityCard(),
          const SizedBox(height: 24),
          if (muscles.isNotEmpty) ...[
            Text(
              'Dolor por músculo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...muscles.map((m) => _painSlider(m)),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildCTAButton(context, ref),
        ),
      ),
    );
  }

  Widget _buildCTAButton(BuildContext context, WidgetRef ref) {
    final coachState = ref.watch(fitnessCoachV2Provider);
    final isLoading = coachState.isLoading;

    return FilledButton(
      onPressed: isLoading
          ? null
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AdaptedWorkoutPreviewScreen(),
                ),
              );
            },
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            )
          : const Text('Ver entrenamiento adaptado'),
    );
  }

  Widget _fatigueCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.battery_alert),
                const SizedBox(width: 8),
                Text(
                  'Fatiga global',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('1'),
                Expanded(
                  child: Slider(
                    value: _checkin.fatigue.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: _checkin.fatigue.toString(),
                    onChanged: _updateFatigue,
                  ),
                ),
                const Text('10'),
              ],
            ),
            Center(
              child: Text(
                'Fatiga: ${_checkin.fatigue}/10',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sportActivityCard() {
    final selected = _checkin.plannedSportActivity;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.sports_soccer),
                const SizedBox(width: 8),
                Text(
                  'Actividad después del entreno',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '¿Tenés algo planificado más tarde hoy?',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PlannedSportActivity.values.map((activity) {
                final isSelected = selected == activity;
                return ChoiceChip(
                  label: Text(activity.label),
                  selected: isSelected,
                  onSelected: (_) => _updateSportActivity(activity),
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                );
              }).toList(),
            ),
            if (selected != PlannedSportActivity.none) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Se reducirá el volumen ${(selected.volumeReductionFactor * 100).toInt()}%'
                        '${selected.weightReductionFactor > 0 ? ' y el peso ${(selected.weightReductionFactor * 100).toInt()}%' : ''} para conservar energía.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _painSlider(String muscle) {
    final pain = _checkin.painForMuscle(muscle);
    Color color = Colors.green;
    if (pain >= 7) {
      color = Colors.red;
    } else if (pain >= 4) {
      color = Colors.orange;
    } else if (pain >= 1) {
      color = Colors.yellow.shade700;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              muscle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Row(
              children: [
                const Text('0'),
                Expanded(
                  child: Slider(
                    value: pain.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: pain.toString(),
                    activeColor: color,
                    onChanged: (v) => _updatePain(muscle, v),
                  ),
                ),
                const Text('10'),
              ],
            ),
            if (pain > 0)
              Text(
                'Dolor: $pain/10',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
