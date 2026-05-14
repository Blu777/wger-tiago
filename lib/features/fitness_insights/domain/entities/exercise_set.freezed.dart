// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseSet {

/// Weight lifted in this set (kg or lb).
 num get weight;/// Repetitions performed in this set.
 num get repetitions;
/// Create a copy of ExerciseSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseSetCopyWith<ExerciseSet> get copyWith => _$ExerciseSetCopyWithImpl<ExerciseSet>(this as ExerciseSet, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseSet&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions));
}


@override
int get hashCode => Object.hash(runtimeType,weight,repetitions);

@override
String toString() {
  return 'ExerciseSet(weight: $weight, repetitions: $repetitions)';
}


}

/// @nodoc
abstract mixin class $ExerciseSetCopyWith<$Res>  {
  factory $ExerciseSetCopyWith(ExerciseSet value, $Res Function(ExerciseSet) _then) = _$ExerciseSetCopyWithImpl;
@useResult
$Res call({
 num weight, num repetitions
});




}
/// @nodoc
class _$ExerciseSetCopyWithImpl<$Res>
    implements $ExerciseSetCopyWith<$Res> {
  _$ExerciseSetCopyWithImpl(this._self, this._then);

  final ExerciseSet _self;
  final $Res Function(ExerciseSet) _then;

/// Create a copy of ExerciseSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weight = null,Object? repetitions = null,}) {
  return _then(_self.copyWith(
weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as num,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseSet].
extension ExerciseSetPatterns on ExerciseSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseSet value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseSet value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num weight,  num repetitions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseSet() when $default != null:
return $default(_that.weight,_that.repetitions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num weight,  num repetitions)  $default,) {final _that = this;
switch (_that) {
case _ExerciseSet():
return $default(_that.weight,_that.repetitions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num weight,  num repetitions)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseSet() when $default != null:
return $default(_that.weight,_that.repetitions);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseSet implements ExerciseSet {
  const _ExerciseSet({required this.weight, required this.repetitions});
  

/// Weight lifted in this set (kg or lb).
@override final  num weight;
/// Repetitions performed in this set.
@override final  num repetitions;

/// Create a copy of ExerciseSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseSetCopyWith<_ExerciseSet> get copyWith => __$ExerciseSetCopyWithImpl<_ExerciseSet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseSet&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions));
}


@override
int get hashCode => Object.hash(runtimeType,weight,repetitions);

@override
String toString() {
  return 'ExerciseSet(weight: $weight, repetitions: $repetitions)';
}


}

/// @nodoc
abstract mixin class _$ExerciseSetCopyWith<$Res> implements $ExerciseSetCopyWith<$Res> {
  factory _$ExerciseSetCopyWith(_ExerciseSet value, $Res Function(_ExerciseSet) _then) = __$ExerciseSetCopyWithImpl;
@override @useResult
$Res call({
 num weight, num repetitions
});




}
/// @nodoc
class __$ExerciseSetCopyWithImpl<$Res>
    implements _$ExerciseSetCopyWith<$Res> {
  __$ExerciseSetCopyWithImpl(this._self, this._then);

  final _ExerciseSet _self;
  final $Res Function(_ExerciseSet) _then;

/// Create a copy of ExerciseSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weight = null,Object? repetitions = null,}) {
  return _then(_ExerciseSet(
weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as num,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
