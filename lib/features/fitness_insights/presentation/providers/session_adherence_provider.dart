import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wger/features/fitness_insights/domain/entities/workout_adaptation.dart';
import 'package:wger/features/fitness_insights/domain/usecases/compute_adherence.dart';
import 'package:wger/models/workouts/log.dart';

part 'session_adherence_provider.g.dart';

const _kAdherenceHistoryKey = 'fitness_coach_v2_adherence_history';
const _kMaxHistoryEntries = 30; // Keep last 30 sessions

/// Manages adherence tracking: computes planned-vs-executed after each session
/// and persists a rolling history for the feedback loop.
@Riverpod(keepAlive: true)
class SessionAdherenceNotifier extends _$SessionAdherenceNotifier {
  @override
  List<SessionAdherenceRecord> build() {
    _loadHistory();
    return [];
  }

  /// Record adherence for a completed session.
  Future<void> recordSession({
    required WorkoutAdaptation adaptation,
    required List<Log> sessionLogs,
  }) async {
    final adherence = ComputeAdherence()(
      adaptation: adaptation,
      sessionLogs: sessionLogs,
      sessionDate: DateTime.now(),
    );

    final record = SessionAdherenceRecord(
      date: adherence.date,
      overallScore: adherence.overallScore.toDouble(),
      wasAdapted: adherence.wasAdapted,
      overrideCount: adherence.overrideCount,
      totalExercises: adherence.totalExercises,
    );

    final updated = [...state, record];
    // Trim to max history
    if (updated.length > _kMaxHistoryEntries) {
      updated.removeRange(0, updated.length - _kMaxHistoryEntries);
    }
    state = updated;
    await _saveHistory(updated);
  }

  /// Get average adherence score over last N sessions.
  double averageScore({int lastN = 10}) {
    if (state.isEmpty) {
      return 100;
    }
    final subset = state.length <= lastN ? state : state.sublist(state.length - lastN);
    final sum = subset.fold<double>(0, (acc, r) => acc + r.overallScore);
    return sum / subset.length;
  }

  /// Get override rate (0-1) over last N sessions.
  double overrideRate({int lastN = 10}) {
    if (state.isEmpty) {
      return 0;
    }
    final subset = state.length <= lastN ? state : state.sublist(state.length - lastN);
    var totalOverrides = 0;
    var totalExercises = 0;
    for (final r in subset) {
      totalOverrides += r.overrideCount;
      totalExercises += r.totalExercises;
    }
    if (totalExercises == 0) {
      return 0;
    }
    return totalOverrides / totalExercises;
  }

  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_kAdherenceHistoryKey);
      if (jsonStr == null) {
        return;
      }
      final list = jsonDecode(jsonStr) as List;
      state = list
          .map((e) => SessionAdherenceRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      // Best effort
    }
  }

  Future<void> _saveHistory(List<SessionAdherenceRecord> records) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(records.map((r) => r.toJson()).toList());
      await prefs.setString(_kAdherenceHistoryKey, jsonStr);
    } catch (_) {
      // Best effort
    }
  }
}

/// Lightweight record for persistence (avoids storing full SessionAdherence).
class SessionAdherenceRecord {
  final DateTime date;
  final double overallScore;
  final bool wasAdapted;
  final int overrideCount;
  final int totalExercises;

  const SessionAdherenceRecord({
    required this.date,
    required this.overallScore,
    required this.wasAdapted,
    this.overrideCount = 0,
    this.totalExercises = 0,
  });

  factory SessionAdherenceRecord.fromJson(Map<String, dynamic> json) {
    return SessionAdherenceRecord(
      date: DateTime.parse(json['date'] as String),
      overallScore: (json['overallScore'] as num).toDouble(),
      wasAdapted: json['wasAdapted'] as bool? ?? false,
      overrideCount: json['overrideCount'] as int? ?? 0,
      totalExercises: json['totalExercises'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'overallScore': overallScore,
        'wasAdapted': wasAdapted,
        'overrideCount': overrideCount,
        'totalExercises': totalExercises,
      };
}
