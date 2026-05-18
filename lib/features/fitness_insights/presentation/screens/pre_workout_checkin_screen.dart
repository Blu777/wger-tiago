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
