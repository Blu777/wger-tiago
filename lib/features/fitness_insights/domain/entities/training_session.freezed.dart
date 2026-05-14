// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrainingSession {

/// Date when the session was performed.
 DateTime get date;/// Exercises performed in this session.
 List<ExercisePerformance> get exercises;/// Optional subjective impression (1=bad, 2=neutral, 3=good).
/// Sourced from [WorkoutSession.impression].
 int? get impression;/// Optional session duration in minutes.
 int? get durationMinutes;
/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrainingSessionCopyWith<TrainingSession> get copyWith => _$TrainingSessionCopyWithImpl<TrainingSession>(this as TrainingSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrainingSession&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.exercises, exercises)&&(identical(other.impression, impression) || other.impression == impression)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(exercises),impression,durationMinutes);

@override
String toString() {
  return 'TrainingSession(date: $date, exercises: $exercises, impression: $impression, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $TrainingSessionCopyWith<$Res>  {
  factory $TrainingSessionCopyWith(TrainingSession value, $Res Function(TrainingSession) _then) = _$TrainingSessionCopyWithImpl;
@useResult
$Res call({
 DateTime date, List<ExercisePerformance> exercises, int? impression, int? durationMinutes
});




}
/// @nodoc
class _$TrainingSessionCopyWithImpl<$Res>
    implements $TrainingSessionCopyWith<$Res> {
  _$TrainingSessionCopyWithImpl(this._self, this._then);

  final TrainingSession _self;
  final $Res Function(TrainingSession) _then;

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? exercises = null,Object? impression = freezed,Object? durationMinutes = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<ExercisePerformance>,impression: freezed == impression ? _self.impression : impression // ignore: cast_nullable_to_non_nullable
as int?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrainingSession].
extension TrainingSessionPatterns on TrainingSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrainingSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrainingSession value)  $default,){
final _that = this;
switch (_that) {
case _TrainingSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrainingSession value)?  $default,){
final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  List<ExercisePerformance> exercises,  int? impression,  int? durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
return $default(_that.date,_that.exercises,_that.impression,_that.durationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  List<ExercisePerformance> exercises,  int? impression,  int? durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _TrainingSession():
return $default(_that.date,_that.exercises,_that.impression,_that.durationMinutes);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  List<ExercisePerformance> exercises,  int? impression,  int? durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _TrainingSession() when $default != null:
return $default(_that.date,_that.exercises,_that.impression,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _TrainingSession implements TrainingSession {
  const _TrainingSession({required this.date, required final  List<ExercisePerformance> exercises, this.impression, this.durationMinutes}): _exercises = exercises;
  

/// Date when the session was performed.
@override final  DateTime date;
/// Exercises performed in this session.
 final  List<ExercisePerformance> _exercises;
/// Exercises performed in this session.
@override List<ExercisePerformance> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}

/// Optional subjective impression (1=bad, 2=neutral, 3=good).
/// Sourced from [WorkoutSession.impression].
@override final  int? impression;
/// Optional session duration in minutes.
@override final  int? durationMinutes;

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrainingSessionCopyWith<_TrainingSession> get copyWith => __$TrainingSessionCopyWithImpl<_TrainingSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrainingSession&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._exercises, _exercises)&&(identical(other.impression, impression) || other.impression == impression)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_exercises),impression,durationMinutes);

@override
String toString() {
  return 'TrainingSession(date: $date, exercises: $exercises, impression: $impression, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$TrainingSessionCopyWith<$Res> implements $TrainingSessionCopyWith<$Res> {
  factory _$TrainingSessionCopyWith(_TrainingSession value, $Res Function(_TrainingSession) _then) = __$TrainingSessionCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, List<ExercisePerformance> exercises, int? impression, int? durationMinutes
});




}
/// @nodoc
class __$TrainingSessionCopyWithImpl<$Res>
    implements _$TrainingSessionCopyWith<$Res> {
  __$TrainingSessionCopyWithImpl(this._self, this._then);

  final _TrainingSession _self;
  final $Res Function(_TrainingSession) _then;

/// Create a copy of TrainingSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? exercises = null,Object? impression = freezed,Object? durationMinutes = freezed,}) {
  return _then(_TrainingSession(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<ExercisePerformance>,impression: freezed == impression ? _self.impression : impression // ignore: cast_nullable_to_non_nullable
as int?,durationMinutes: freezed == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
