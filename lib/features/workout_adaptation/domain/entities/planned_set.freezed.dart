// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planned_set.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlannedSet {

/// Planned weight for this set.
 num get weight;/// Planned repetitions for this set.
 num get repetitions;/// Number of sets at this configuration.
 num get sets;
/// Create a copy of PlannedSet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannedSetCopyWith<PlannedSet> get copyWith => _$PlannedSetCopyWithImpl<PlannedSet>(this as PlannedSet, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannedSet&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.sets, sets) || other.sets == sets));
}


@override
int get hashCode => Object.hash(runtimeType,weight,repetitions,sets);

@override
String toString() {
  return 'PlannedSet(weight: $weight, repetitions: $repetitions, sets: $sets)';
}


}

/// @nodoc
abstract mixin class $PlannedSetCopyWith<$Res>  {
  factory $PlannedSetCopyWith(PlannedSet value, $Res Function(PlannedSet) _then) = _$PlannedSetCopyWithImpl;
@useResult
$Res call({
 num weight, num repetitions, num sets
});




}
/// @nodoc
class _$PlannedSetCopyWithImpl<$Res>
    implements $PlannedSetCopyWith<$Res> {
  _$PlannedSetCopyWithImpl(this._self, this._then);

  final PlannedSet _self;
  final $Res Function(PlannedSet) _then;

/// Create a copy of PlannedSet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weight = null,Object? repetitions = null,Object? sets = null,}) {
  return _then(_self.copyWith(
weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as num,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as num,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [PlannedSet].
extension PlannedSetPatterns on PlannedSet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannedSet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannedSet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannedSet value)  $default,){
final _that = this;
switch (_that) {
case _PlannedSet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannedSet value)?  $default,){
final _that = this;
switch (_that) {
case _PlannedSet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num weight,  num repetitions,  num sets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannedSet() when $default != null:
return $default(_that.weight,_that.repetitions,_that.sets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num weight,  num repetitions,  num sets)  $default,) {final _that = this;
switch (_that) {
case _PlannedSet():
return $default(_that.weight,_that.repetitions,_that.sets);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num weight,  num repetitions,  num sets)?  $default,) {final _that = this;
switch (_that) {
case _PlannedSet() when $default != null:
return $default(_that.weight,_that.repetitions,_that.sets);case _:
  return null;

}
}

}

/// @nodoc


class _PlannedSet implements PlannedSet {
  const _PlannedSet({required this.weight, required this.repetitions, required this.sets});
  

/// Planned weight for this set.
@override final  num weight;
/// Planned repetitions for this set.
@override final  num repetitions;
/// Number of sets at this configuration.
@override final  num sets;

/// Create a copy of PlannedSet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannedSetCopyWith<_PlannedSet> get copyWith => __$PlannedSetCopyWithImpl<_PlannedSet>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannedSet&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.sets, sets) || other.sets == sets));
}


@override
int get hashCode => Object.hash(runtimeType,weight,repetitions,sets);

@override
String toString() {
  return 'PlannedSet(weight: $weight, repetitions: $repetitions, sets: $sets)';
}


}

/// @nodoc
abstract mixin class _$PlannedSetCopyWith<$Res> implements $PlannedSetCopyWith<$Res> {
  factory _$PlannedSetCopyWith(_PlannedSet value, $Res Function(_PlannedSet) _then) = __$PlannedSetCopyWithImpl;
@override @useResult
$Res call({
 num weight, num repetitions, num sets
});




}
/// @nodoc
class __$PlannedSetCopyWithImpl<$Res>
    implements _$PlannedSetCopyWith<$Res> {
  __$PlannedSetCopyWithImpl(this._self, this._then);

  final _PlannedSet _self;
  final $Res Function(_PlannedSet) _then;

/// Create a copy of PlannedSet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weight = null,Object? repetitions = null,Object? sets = null,}) {
  return _then(_PlannedSet(
weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as num,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as num,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
