// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseInsight {

/// Exercise name.
 String get exerciseName;/// Current estimated 1RM (average of last 2 weeks).
 num get currentE1rm;/// Previous estimated 1RM (average of prior 2 weeks).
 num get previousE1rm;/// Percentage change between current and previous e1RM.
 num get e1rmChangePercent;/// Total volume (weight × reps) over the analysis period.
 num get totalVolume;/// Number of sessions this exercise was performed in.
 int get sessionCount;/// Progression status.
 ExerciseProgressStatus get progressStatus;/// Specific recommendation for this exercise.
 String get recommendation;
/// Create a copy of ExerciseInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseInsightCopyWith<ExerciseInsight> get copyWith => _$ExerciseInsightCopyWithImpl<ExerciseInsight>(this as ExerciseInsight, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseInsight&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.currentE1rm, currentE1rm) || other.currentE1rm == currentE1rm)&&(identical(other.previousE1rm, previousE1rm) || other.previousE1rm == previousE1rm)&&(identical(other.e1rmChangePercent, e1rmChangePercent) || other.e1rmChangePercent == e1rmChangePercent)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseName,currentE1rm,previousE1rm,e1rmChangePercent,totalVolume,sessionCount,progressStatus,recommendation);

@override
String toString() {
  return 'ExerciseInsight(exerciseName: $exerciseName, currentE1rm: $currentE1rm, previousE1rm: $previousE1rm, e1rmChangePercent: $e1rmChangePercent, totalVolume: $totalVolume, sessionCount: $sessionCount, progressStatus: $progressStatus, recommendation: $recommendation)';
}


}

/// @nodoc
abstract mixin class $ExerciseInsightCopyWith<$Res>  {
  factory $ExerciseInsightCopyWith(ExerciseInsight value, $Res Function(ExerciseInsight) _then) = _$ExerciseInsightCopyWithImpl;
@useResult
$Res call({
 String exerciseName, num currentE1rm, num previousE1rm, num e1rmChangePercent, num totalVolume, int sessionCount, ExerciseProgressStatus progressStatus, String recommendation
});




}
/// @nodoc
class _$ExerciseInsightCopyWithImpl<$Res>
    implements $ExerciseInsightCopyWith<$Res> {
  _$ExerciseInsightCopyWithImpl(this._self, this._then);

  final ExerciseInsight _self;
  final $Res Function(ExerciseInsight) _then;

/// Create a copy of ExerciseInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseName = null,Object? currentE1rm = null,Object? previousE1rm = null,Object? e1rmChangePercent = null,Object? totalVolume = null,Object? sessionCount = null,Object? progressStatus = null,Object? recommendation = null,}) {
  return _then(_self.copyWith(
exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,currentE1rm: null == currentE1rm ? _self.currentE1rm : currentE1rm // ignore: cast_nullable_to_non_nullable
as num,previousE1rm: null == previousE1rm ? _self.previousE1rm : previousE1rm // ignore: cast_nullable_to_non_nullable
as num,e1rmChangePercent: null == e1rmChangePercent ? _self.e1rmChangePercent : e1rmChangePercent // ignore: cast_nullable_to_non_nullable
as num,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as num,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,progressStatus: null == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as ExerciseProgressStatus,recommendation: null == recommendation ? _self.recommendation : recommendation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseInsight].
extension ExerciseInsightPatterns on ExerciseInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseInsight value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseInsight value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseName,  num currentE1rm,  num previousE1rm,  num e1rmChangePercent,  num totalVolume,  int sessionCount,  ExerciseProgressStatus progressStatus,  String recommendation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseInsight() when $default != null:
return $default(_that.exerciseName,_that.currentE1rm,_that.previousE1rm,_that.e1rmChangePercent,_that.totalVolume,_that.sessionCount,_that.progressStatus,_that.recommendation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseName,  num currentE1rm,  num previousE1rm,  num e1rmChangePercent,  num totalVolume,  int sessionCount,  ExerciseProgressStatus progressStatus,  String recommendation)  $default,) {final _that = this;
switch (_that) {
case _ExerciseInsight():
return $default(_that.exerciseName,_that.currentE1rm,_that.previousE1rm,_that.e1rmChangePercent,_that.totalVolume,_that.sessionCount,_that.progressStatus,_that.recommendation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseName,  num currentE1rm,  num previousE1rm,  num e1rmChangePercent,  num totalVolume,  int sessionCount,  ExerciseProgressStatus progressStatus,  String recommendation)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseInsight() when $default != null:
return $default(_that.exerciseName,_that.currentE1rm,_that.previousE1rm,_that.e1rmChangePercent,_that.totalVolume,_that.sessionCount,_that.progressStatus,_that.recommendation);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseInsight implements ExerciseInsight {
  const _ExerciseInsight({required this.exerciseName, required this.currentE1rm, required this.previousE1rm, required this.e1rmChangePercent, required this.totalVolume, required this.sessionCount, required this.progressStatus, required this.recommendation});
  

/// Exercise name.
@override final  String exerciseName;
/// Current estimated 1RM (average of last 2 weeks).
@override final  num currentE1rm;
/// Previous estimated 1RM (average of prior 2 weeks).
@override final  num previousE1rm;
/// Percentage change between current and previous e1RM.
@override final  num e1rmChangePercent;
/// Total volume (weight × reps) over the analysis period.
@override final  num totalVolume;
/// Number of sessions this exercise was performed in.
@override final  int sessionCount;
/// Progression status.
@override final  ExerciseProgressStatus progressStatus;
/// Specific recommendation for this exercise.
@override final  String recommendation;

/// Create a copy of ExerciseInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseInsightCopyWith<_ExerciseInsight> get copyWith => __$ExerciseInsightCopyWithImpl<_ExerciseInsight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseInsight&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.currentE1rm, currentE1rm) || other.currentE1rm == currentE1rm)&&(identical(other.previousE1rm, previousE1rm) || other.previousE1rm == previousE1rm)&&(identical(other.e1rmChangePercent, e1rmChangePercent) || other.e1rmChangePercent == e1rmChangePercent)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus)&&(identical(other.recommendation, recommendation) || other.recommendation == recommendation));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseName,currentE1rm,previousE1rm,e1rmChangePercent,totalVolume,sessionCount,progressStatus,recommendation);

@override
String toString() {
  return 'ExerciseInsight(exerciseName: $exerciseName, currentE1rm: $currentE1rm, previousE1rm: $previousE1rm, e1rmChangePercent: $e1rmChangePercent, totalVolume: $totalVolume, sessionCount: $sessionCount, progressStatus: $progressStatus, recommendation: $recommendation)';
}


}

/// @nodoc
abstract mixin class _$ExerciseInsightCopyWith<$Res> implements $ExerciseInsightCopyWith<$Res> {
  factory _$ExerciseInsightCopyWith(_ExerciseInsight value, $Res Function(_ExerciseInsight) _then) = __$ExerciseInsightCopyWithImpl;
@override @useResult
$Res call({
 String exerciseName, num currentE1rm, num previousE1rm, num e1rmChangePercent, num totalVolume, int sessionCount, ExerciseProgressStatus progressStatus, String recommendation
});




}
/// @nodoc
class __$ExerciseInsightCopyWithImpl<$Res>
    implements _$ExerciseInsightCopyWith<$Res> {
  __$ExerciseInsightCopyWithImpl(this._self, this._then);

  final _ExerciseInsight _self;
  final $Res Function(_ExerciseInsight) _then;

/// Create a copy of ExerciseInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseName = null,Object? currentE1rm = null,Object? previousE1rm = null,Object? e1rmChangePercent = null,Object? totalVolume = null,Object? sessionCount = null,Object? progressStatus = null,Object? recommendation = null,}) {
  return _then(_ExerciseInsight(
exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,currentE1rm: null == currentE1rm ? _self.currentE1rm : currentE1rm // ignore: cast_nullable_to_non_nullable
as num,previousE1rm: null == previousE1rm ? _self.previousE1rm : previousE1rm // ignore: cast_nullable_to_non_nullable
as num,e1rmChangePercent: null == e1rmChangePercent ? _self.e1rmChangePercent : e1rmChangePercent // ignore: cast_nullable_to_non_nullable
as num,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as num,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,progressStatus: null == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as ExerciseProgressStatus,recommendation: null == recommendation ? _self.recommendation : recommendation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
