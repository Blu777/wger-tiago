// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planned_exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlannedExercise {

/// Exercise ID.
 int get exerciseId;/// Exercise display name.
 String get exerciseName;/// Muscle groups targeted (primary + secondary).
 List<String> get muscleNames;/// Planned sets for this exercise.
 List<PlannedSet> get plannedSets;
/// Create a copy of PlannedExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannedExerciseCopyWith<PlannedExercise> get copyWith => _$PlannedExerciseCopyWithImpl<PlannedExercise>(this as PlannedExercise, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannedExercise&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&const DeepCollectionEquality().equals(other.muscleNames, muscleNames)&&const DeepCollectionEquality().equals(other.plannedSets, plannedSets));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseId,exerciseName,const DeepCollectionEquality().hash(muscleNames),const DeepCollectionEquality().hash(plannedSets));

@override
String toString() {
  return 'PlannedExercise(exerciseId: $exerciseId, exerciseName: $exerciseName, muscleNames: $muscleNames, plannedSets: $plannedSets)';
}


}

/// @nodoc
abstract mixin class $PlannedExerciseCopyWith<$Res>  {
  factory $PlannedExerciseCopyWith(PlannedExercise value, $Res Function(PlannedExercise) _then) = _$PlannedExerciseCopyWithImpl;
@useResult
$Res call({
 int exerciseId, String exerciseName, List<String> muscleNames, List<PlannedSet> plannedSets
});




}
/// @nodoc
class _$PlannedExerciseCopyWithImpl<$Res>
    implements $PlannedExerciseCopyWith<$Res> {
  _$PlannedExerciseCopyWithImpl(this._self, this._then);

  final PlannedExercise _self;
  final $Res Function(PlannedExercise) _then;

/// Create a copy of PlannedExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exerciseId = null,Object? exerciseName = null,Object? muscleNames = null,Object? plannedSets = null,}) {
  return _then(_self.copyWith(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as int,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,muscleNames: null == muscleNames ? _self.muscleNames : muscleNames // ignore: cast_nullable_to_non_nullable
as List<String>,plannedSets: null == plannedSets ? _self.plannedSets : plannedSets // ignore: cast_nullable_to_non_nullable
as List<PlannedSet>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannedExercise].
extension PlannedExercisePatterns on PlannedExercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannedExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannedExercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannedExercise value)  $default,){
final _that = this;
switch (_that) {
case _PlannedExercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannedExercise value)?  $default,){
final _that = this;
switch (_that) {
case _PlannedExercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int exerciseId,  String exerciseName,  List<String> muscleNames,  List<PlannedSet> plannedSets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannedExercise() when $default != null:
return $default(_that.exerciseId,_that.exerciseName,_that.muscleNames,_that.plannedSets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int exerciseId,  String exerciseName,  List<String> muscleNames,  List<PlannedSet> plannedSets)  $default,) {final _that = this;
switch (_that) {
case _PlannedExercise():
return $default(_that.exerciseId,_that.exerciseName,_that.muscleNames,_that.plannedSets);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int exerciseId,  String exerciseName,  List<String> muscleNames,  List<PlannedSet> plannedSets)?  $default,) {final _that = this;
switch (_that) {
case _PlannedExercise() when $default != null:
return $default(_that.exerciseId,_that.exerciseName,_that.muscleNames,_that.plannedSets);case _:
  return null;

}
}

}

/// @nodoc


class _PlannedExercise implements PlannedExercise {
  const _PlannedExercise({required this.exerciseId, required this.exerciseName, final  List<String> muscleNames = const [], final  List<PlannedSet> plannedSets = const []}): _muscleNames = muscleNames,_plannedSets = plannedSets;
  

/// Exercise ID.
@override final  int exerciseId;
/// Exercise display name.
@override final  String exerciseName;
/// Muscle groups targeted (primary + secondary).
 final  List<String> _muscleNames;
/// Muscle groups targeted (primary + secondary).
@override@JsonKey() List<String> get muscleNames {
  if (_muscleNames is EqualUnmodifiableListView) return _muscleNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_muscleNames);
}

/// Planned sets for this exercise.
 final  List<PlannedSet> _plannedSets;
/// Planned sets for this exercise.
@override@JsonKey() List<PlannedSet> get plannedSets {
  if (_plannedSets is EqualUnmodifiableListView) return _plannedSets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plannedSets);
}


/// Create a copy of PlannedExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannedExerciseCopyWith<_PlannedExercise> get copyWith => __$PlannedExerciseCopyWithImpl<_PlannedExercise>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannedExercise&&(identical(other.exerciseId, exerciseId) || other.exerciseId == exerciseId)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&const DeepCollectionEquality().equals(other._muscleNames, _muscleNames)&&const DeepCollectionEquality().equals(other._plannedSets, _plannedSets));
}


@override
int get hashCode => Object.hash(runtimeType,exerciseId,exerciseName,const DeepCollectionEquality().hash(_muscleNames),const DeepCollectionEquality().hash(_plannedSets));

@override
String toString() {
  return 'PlannedExercise(exerciseId: $exerciseId, exerciseName: $exerciseName, muscleNames: $muscleNames, plannedSets: $plannedSets)';
}


}

/// @nodoc
abstract mixin class _$PlannedExerciseCopyWith<$Res> implements $PlannedExerciseCopyWith<$Res> {
  factory _$PlannedExerciseCopyWith(_PlannedExercise value, $Res Function(_PlannedExercise) _then) = __$PlannedExerciseCopyWithImpl;
@override @useResult
$Res call({
 int exerciseId, String exerciseName, List<String> muscleNames, List<PlannedSet> plannedSets
});




}
/// @nodoc
class __$PlannedExerciseCopyWithImpl<$Res>
    implements _$PlannedExerciseCopyWith<$Res> {
  __$PlannedExerciseCopyWithImpl(this._self, this._then);

  final _PlannedExercise _self;
  final $Res Function(_PlannedExercise) _then;

/// Create a copy of PlannedExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exerciseId = null,Object? exerciseName = null,Object? muscleNames = null,Object? plannedSets = null,}) {
  return _then(_PlannedExercise(
exerciseId: null == exerciseId ? _self.exerciseId : exerciseId // ignore: cast_nullable_to_non_nullable
as int,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,muscleNames: null == muscleNames ? _self._muscleNames : muscleNames // ignore: cast_nullable_to_non_nullable
as List<String>,plannedSets: null == plannedSets ? _self._plannedSets : plannedSets // ignore: cast_nullable_to_non_nullable
as List<PlannedSet>,
  ));
}


}

// dart format on
