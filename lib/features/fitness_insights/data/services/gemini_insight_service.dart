import 'package:wger/features/fitness_insights/domain/entities/fitness_insight.dart';

/// Contract for formatting a [FitnessInsight] into human-readable text.
/// The actual implementation can be swapped (local stub, Gemini, etc.).
abstract interface class InsightFormatter {
  /// Returns a short summary (max 3 lines) based on the insight data.
  String format(FitnessInsight insight);
}

/// Local, deterministic stub implementation.
/// No network calls, no external dependencies, no AI logic.
class StubInsightFormatter implements InsightFormatter {
  @override
  String format(FitnessInsight insight) {
    final buffer = StringBuffer();

    switch (insight.status) {
      case FitnessStatus.goodProgress:
        buffer.writeln('Buen progreso general.');
        if (insight.isStrengthProgressing) {
          buffer.writeln('Tu fuerza está mejorando.');
        }
        if (insight.weeklyWeightChange != null) {
          final sign = insight.weeklyWeightChange! >= 0 ? '+' : '';
          buffer.writeln('Cambio de peso semanal: $sign${insight.weeklyWeightChange!.toStringAsFixed(2)}.');
        }
      case FitnessStatus.stalled:
        buffer.writeln('Progreso estancado detectado.');
        if (insight.stalledExercises.isNotEmpty) {
          final names = insight.stalledExercises.take(2).join(', ');
          buffer.writeln('Ejercicios estancados: $names.');
        }
        buffer.writeln('Considera variar intensidad o volumen.');
      case FitnessStatus.overtraining:
        buffer.writeln('Posible sobreentrenamiento.');
        if (insight.fatigueLevel != null) {
          buffer.writeln('Nivel de fatiga: ${insight.fatigueLevel!.toStringAsFixed(1)}/10.');
        }
        buffer.writeln('Prioriza descanso y recuperación.');
      case FitnessStatus.inconsistent:
        buffer.writeln('Patrón de entrenamiento inconsistente.');
        buffer.writeln(
          'Frecuencia semanal: ${insight.adherenceMetrics.weeklyFrequency.toStringAsFixed(1)} sesiones.',
        );
        buffer.writeln('Mayor regularidad mejorará los resultados.');
    }

    return buffer.toString().trim();
  }
}
