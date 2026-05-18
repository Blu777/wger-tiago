// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_adherence.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseAdherence {

 String get exerciseName;/// Weight the coach recommended for this exercise.
 num get plannedWeight;/// Weight the user actually logged.
 num get executedWeight;/// Reps the coach recommended.
 num get plannedReps;/// Reps the user actually logged.
 num get executedReps;/// Whether the user overrode the coach recommendation.
 bool get wasOverridden;
/// Create a copy of ExerciseAdherence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseAdherenceCopyWith<ExerciseAdherence> get copyWith => _$ExerciseAdherenceCopyWithImpl<ExerciseAdherence>(this as ExerciseAdherence, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseAdherence&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.plannedWeight, plannedWeight) || other.plannedWeight == plannedWeight)&&(identical(other.executedWeight, executedWeight) || other.executedWeight == executedWeight)&&(identical(other.plannedReps, plannedReps) || other.plannedReps == plannedReps)&&(identical(other.executedReps, executedReps) || other.executedReps == executedReps)&&(identical(other.wasOverridden, wasOverridden) || other.wasOverridden == wasOverridden));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseName,plannedWeight,executedWeight,plannedReps,executedReps,wasOverridden);

@override
String toString() {
  return 'ExerciseAdherence(exerciseName: $exerciseName, plannedWeight: $plannedWeight, executedWeight: $executedWeight, plannedReps: $plannedReps, executedReps: $executedReps, wasOverridden: $wasOverridden)';
}


}

/// @nodoc
abstract mixin class $ExerciseAdherenceCopyWith<$Res>  {
  factory $ExerciseAdherenceCopyWith(ExerciseAdherence value, $Res Function(ExerciseAdherence) _then) = _$ExerciseAdherenceCopyWithImpl;
@useResult
$Res call({
 String exerciseName, num plannedWeight, num executedWeight, num plannedReps, num executedReps, bool wasOverridden
});




}
/// @nodoc
class _$ExerciseAdherenceCopyWithImpl<$Res>
    implements $ExerciseAdherenceCopyWith<$Res> {
  _$ExerciseAdherenceCopyWithImpl(this._self, this._then);

  final ExerciseAdherence _self;
  final $Res Function(ExerciseAdherence) _then;

/// Create a copy of ExerciseAdherence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseName = null,Object? plannedWeight = null,Object? executedWeight = null,Object? plannedReps = null,Object? executedReps = null,Object? wasOverridden = null,}) {
  return _then(_self.copyWith(
exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,plannedWeight: null == plannedWeight ? _self.plannedWeight : plannedWeight // ignore: cast_nullable_to_non_nullable
as num,executedWeight: null == executedWeight ? _self.executedWeight : executedWeight // ignore: cast_nullable_to_non_nullable
as num,plannedReps: null == plannedReps ? _self.plannedReps : plannedReps // ignore: cast_nullable_to_non_nullable
as num,executedReps: null == executedReps ? _self.executedReps : executedReps // ignore: cast_nullable_to_non_nullable
as num,wasOverridden: null == wasOverridden ? _self.wasOverridden : wasOverridden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseAdherence].
extension ExerciseAdherencePatterns on ExerciseAdherence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseAdherence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseAdherence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseAdherence value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseAdherence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseAdherence value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseAdherence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String exerciseName,  num plannedWeight,  num executedWeight,  num plannedReps,  num executedReps,  bool wasOverridden)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseAdherence() when $default != null:
return $default(_that.exerciseName,_that.plannedWeight,_that.executedWeight,_that.plannedReps,_that.executedReps,_that.wasOverridden);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String exerciseName,  num plannedWeight,  num executedWeight,  num plannedReps,  num executedReps,  bool wasOverridden)  $default,) {final _that = this;
switch (_that) {
case _ExerciseAdherence():
return $default(_that.exerciseName,_that.plannedWeight,_that.executedWeight,_that.plannedReps,_that.executedReps,_that.wasOverridden);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String exerciseName,  num plannedWeight,  num executedWeight,  num plannedReps,  num executedReps,  bool wasOverridden)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseAdherence() when $default != null:
return $default(_that.exerciseName,_that.plannedWeight,_that.executedWeight,_that.plannedReps,_that.executedReps,_that.wasOverridden);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseAdherence implements ExerciseAdherence {
  const _ExerciseAdherence({required this.exerciseName, required this.plannedWeight, required this.executedWeight, required this.plannedReps, required this.executedReps, this.wasOverridden = false});
  

@override final  String exerciseName;
/// Weight the coach recommended for this exercise.
@override final  num plannedWeight;
/// Weight the user actually logged.
@override final  num executedWeight;
/// Reps the coach recommended.
@override final  num plannedReps;
/// Reps the user actually logged.
@override final  num executedReps;
/// Whether the user overrode the coach recommendation.
@override@JsonKey() final  bool wasOverridden;

/// Create a copy of ExerciseAdherence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseAdherenceCopyWith<_ExerciseAdherence> get copyWith => __$ExerciseAdherenceCopyWithImpl<_ExerciseAdherence>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseAdherence&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.plannedWeight, plannedWeight) || other.plannedWeight == plannedWeight)&&(identical(other.executedWeight, executedWeight) || other.executedWeight == executedWeight)&&(identical(other.plannedReps, plannedReps) || other.plannedReps == plannedReps)&&(identical(other.executedReps, executedReps) || other.executedReps == executedReps)&&(identical(other.wasOverridden, wasOverridden) || other.wasOverridden == wasOverridden));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseName,plannedWeight,executedWeight,plannedReps,executedReps,wasOverridden);

@override
String toString() {
  return 'ExerciseAdherence(exerciseName: $exerciseName, plannedWeight: $plannedWeight, executedWeight: $executedWeight, plannedReps: $plannedReps, executedReps: $executedReps, wasOverridden: $wasOverridden)';
}


}

/// @nodoc
abstract mixin class _$ExerciseAdherenceCopyWith<$Res> implements $ExerciseAdherenceCopyWith<$Res> {
  factory _$ExerciseAdherenceCopyWith(_ExerciseAdherence value, $Res Function(_ExerciseAdherence) _then) = __$ExerciseAdherenceCopyWithImpl;
@override @useResult
$Res call({
 String exerciseName, num plannedWeight, num executedWeight, num plannedReps, num executedReps, bool wasOverridden
});




}
/// @nodoc
class __$ExerciseAdherenceCopyWithImpl<$Res>
    implements _$ExerciseAdherenceCopyWith<$Res> {
  __$ExerciseAdherenceCopyWithImpl(this._self, this._then);

  final _ExerciseAdherence _self;
  final $Res Function(_ExerciseAdherence) _then;

/// Create a copy of ExerciseAdherence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseName = null,Object? plannedWeight = null,Object? executedWeight = null,Object? plannedReps = null,Object? executedReps = null,Object? wasOverridden = null,}) {
  return _then(_ExerciseAdherence(
exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,plannedWeight: null == plannedWeight ? _self.plannedWeight : plannedWeight // ignore: cast_nullable_to_non_nullable
as num,executedWeight: null == executedWeight ? _self.executedWeight : executedWeight // ignore: cast_nullable_to_non_nullable
as num,plannedReps: null == plannedReps ? _self.plannedReps : plannedReps // ignore: cast_nullable_to_non_nullable
as num,executedReps: null == executedReps ? _self.executedReps : executedReps // ignore: cast_nullable_to_non_nullable
as num,wasOverridden: null == wasOverridden ? _self.wasOverridden : wasOverridden // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SessionAdherence {

/// Date of the session.
 DateTime get date;/// Whether the session was coach-adapted.
 bool get wasAdapted;/// Per-exercise adherence details.
 List<ExerciseAdherence> get exercises;/// Overall adherence score (0-100).
/// 100 = user followed every recommendation exactly.
 num get overallScore;/// How many exercises the user overrode vs total.
 int get overrideCount;/// Total number of tracked exercises.
 int get totalExercises;
/// Create a copy of SessionAdherence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionAdherenceCopyWith<SessionAdherence> get copyWith => _$SessionAdherenceCopyWithImpl<SessionAdherence>(this as SessionAdherence, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionAdherence&&(identical(other.date, date) || other.date == date)&&(identical(other.wasAdapted, wasAdapted) || other.wasAdapted == wasAdapted)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&(identical(other.overrideCount, overrideCount) || other.overrideCount == overrideCount)&&(identical(other.totalExercises, totalExercises) || other.totalExercises == totalExercises));
}


@override
int get hashCode => Object.hash(runtimeType,date,wasAdapted,const DeepCollectionEquality().hash(exercises),overallScore,overrideCount,totalExercises);

@override
String toString() {
  return 'SessionAdherence(date: $date, wasAdapted: $wasAdapted, exercises: $exercises, overallScore: $overallScore, overrideCount: $overrideCount, totalExercises: $totalExercises)';
}


}

/// @nodoc
abstract mixin class $SessionAdherenceCopyWith<$Res>  {
  factory $SessionAdherenceCopyWith(SessionAdherence value, $Res Function(SessionAdherence) _then) = _$SessionAdherenceCopyWithImpl;
@useResult
$Res call({
 DateTime date, bool wasAdapted, List<ExerciseAdherence> exercises, num overallScore, int overrideCount, int totalExercises
});




}
/// @nodoc
class _$SessionAdherenceCopyWithImpl<$Res>
    implements $SessionAdherenceCopyWith<$Res> {
  _$SessionAdherenceCopyWithImpl(this._self, this._then);

  final SessionAdherence _self;
  final $Res Function(SessionAdherence) _then;

/// Create a copy of SessionAdherence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? wasAdapted = null,Object? exercises = null,Object? overallScore = null,Object? overrideCount = null,Object? totalExercises = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,wasAdapted: null == wasAdapted ? _self.wasAdapted : wasAdapted // ignore: cast_nullable_to_non_nullable
as bool,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseAdherence>,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as num,overrideCount: null == overrideCount ? _self.overrideCount : overrideCount // ignore: cast_nullable_to_non_nullable
as int,totalExercises: null == totalExercises ? _self.totalExercises : totalExercises // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionAdherence].
extension SessionAdherencePatterns on SessionAdherence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionAdherence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionAdherence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionAdherence value)  $default,){
final _that = this;
switch (_that) {
case _SessionAdherence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionAdherence value)?  $default,){
final _that = this;
switch (_that) {
case _SessionAdherence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  bool wasAdapted,  List<ExerciseAdherence> exercises,  num overallScore,  int overrideCount,  int totalExercises)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionAdherence() when $default != null:
return $default(_that.date,_that.wasAdapted,_that.exercises,_that.overallScore,_that.overrideCount,_that.totalExercises);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  bool wasAdapted,  List<ExerciseAdherence> exercises,  num overallScore,  int overrideCount,  int totalExercises)  $default,) {final _that = this;
switch (_that) {
case _SessionAdherence():
return $default(_that.date,_that.wasAdapted,_that.exercises,_that.overallScore,_that.overrideCount,_that.totalExercises);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  bool wasAdapted,  List<ExerciseAdherence> exercises,  num overallScore,  int overrideCount,  int totalExercises)?  $default,) {final _that = this;
switch (_that) {
case _SessionAdherence() when $default != null:
return $default(_that.date,_that.wasAdapted,_that.exercises,_that.overallScore,_that.overrideCount,_that.totalExercises);case _:
  return null;

}
}

}

/// @nodoc


class _SessionAdherence implements SessionAdherence {
  const _SessionAdherence({required this.date, required this.wasAdapted, final  List<ExerciseAdherence> exercises = const [], required this.overallScore, this.overrideCount = 0, this.totalExercises = 0}): _exercises = exercises;
  

/// Date of the session.
@override final  DateTime date;
/// Whether the session was coach-adapted.
@override final  bool wasAdapted;
/// Per-exercise adherence details.
 final  List<ExerciseAdherence> _exercises;
/// Per-exercise adherence details.
@override@JsonKey() List<ExerciseAdherence> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

/// Overall adherence score (0-100).
/// 100 = user followed every recommendation exactly.
@override final  num overallScore;
/// How many exercises the user overrode vs total.
@override@JsonKey() final  int overrideCount;
/// Total number of tracked exercises.
@override@JsonKey() final  int totalExercises;

/// Create a copy of SessionAdherence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionAdherenceCopyWith<_SessionAdherence> get copyWith => __$SessionAdherenceCopyWithImpl<_SessionAdherence>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionAdherence&&(identical(other.date, date) || other.date == date)&&(identical(other.wasAdapted, wasAdapted) || other.wasAdapted == wasAdapted)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.overallScore, overallScore) || other.overallScore == overallScore)&&(identical(other.overrideCount, overrideCount) || other.overrideCount == overrideCount)&&(identical(other.totalExercises, totalExercises) || other.totalExercises == totalExercises));
}


@override
int get hashCode => Object.hash(runtimeType,date,wasAdapted,const DeepCollectionEquality().hash(_exercises),overallScore,overrideCount,totalExercises);

@override
String toString() {
  return 'SessionAdherence(date: $date, wasAdapted: $wasAdapted, exercises: $exercises, overallScore: $overallScore, overrideCount: $overrideCount, totalExercises: $totalExercises)';
}


}

/// @nodoc
abstract mixin class _$SessionAdherenceCopyWith<$Res> implements $SessionAdherenceCopyWith<$Res> {
  factory _$SessionAdherenceCopyWith(_SessionAdherence value, $Res Function(_SessionAdherence) _then) = __$SessionAdherenceCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, bool wasAdapted, List<ExerciseAdherence> exercises, num overallScore, int overrideCount, int totalExercises
});




}
/// @nodoc
class __$SessionAdherenceCopyWithImpl<$Res>
    implements _$SessionAdherenceCopyWith<$Res> {
  __$SessionAdherenceCopyWithImpl(this._self, this._then);

  final _SessionAdherence _self;
  final $Res Function(_SessionAdherence) _then;

/// Create a copy of SessionAdherence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? wasAdapted = null,Object? exercises = null,Object? overallScore = null,Object? overrideCount = null,Object? totalExercises = null,}) {
  return _then(_SessionAdherence(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,wasAdapted: null == wasAdapted ? _self.wasAdapted : wasAdapted // ignore: cast_nullable_to_non_nullable
as bool,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<ExerciseAdherence>,overallScore: null == overallScore ? _self.overallScore : overallScore // ignore: cast_nullable_to_non_nullable
as num,overrideCount: null == overrideCount ? _self.overrideCount : overrideCount // ignore: cast_nullable_to_non_nullable
as int,totalExercises: null == totalExercises ? _self.totalExercises : totalExercises // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
