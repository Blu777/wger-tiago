// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fitness_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FitnessInsight {

/// Overall fitness status determined by deterministic rules.
 FitnessStatus get status;/// Average weekly weight change over the analysis period.
 num? get weeklyWeightChange;/// Whether strength is progressing across the majority of tracked exercises.
 bool get isStrengthProgressing;/// Estimated fatigue level (1–10 scale).
 num? get fatigueLevel;/// Names of exercises that have stalled (no improvement for 2+ weeks).
 List<String> get stalledExercises;/// Names of exercises with a significant performance drop (>5%).
 List<String> get droppedExercises;/// Training adherence metrics.
 AdherenceMetrics get adherenceMetrics;/// Fatigue trend: negative = decreasing, positive = increasing, 0/null = stable.
 num? get fatigueTrend;/// Data quality score (0–100) based on session/exercise coverage.
 num get dataQualityScore;/// Total volume (weight × reps) per exercise over the analysis period.
 Map<String, num> get exerciseVolumes;/// Detailed insights for each tracked exercise.
 List<ExerciseInsight> get exerciseInsights;/// Analysis per muscle group (key = muscle name).
 Map<String, MuscleAnalysis> get muscleAnalysis;/// Overall training effectiveness score (0–100).
 num get trainingScore;/// Detailed breakdown of how the training score was computed.
 TrainingScoreBreakdown? get trainingScoreBreakdown;/// Weekly action plan with specific coaching directives.
 ActionPlan get actionPlan;/// Detected training phase for temporal context.
 TrainingPhase? get trainingPhase;/// Human-readable coaching summary.
 CoachSummary? get coachSummary;/// Persisted coaching state for the next analysis cycle.
 CoachState? get coachState;/// Actionable recommendations derived from the analysis.
 List<String> get recommendations;/// Optional human-readable summary (populated by a formatter service).
 String? get summaryText;/// Number of sessions in the analysis window.
 int get sessionCount;/// Number of unique exercises found in the analysis window.
 int get uniqueExerciseCount;
/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FitnessInsightCopyWith<FitnessInsight> get copyWith => _$FitnessInsightCopyWithImpl<FitnessInsight>(this as FitnessInsight, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FitnessInsight&&(identical(other.status, status) || other.status == status)&&(identical(other.weeklyWeightChange, weeklyWeightChange) || other.weeklyWeightChange == weeklyWeightChange)&&(identical(other.isStrengthProgressing, isStrengthProgressing) || other.isStrengthProgressing == isStrengthProgressing)&&(identical(other.fatigueLevel, fatigueLevel) || other.fatigueLevel == fatigueLevel)&&const DeepCollectionEquality().equals(other.stalledExercises, stalledExercises)&&const DeepCollectionEquality().equals(other.droppedExercises, droppedExercises)&&(identical(other.adherenceMetrics, adherenceMetrics) || other.adherenceMetrics == adherenceMetrics)&&(identical(other.fatigueTrend, fatigueTrend) || other.fatigueTrend == fatigueTrend)&&(identical(other.dataQualityScore, dataQualityScore) || other.dataQualityScore == dataQualityScore)&&const DeepCollectionEquality().equals(other.exerciseVolumes, exerciseVolumes)&&const DeepCollectionEquality().equals(other.exerciseInsights, exerciseInsights)&&const DeepCollectionEquality().equals(other.muscleAnalysis, muscleAnalysis)&&(identical(other.trainingScore, trainingScore) || other.trainingScore == trainingScore)&&(identical(other.trainingScoreBreakdown, trainingScoreBreakdown) || other.trainingScoreBreakdown == trainingScoreBreakdown)&&(identical(other.actionPlan, actionPlan) || other.actionPlan == actionPlan)&&(identical(other.trainingPhase, trainingPhase) || other.trainingPhase == trainingPhase)&&(identical(other.coachSummary, coachSummary) || other.coachSummary == coachSummary)&&(identical(other.coachState, coachState) || other.coachState == coachState)&&const DeepCollectionEquality().equals(other.recommendations, recommendations)&&(identical(other.summaryText, summaryText) || other.summaryText == summaryText)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.uniqueExerciseCount, uniqueExerciseCount) || other.uniqueExerciseCount == uniqueExerciseCount));
}


@override
int get hashCode => Object.hashAll([runtimeType,status,weeklyWeightChange,isStrengthProgressing,fatigueLevel,const DeepCollectionEquality().hash(stalledExercises),const DeepCollectionEquality().hash(droppedExercises),adherenceMetrics,fatigueTrend,dataQualityScore,const DeepCollectionEquality().hash(exerciseVolumes),const DeepCollectionEquality().hash(exerciseInsights),const DeepCollectionEquality().hash(muscleAnalysis),trainingScore,trainingScoreBreakdown,actionPlan,trainingPhase,coachSummary,coachState,const DeepCollectionEquality().hash(recommendations),summaryText,sessionCount,uniqueExerciseCount]);

@override
String toString() {
  return 'FitnessInsight(status: $status, weeklyWeightChange: $weeklyWeightChange, isStrengthProgressing: $isStrengthProgressing, fatigueLevel: $fatigueLevel, stalledExercises: $stalledExercises, droppedExercises: $droppedExercises, adherenceMetrics: $adherenceMetrics, fatigueTrend: $fatigueTrend, dataQualityScore: $dataQualityScore, exerciseVolumes: $exerciseVolumes, exerciseInsights: $exerciseInsights, muscleAnalysis: $muscleAnalysis, trainingScore: $trainingScore, trainingScoreBreakdown: $trainingScoreBreakdown, actionPlan: $actionPlan, trainingPhase: $trainingPhase, coachSummary: $coachSummary, coachState: $coachState, recommendations: $recommendations, summaryText: $summaryText, sessionCount: $sessionCount, uniqueExerciseCount: $uniqueExerciseCount)';
}


}

/// @nodoc
abstract mixin class $FitnessInsightCopyWith<$Res>  {
  factory $FitnessInsightCopyWith(FitnessInsight value, $Res Function(FitnessInsight) _then) = _$FitnessInsightCopyWithImpl;
@useResult
$Res call({
 FitnessStatus status, num? weeklyWeightChange, bool isStrengthProgressing, num? fatigueLevel, List<String> stalledExercises, List<String> droppedExercises, AdherenceMetrics adherenceMetrics, num? fatigueTrend, num dataQualityScore, Map<String, num> exerciseVolumes, List<ExerciseInsight> exerciseInsights, Map<String, MuscleAnalysis> muscleAnalysis, num trainingScore, TrainingScoreBreakdown? trainingScoreBreakdown, ActionPlan actionPlan, TrainingPhase? trainingPhase, CoachSummary? coachSummary, CoachState? coachState, List<String> recommendations, String? summaryText, int sessionCount, int uniqueExerciseCount
});


$AdherenceMetricsCopyWith<$Res> get adherenceMetrics;$TrainingScoreBreakdownCopyWith<$Res>? get trainingScoreBreakdown;$ActionPlanCopyWith<$Res> get actionPlan;$CoachSummaryCopyWith<$Res>? get coachSummary;$CoachStateCopyWith<$Res>? get coachState;

}
/// @nodoc
class _$FitnessInsightCopyWithImpl<$Res>
    implements $FitnessInsightCopyWith<$Res> {
  _$FitnessInsightCopyWithImpl(this._self, this._then);

  final FitnessInsight _self;
  final $Res Function(FitnessInsight) _then;

/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? weeklyWeightChange = freezed,Object? isStrengthProgressing = null,Object? fatigueLevel = freezed,Object? stalledExercises = null,Object? droppedExercises = null,Object? adherenceMetrics = null,Object? fatigueTrend = freezed,Object? dataQualityScore = null,Object? exerciseVolumes = null,Object? exerciseInsights = null,Object? muscleAnalysis = null,Object? trainingScore = null,Object? trainingScoreBreakdown = freezed,Object? actionPlan = null,Object? trainingPhase = freezed,Object? coachSummary = freezed,Object? coachState = freezed,Object? recommendations = null,Object? summaryText = freezed,Object? sessionCount = null,Object? uniqueExerciseCount = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FitnessStatus,weeklyWeightChange: freezed == weeklyWeightChange ? _self.weeklyWeightChange : weeklyWeightChange // ignore: cast_nullable_to_non_nullable
as num?,isStrengthProgressing: null == isStrengthProgressing ? _self.isStrengthProgressing : isStrengthProgressing // ignore: cast_nullable_to_non_nullable
as bool,fatigueLevel: freezed == fatigueLevel ? _self.fatigueLevel : fatigueLevel // ignore: cast_nullable_to_non_nullable
as num?,stalledExercises: null == stalledExercises ? _self.stalledExercises : stalledExercises // ignore: cast_nullable_to_non_nullable
as List<String>,droppedExercises: null == droppedExercises ? _self.droppedExercises : droppedExercises // ignore: cast_nullable_to_non_nullable
as List<String>,adherenceMetrics: null == adherenceMetrics ? _self.adherenceMetrics : adherenceMetrics // ignore: cast_nullable_to_non_nullable
as AdherenceMetrics,fatigueTrend: freezed == fatigueTrend ? _self.fatigueTrend : fatigueTrend // ignore: cast_nullable_to_non_nullable
as num?,dataQualityScore: null == dataQualityScore ? _self.dataQualityScore : dataQualityScore // ignore: cast_nullable_to_non_nullable
as num,exerciseVolumes: null == exerciseVolumes ? _self.exerciseVolumes : exerciseVolumes // ignore: cast_nullable_to_non_nullable
as Map<String, num>,exerciseInsights: null == exerciseInsights ? _self.exerciseInsights : exerciseInsights // ignore: cast_nullable_to_non_nullable
as List<ExerciseInsight>,muscleAnalysis: null == muscleAnalysis ? _self.muscleAnalysis : muscleAnalysis // ignore: cast_nullable_to_non_nullable
as Map<String, MuscleAnalysis>,trainingScore: null == trainingScore ? _self.trainingScore : trainingScore // ignore: cast_nullable_to_non_nullable
as num,trainingScoreBreakdown: freezed == trainingScoreBreakdown ? _self.trainingScoreBreakdown : trainingScoreBreakdown // ignore: cast_nullable_to_non_nullable
as TrainingScoreBreakdown?,actionPlan: null == actionPlan ? _self.actionPlan : actionPlan // ignore: cast_nullable_to_non_nullable
as ActionPlan,trainingPhase: freezed == trainingPhase ? _self.trainingPhase : trainingPhase // ignore: cast_nullable_to_non_nullable
as TrainingPhase?,coachSummary: freezed == coachSummary ? _self.coachSummary : coachSummary // ignore: cast_nullable_to_non_nullable
as CoachSummary?,coachState: freezed == coachState ? _self.coachState : coachState // ignore: cast_nullable_to_non_nullable
as CoachState?,recommendations: null == recommendations ? _self.recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,summaryText: freezed == summaryText ? _self.summaryText : summaryText // ignore: cast_nullable_to_non_nullable
as String?,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,uniqueExerciseCount: null == uniqueExerciseCount ? _self.uniqueExerciseCount : uniqueExerciseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceMetricsCopyWith<$Res> get adherenceMetrics {
  
  return $AdherenceMetricsCopyWith<$Res>(_self.adherenceMetrics, (value) {
    return _then(_self.copyWith(adherenceMetrics: value));
  });
}/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrainingScoreBreakdownCopyWith<$Res>? get trainingScoreBreakdown {
    if (_self.trainingScoreBreakdown == null) {
    return null;
  }

  return $TrainingScoreBreakdownCopyWith<$Res>(_self.trainingScoreBreakdown!, (value) {
    return _then(_self.copyWith(trainingScoreBreakdown: value));
  });
}/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionPlanCopyWith<$Res> get actionPlan {
  
  return $ActionPlanCopyWith<$Res>(_self.actionPlan, (value) {
    return _then(_self.copyWith(actionPlan: value));
  });
}/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachSummaryCopyWith<$Res>? get coachSummary {
    if (_self.coachSummary == null) {
    return null;
  }

  return $CoachSummaryCopyWith<$Res>(_self.coachSummary!, (value) {
    return _then(_self.copyWith(coachSummary: value));
  });
}/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachStateCopyWith<$Res>? get coachState {
    if (_self.coachState == null) {
    return null;
  }

  return $CoachStateCopyWith<$Res>(_self.coachState!, (value) {
    return _then(_self.copyWith(coachState: value));
  });
}
}


/// Adds pattern-matching-related methods to [FitnessInsight].
extension FitnessInsightPatterns on FitnessInsight {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FitnessInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FitnessInsight() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FitnessInsight value)  $default,){
final _that = this;
switch (_that) {
case _FitnessInsight():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FitnessInsight value)?  $default,){
final _that = this;
switch (_that) {
case _FitnessInsight() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( FitnessStatus status,  num? weeklyWeightChange,  bool isStrengthProgressing,  num? fatigueLevel,  List<String> stalledExercises,  List<String> droppedExercises,  AdherenceMetrics adherenceMetrics,  num? fatigueTrend,  num dataQualityScore,  Map<String, num> exerciseVolumes,  List<ExerciseInsight> exerciseInsights,  Map<String, MuscleAnalysis> muscleAnalysis,  num trainingScore,  TrainingScoreBreakdown? trainingScoreBreakdown,  ActionPlan actionPlan,  TrainingPhase? trainingPhase,  CoachSummary? coachSummary,  CoachState? coachState,  List<String> recommendations,  String? summaryText,  int sessionCount,  int uniqueExerciseCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FitnessInsight() when $default != null:
return $default(_that.status,_that.weeklyWeightChange,_that.isStrengthProgressing,_that.fatigueLevel,_that.stalledExercises,_that.droppedExercises,_that.adherenceMetrics,_that.fatigueTrend,_that.dataQualityScore,_that.exerciseVolumes,_that.exerciseInsights,_that.muscleAnalysis,_that.trainingScore,_that.trainingScoreBreakdown,_that.actionPlan,_that.trainingPhase,_that.coachSummary,_that.coachState,_that.recommendations,_that.summaryText,_that.sessionCount,_that.uniqueExerciseCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( FitnessStatus status,  num? weeklyWeightChange,  bool isStrengthProgressing,  num? fatigueLevel,  List<String> stalledExercises,  List<String> droppedExercises,  AdherenceMetrics adherenceMetrics,  num? fatigueTrend,  num dataQualityScore,  Map<String, num> exerciseVolumes,  List<ExerciseInsight> exerciseInsights,  Map<String, MuscleAnalysis> muscleAnalysis,  num trainingScore,  TrainingScoreBreakdown? trainingScoreBreakdown,  ActionPlan actionPlan,  TrainingPhase? trainingPhase,  CoachSummary? coachSummary,  CoachState? coachState,  List<String> recommendations,  String? summaryText,  int sessionCount,  int uniqueExerciseCount)  $default,) {final _that = this;
switch (_that) {
case _FitnessInsight():
return $default(_that.status,_that.weeklyWeightChange,_that.isStrengthProgressing,_that.fatigueLevel,_that.stalledExercises,_that.droppedExercises,_that.adherenceMetrics,_that.fatigueTrend,_that.dataQualityScore,_that.exerciseVolumes,_that.exerciseInsights,_that.muscleAnalysis,_that.trainingScore,_that.trainingScoreBreakdown,_that.actionPlan,_that.trainingPhase,_that.coachSummary,_that.coachState,_that.recommendations,_that.summaryText,_that.sessionCount,_that.uniqueExerciseCount);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( FitnessStatus status,  num? weeklyWeightChange,  bool isStrengthProgressing,  num? fatigueLevel,  List<String> stalledExercises,  List<String> droppedExercises,  AdherenceMetrics adherenceMetrics,  num? fatigueTrend,  num dataQualityScore,  Map<String, num> exerciseVolumes,  List<ExerciseInsight> exerciseInsights,  Map<String, MuscleAnalysis> muscleAnalysis,  num trainingScore,  TrainingScoreBreakdown? trainingScoreBreakdown,  ActionPlan actionPlan,  TrainingPhase? trainingPhase,  CoachSummary? coachSummary,  CoachState? coachState,  List<String> recommendations,  String? summaryText,  int sessionCount,  int uniqueExerciseCount)?  $default,) {final _that = this;
switch (_that) {
case _FitnessInsight() when $default != null:
return $default(_that.status,_that.weeklyWeightChange,_that.isStrengthProgressing,_that.fatigueLevel,_that.stalledExercises,_that.droppedExercises,_that.adherenceMetrics,_that.fatigueTrend,_that.dataQualityScore,_that.exerciseVolumes,_that.exerciseInsights,_that.muscleAnalysis,_that.trainingScore,_that.trainingScoreBreakdown,_that.actionPlan,_that.trainingPhase,_that.coachSummary,_that.coachState,_that.recommendations,_that.summaryText,_that.sessionCount,_that.uniqueExerciseCount);case _:
  return null;

}
}

}

/// @nodoc


class _FitnessInsight implements FitnessInsight {
  const _FitnessInsight({required this.status, this.weeklyWeightChange, required this.isStrengthProgressing, this.fatigueLevel, final  List<String> stalledExercises = const [], final  List<String> droppedExercises = const [], required this.adherenceMetrics, this.fatigueTrend, required this.dataQualityScore, final  Map<String, num> exerciseVolumes = const {}, final  List<ExerciseInsight> exerciseInsights = const [], final  Map<String, MuscleAnalysis> muscleAnalysis = const {}, required this.trainingScore, this.trainingScoreBreakdown, this.actionPlan = const ActionPlan(), this.trainingPhase, this.coachSummary, this.coachState, final  List<String> recommendations = const [], this.summaryText, this.sessionCount = 0, this.uniqueExerciseCount = 0}): _stalledExercises = stalledExercises,_droppedExercises = droppedExercises,_exerciseVolumes = exerciseVolumes,_exerciseInsights = exerciseInsights,_muscleAnalysis = muscleAnalysis,_recommendations = recommendations;
  

/// Overall fitness status determined by deterministic rules.
@override final  FitnessStatus status;
/// Average weekly weight change over the analysis period.
@override final  num? weeklyWeightChange;
/// Whether strength is progressing across the majority of tracked exercises.
@override final  bool isStrengthProgressing;
/// Estimated fatigue level (1–10 scale).
@override final  num? fatigueLevel;
/// Names of exercises that have stalled (no improvement for 2+ weeks).
 final  List<String> _stalledExercises;
/// Names of exercises that have stalled (no improvement for 2+ weeks).
@override@JsonKey() List<String> get stalledExercises {
  if (_stalledExercises is EqualUnmodifiableListView) return _stalledExercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stalledExercises);
}

/// Names of exercises with a significant performance drop (>5%).
 final  List<String> _droppedExercises;
/// Names of exercises with a significant performance drop (>5%).
@override@JsonKey() List<String> get droppedExercises {
  if (_droppedExercises is EqualUnmodifiableListView) return _droppedExercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_droppedExercises);
}

/// Training adherence metrics.
@override final  AdherenceMetrics adherenceMetrics;
/// Fatigue trend: negative = decreasing, positive = increasing, 0/null = stable.
@override final  num? fatigueTrend;
/// Data quality score (0–100) based on session/exercise coverage.
@override final  num dataQualityScore;
/// Total volume (weight × reps) per exercise over the analysis period.
 final  Map<String, num> _exerciseVolumes;
/// Total volume (weight × reps) per exercise over the analysis period.
@override@JsonKey() Map<String, num> get exerciseVolumes {
  if (_exerciseVolumes is EqualUnmodifiableMapView) return _exerciseVolumes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_exerciseVolumes);
}

/// Detailed insights for each tracked exercise.
 final  List<ExerciseInsight> _exerciseInsights;
/// Detailed insights for each tracked exercise.
@override@JsonKey() List<ExerciseInsight> get exerciseInsights {
  if (_exerciseInsights is EqualUnmodifiableListView) return _exerciseInsights;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exerciseInsights);
}

/// Analysis per muscle group (key = muscle name).
 final  Map<String, MuscleAnalysis> _muscleAnalysis;
/// Analysis per muscle group (key = muscle name).
@override@JsonKey() Map<String, MuscleAnalysis> get muscleAnalysis {
  if (_muscleAnalysis is EqualUnmodifiableMapView) return _muscleAnalysis;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_muscleAnalysis);
}

/// Overall training effectiveness score (0–100).
@override final  num trainingScore;
/// Detailed breakdown of how the training score was computed.
@override final  TrainingScoreBreakdown? trainingScoreBreakdown;
/// Weekly action plan with specific coaching directives.
@override@JsonKey() final  ActionPlan actionPlan;
/// Detected training phase for temporal context.
@override final  TrainingPhase? trainingPhase;
/// Human-readable coaching summary.
@override final  CoachSummary? coachSummary;
/// Persisted coaching state for the next analysis cycle.
@override final  CoachState? coachState;
/// Actionable recommendations derived from the analysis.
 final  List<String> _recommendations;
/// Actionable recommendations derived from the analysis.
@override@JsonKey() List<String> get recommendations {
  if (_recommendations is EqualUnmodifiableListView) return _recommendations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recommendations);
}

/// Optional human-readable summary (populated by a formatter service).
@override final  String? summaryText;
/// Number of sessions in the analysis window.
@override@JsonKey() final  int sessionCount;
/// Number of unique exercises found in the analysis window.
@override@JsonKey() final  int uniqueExerciseCount;

/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FitnessInsightCopyWith<_FitnessInsight> get copyWith => __$FitnessInsightCopyWithImpl<_FitnessInsight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FitnessInsight&&(identical(other.status, status) || other.status == status)&&(identical(other.weeklyWeightChange, weeklyWeightChange) || other.weeklyWeightChange == weeklyWeightChange)&&(identical(other.isStrengthProgressing, isStrengthProgressing) || other.isStrengthProgressing == isStrengthProgressing)&&(identical(other.fatigueLevel, fatigueLevel) || other.fatigueLevel == fatigueLevel)&&const DeepCollectionEquality().equals(other._stalledExercises, _stalledExercises)&&const DeepCollectionEquality().equals(other._droppedExercises, _droppedExercises)&&(identical(other.adherenceMetrics, adherenceMetrics) || other.adherenceMetrics == adherenceMetrics)&&(identical(other.fatigueTrend, fatigueTrend) || other.fatigueTrend == fatigueTrend)&&(identical(other.dataQualityScore, dataQualityScore) || other.dataQualityScore == dataQualityScore)&&const DeepCollectionEquality().equals(other._exerciseVolumes, _exerciseVolumes)&&const DeepCollectionEquality().equals(other._exerciseInsights, _exerciseInsights)&&const DeepCollectionEquality().equals(other._muscleAnalysis, _muscleAnalysis)&&(identical(other.trainingScore, trainingScore) || other.trainingScore == trainingScore)&&(identical(other.trainingScoreBreakdown, trainingScoreBreakdown) || other.trainingScoreBreakdown == trainingScoreBreakdown)&&(identical(other.actionPlan, actionPlan) || other.actionPlan == actionPlan)&&(identical(other.trainingPhase, trainingPhase) || other.trainingPhase == trainingPhase)&&(identical(other.coachSummary, coachSummary) || other.coachSummary == coachSummary)&&(identical(other.coachState, coachState) || other.coachState == coachState)&&const DeepCollectionEquality().equals(other._recommendations, _recommendations)&&(identical(other.summaryText, summaryText) || other.summaryText == summaryText)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.uniqueExerciseCount, uniqueExerciseCount) || other.uniqueExerciseCount == uniqueExerciseCount));
}


@override
int get hashCode => Object.hashAll([runtimeType,status,weeklyWeightChange,isStrengthProgressing,fatigueLevel,const DeepCollectionEquality().hash(_stalledExercises),const DeepCollectionEquality().hash(_droppedExercises),adherenceMetrics,fatigueTrend,dataQualityScore,const DeepCollectionEquality().hash(_exerciseVolumes),const DeepCollectionEquality().hash(_exerciseInsights),const DeepCollectionEquality().hash(_muscleAnalysis),trainingScore,trainingScoreBreakdown,actionPlan,trainingPhase,coachSummary,coachState,const DeepCollectionEquality().hash(_recommendations),summaryText,sessionCount,uniqueExerciseCount]);

@override
String toString() {
  return 'FitnessInsight(status: $status, weeklyWeightChange: $weeklyWeightChange, isStrengthProgressing: $isStrengthProgressing, fatigueLevel: $fatigueLevel, stalledExercises: $stalledExercises, droppedExercises: $droppedExercises, adherenceMetrics: $adherenceMetrics, fatigueTrend: $fatigueTrend, dataQualityScore: $dataQualityScore, exerciseVolumes: $exerciseVolumes, exerciseInsights: $exerciseInsights, muscleAnalysis: $muscleAnalysis, trainingScore: $trainingScore, trainingScoreBreakdown: $trainingScoreBreakdown, actionPlan: $actionPlan, trainingPhase: $trainingPhase, coachSummary: $coachSummary, coachState: $coachState, recommendations: $recommendations, summaryText: $summaryText, sessionCount: $sessionCount, uniqueExerciseCount: $uniqueExerciseCount)';
}


}

/// @nodoc
abstract mixin class _$FitnessInsightCopyWith<$Res> implements $FitnessInsightCopyWith<$Res> {
  factory _$FitnessInsightCopyWith(_FitnessInsight value, $Res Function(_FitnessInsight) _then) = __$FitnessInsightCopyWithImpl;
@override @useResult
$Res call({
 FitnessStatus status, num? weeklyWeightChange, bool isStrengthProgressing, num? fatigueLevel, List<String> stalledExercises, List<String> droppedExercises, AdherenceMetrics adherenceMetrics, num? fatigueTrend, num dataQualityScore, Map<String, num> exerciseVolumes, List<ExerciseInsight> exerciseInsights, Map<String, MuscleAnalysis> muscleAnalysis, num trainingScore, TrainingScoreBreakdown? trainingScoreBreakdown, ActionPlan actionPlan, TrainingPhase? trainingPhase, CoachSummary? coachSummary, CoachState? coachState, List<String> recommendations, String? summaryText, int sessionCount, int uniqueExerciseCount
});


@override $AdherenceMetricsCopyWith<$Res> get adherenceMetrics;@override $TrainingScoreBreakdownCopyWith<$Res>? get trainingScoreBreakdown;@override $ActionPlanCopyWith<$Res> get actionPlan;@override $CoachSummaryCopyWith<$Res>? get coachSummary;@override $CoachStateCopyWith<$Res>? get coachState;

}
/// @nodoc
class __$FitnessInsightCopyWithImpl<$Res>
    implements _$FitnessInsightCopyWith<$Res> {
  __$FitnessInsightCopyWithImpl(this._self, this._then);

  final _FitnessInsight _self;
  final $Res Function(_FitnessInsight) _then;

/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? weeklyWeightChange = freezed,Object? isStrengthProgressing = null,Object? fatigueLevel = freezed,Object? stalledExercises = null,Object? droppedExercises = null,Object? adherenceMetrics = null,Object? fatigueTrend = freezed,Object? dataQualityScore = null,Object? exerciseVolumes = null,Object? exerciseInsights = null,Object? muscleAnalysis = null,Object? trainingScore = null,Object? trainingScoreBreakdown = freezed,Object? actionPlan = null,Object? trainingPhase = freezed,Object? coachSummary = freezed,Object? coachState = freezed,Object? recommendations = null,Object? summaryText = freezed,Object? sessionCount = null,Object? uniqueExerciseCount = null,}) {
  return _then(_FitnessInsight(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FitnessStatus,weeklyWeightChange: freezed == weeklyWeightChange ? _self.weeklyWeightChange : weeklyWeightChange // ignore: cast_nullable_to_non_nullable
as num?,isStrengthProgressing: null == isStrengthProgressing ? _self.isStrengthProgressing : isStrengthProgressing // ignore: cast_nullable_to_non_nullable
as bool,fatigueLevel: freezed == fatigueLevel ? _self.fatigueLevel : fatigueLevel // ignore: cast_nullable_to_non_nullable
as num?,stalledExercises: null == stalledExercises ? _self._stalledExercises : stalledExercises // ignore: cast_nullable_to_non_nullable
as List<String>,droppedExercises: null == droppedExercises ? _self._droppedExercises : droppedExercises // ignore: cast_nullable_to_non_nullable
as List<String>,adherenceMetrics: null == adherenceMetrics ? _self.adherenceMetrics : adherenceMetrics // ignore: cast_nullable_to_non_nullable
as AdherenceMetrics,fatigueTrend: freezed == fatigueTrend ? _self.fatigueTrend : fatigueTrend // ignore: cast_nullable_to_non_nullable
as num?,dataQualityScore: null == dataQualityScore ? _self.dataQualityScore : dataQualityScore // ignore: cast_nullable_to_non_nullable
as num,exerciseVolumes: null == exerciseVolumes ? _self._exerciseVolumes : exerciseVolumes // ignore: cast_nullable_to_non_nullable
as Map<String, num>,exerciseInsights: null == exerciseInsights ? _self._exerciseInsights : exerciseInsights // ignore: cast_nullable_to_non_nullable
as List<ExerciseInsight>,muscleAnalysis: null == muscleAnalysis ? _self._muscleAnalysis : muscleAnalysis // ignore: cast_nullable_to_non_nullable
as Map<String, MuscleAnalysis>,trainingScore: null == trainingScore ? _self.trainingScore : trainingScore // ignore: cast_nullable_to_non_nullable
as num,trainingScoreBreakdown: freezed == trainingScoreBreakdown ? _self.trainingScoreBreakdown : trainingScoreBreakdown // ignore: cast_nullable_to_non_nullable
as TrainingScoreBreakdown?,actionPlan: null == actionPlan ? _self.actionPlan : actionPlan // ignore: cast_nullable_to_non_nullable
as ActionPlan,trainingPhase: freezed == trainingPhase ? _self.trainingPhase : trainingPhase // ignore: cast_nullable_to_non_nullable
as TrainingPhase?,coachSummary: freezed == coachSummary ? _self.coachSummary : coachSummary // ignore: cast_nullable_to_non_nullable
as CoachSummary?,coachState: freezed == coachState ? _self.coachState : coachState // ignore: cast_nullable_to_non_nullable
as CoachState?,recommendations: null == recommendations ? _self._recommendations : recommendations // ignore: cast_nullable_to_non_nullable
as List<String>,summaryText: freezed == summaryText ? _self.summaryText : summaryText // ignore: cast_nullable_to_non_nullable
as String?,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,uniqueExerciseCount: null == uniqueExerciseCount ? _self.uniqueExerciseCount : uniqueExerciseCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdherenceMetricsCopyWith<$Res> get adherenceMetrics {
  
  return $AdherenceMetricsCopyWith<$Res>(_self.adherenceMetrics, (value) {
    return _then(_self.copyWith(adherenceMetrics: value));
  });
}/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrainingScoreBreakdownCopyWith<$Res>? get trainingScoreBreakdown {
    if (_self.trainingScoreBreakdown == null) {
    return null;
  }

  return $TrainingScoreBreakdownCopyWith<$Res>(_self.trainingScoreBreakdown!, (value) {
    return _then(_self.copyWith(trainingScoreBreakdown: value));
  });
}/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionPlanCopyWith<$Res> get actionPlan {
  
  return $ActionPlanCopyWith<$Res>(_self.actionPlan, (value) {
    return _then(_self.copyWith(actionPlan: value));
  });
}/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachSummaryCopyWith<$Res>? get coachSummary {
    if (_self.coachSummary == null) {
    return null;
  }

  return $CoachSummaryCopyWith<$Res>(_self.coachSummary!, (value) {
    return _then(_self.copyWith(coachSummary: value));
  });
}/// Create a copy of FitnessInsight
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachStateCopyWith<$Res>? get coachState {
    if (_self.coachState == null) {
    return null;
  }

  return $CoachStateCopyWith<$Res>(_self.coachState!, (value) {
    return _then(_self.copyWith(coachState: value));
  });
}
}

// dart format on
