// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_performance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExercisePerformance {

/// Internal exercise ID from wger.
 int get exerciseId;/// Human-readable exercise name.
 String get exerciseName;/// Individual sets performed for this exercise.
 List<ExerciseSet> get sets;/// Muscle groups targeted by this exercise (primary + secondary).
 List<String> get muscleNames;
/// Create a copy of ExercisePerformance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExercisePerformanceCopyWith<ExercisePerformance> get copyWith => _$ExercisePerformanceCopyWithImpl<ExercisePerformance>(this as ExercisePerformance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExercisePerformance&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&const DeepCollectionEquality().equals(other.sets, sets)&&const DeepCollectionEquality().equals(other.muscleNames, muscleNames));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseId,exerciseName,const DeepCollectionEquality().hash(sets),const DeepCollectionEquality().hash(muscleNames));

@override
String toString() {
  return 'ExercisePerformance(exerciseId: $exerciseId, exerciseName: $exerciseName, sets: $sets, muscleNames: $muscleNames)';
}


}

/// @nodoc
abstract mixin class $ExercisePerformanceCopyWith<$Res>  {
  factory $ExercisePerformanceCopyWith(ExercisePerformance value, $Res Function(ExercisePerformance) _then) = _$ExercisePerformanceCopyWithImpl;
@useResult
$Res call({
 int exerciseId, String exerciseName, List<ExerciseSet> sets, List<String> muscleNames
});




}
/// @nodoc
class _$ExercisePerformanceCopyWithImpl<$Res>
    implements $ExercisePerformanceCopyWith<$Res> {
  _$ExercisePerformanceCopyWithImpl(this._self, this._then);

  final ExercisePerformance _self;
  final $Res Function(ExercisePerformance) _then;

/// Create a copy of ExercisePerformance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? exerciseName = null,Object? sets = null,Object? muscleNames = null,}) {
  return _then(_self.copyWith(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as int,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<ExerciseSet>,muscleNames: null == muscleNames ? _self.muscleNames : muscleNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExercisePerformance].
extension ExercisePerformancePatterns on ExercisePerformance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExercisePerformance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExercisePerformance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExercisePerformance value)  $default,){
final _that = this;
switch (_that) {
case _ExercisePerformance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExercisePerformance value)?  $default,){
final _that = this;
switch (_that) {
case _ExercisePerformance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int exerciseId,  String exerciseName,  List<ExerciseSet> sets,  List<String> muscleNames)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExercisePerformance() when $default != null:
return $default(_that.exerciseId,_that.exerciseName,_that.sets,_that.muscleNames);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int exerciseId,  String exerciseName,  List<ExerciseSet> sets,  List<String> muscleNames)  $default,) {final _that = this;
switch (_that) {
case _ExercisePerformance():
return $default(_that.exerciseId,_that.exerciseName,_that.sets,_that.muscleNames);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int exerciseId,  String exerciseName,  List<ExerciseSet> sets,  List<String> muscleNames)?  $default,) {final _that = this;
switch (_that) {
case _ExercisePerformance() when $default != null:
return $default(_that.exerciseId,_that.exerciseName,_that.sets,_that.muscleNames);case _:
  return null;

}
}

}

/// @nodoc


class _ExercisePerformance implements ExercisePerformance {
  const _ExercisePerformance({required this.exerciseId, required this.exerciseName, required final  List<ExerciseSet> sets, final  List<String> muscleNames = const []}): _sets = sets,_muscleNames = muscleNames;
  

/// Internal exercise ID from wger.
@override final  int exerciseId;
/// Human-readable exercise name.
@override final  String exerciseName;
/// Individual sets performed for this exercise.
 final  List<ExerciseSet> _sets;
/// Individual sets performed for this exercise.
@override List<ExerciseSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

/// Muscle groups targeted by this exercise (primary + secondary).
 final  List<String> _muscleNames;
/// Muscle groups targeted by this exercise (primary + secondary).
@override@JsonKey() List<String> get muscleNames {
  if (_muscleNames is EqualUnmodifiableListView) return _muscleNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_muscleNames);
}


/// Create a copy of ExercisePerformance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExercisePerformanceCopyWith<_ExercisePerformance> get copyWith => __$ExercisePerformanceCopyWithImpl<_ExercisePerformance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExercisePerformance&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&const DeepCollectionEquality().equals(other._sets, _sets)&&const DeepCollectionEquality().equals(other._muscleNames, _muscleNames));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseId,exerciseName,const DeepCollectionEquality().hash(_sets),const DeepCollectionEquality().hash(_muscleNames));

@override
String toString() {
  return 'ExercisePerformance(exerciseId: $exerciseId, exerciseName: $exerciseName, sets: $sets, muscleNames: $muscleNames)';
}


}

/// @nodoc
abstract mixin class _$ExercisePerformanceCopyWith<$Res> implements $ExercisePerformanceCopyWith<$Res> {
  factory _$ExercisePerformanceCopyWith(_ExercisePerformance value, $Res Function(_ExercisePerformance) _then) = __$ExercisePerformanceCopyWithImpl;
@override @useResult
$Res call({
 int exerciseId, String exerciseName, List<ExerciseSet> sets, List<String> muscleNames
});




}
/// @nodoc
class __$ExercisePerformanceCopyWithImpl<$Res>
    implements _$ExercisePerformanceCopyWith<$Res> {
  __$ExercisePerformanceCopyWithImpl(this._self, this._then);

  final _ExercisePerformance _self;
  final $Res Function(_ExercisePerformance) _then;

/// Create a copy of ExercisePerformance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? exerciseName = null,Object? sets = null,Object? muscleNames = null,}) {
  return _then(_ExercisePerformance(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as int,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<ExerciseSet>,muscleNames: null == muscleNames ? _self._muscleNames : muscleNames // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
