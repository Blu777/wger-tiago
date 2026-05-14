// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pre_workout_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PreWorkoutInput {

/// Per-muscle pain level (0–10). Key = muscle name, Value = pain score.
 Map<String, int> get painByMuscle;/// Overall subjective fatigue (0–10).
 num get fatigue;
/// Create a copy of PreWorkoutInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PreWorkoutInputCopyWith<PreWorkoutInput> get copyWith => _$PreWorkoutInputCopyWithImpl<PreWorkoutInput>(this as PreWorkoutInput, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PreWorkoutInput&&const DeepCollectionEquality().equals(other.painByMuscle, painByMuscle)&&(identical(other.fatigue, fatigue) || other.fatigue == fatigue));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(painByMuscle),fatigue);

@override
String toString() {
  return 'PreWorkoutInput(painByMuscle: $painByMuscle, fatigue: $fatigue)';
}


}

/// @nodoc
abstract mixin class $PreWorkoutInputCopyWith<$Res>  {
  factory $PreWorkoutInputCopyWith(PreWorkoutInput value, $Res Function(PreWorkoutInput) _then) = _$PreWorkoutInputCopyWithImpl;
@useResult
$Res call({
 Map<String, int> painByMuscle, num fatigue
});




}
/// @nodoc
class _$PreWorkoutInputCopyWithImpl<$Res>
    implements $PreWorkoutInputCopyWith<$Res> {
  _$PreWorkoutInputCopyWithImpl(this._self, this._then);

  final PreWorkoutInput _self;
  final $Res Function(PreWorkoutInput) _then;

/// Create a copy of PreWorkoutInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? painByMuscle = null,Object? fatigue = null,}) {
  return _then(_self.copyWith(
painByMuscle: null == painByMuscle ? _self.painByMuscle : painByMuscle // ignore: cast_nullable_to_non_nullable
as Map<String, int>,fatigue: null == fatigue ? _self.fatigue : fatigue // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [PreWorkoutInput].
extension PreWorkoutInputPatterns on PreWorkoutInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PreWorkoutInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PreWorkoutInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PreWorkoutInput value)  $default,){
final _that = this;
switch (_that) {
case _PreWorkoutInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PreWorkoutInput value)?  $default,){
final _that = this;
switch (_that) {
case _PreWorkoutInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, int> painByMuscle,  num fatigue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PreWorkoutInput() when $default != null:
return $default(_that.painByMuscle,_that.fatigue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, int> painByMuscle,  num fatigue)  $default,) {final _that = this;
switch (_that) {
case _PreWorkoutInput():
return $default(_that.painByMuscle,_that.fatigue);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, int> painByMuscle,  num fatigue)?  $default,) {final _that = this;
switch (_that) {
case _PreWorkoutInput() when $default != null:
return $default(_that.painByMuscle,_that.fatigue);case _:
  return null;

}
}

}

/// @nodoc


class _PreWorkoutInput implements PreWorkoutInput {
  const _PreWorkoutInput({final  Map<String, int> painByMuscle = const {}, this.fatigue = 0}): _painByMuscle = painByMuscle;
  

/// Per-muscle pain level (0–10). Key = muscle name, Value = pain score.
 final  Map<String, int> _painByMuscle;
/// Per-muscle pain level (0–10). Key = muscle name, Value = pain score.
@override@JsonKey() Map<String, int> get painByMuscle {
  if (_painByMuscle is EqualUnmodifiableMapView) return _painByMuscle;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_painByMuscle);
}

/// Overall subjective fatigue (0–10).
@override@JsonKey() final  num fatigue;

/// Create a copy of PreWorkoutInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PreWorkoutInputCopyWith<_PreWorkoutInput> get copyWith => __$PreWorkoutInputCopyWithImpl<_PreWorkoutInput>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PreWorkoutInput&&const DeepCollectionEquality().equals(other._painByMuscle, _painByMuscle)&&(identical(other.fatigue, fatigue) || other.fatigue == fatigue));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_painByMuscle),fatigue);

@override
String toString() {
  return 'PreWorkoutInput(painByMuscle: $painByMuscle, fatigue: $fatigue)';
}


}

/// @nodoc
abstract mixin class _$PreWorkoutInputCopyWith<$Res> implements $PreWorkoutInputCopyWith<$Res> {
  factory _$PreWorkoutInputCopyWith(_PreWorkoutInput value, $Res Function(_PreWorkoutInput) _then) = __$PreWorkoutInputCopyWithImpl;
@override @useResult
$Res call({
 Map<String, int> painByMuscle, num fatigue
});




}
/// @nodoc
class __$PreWorkoutInputCopyWithImpl<$Res>
    implements _$PreWorkoutInputCopyWith<$Res> {
  __$PreWorkoutInputCopyWithImpl(this._self, this._then);

  final _PreWorkoutInput _self;
  final $Res Function(_PreWorkoutInput) _then;

/// Create a copy of PreWorkoutInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? painByMuscle = null,Object? fatigue = null,}) {
  return _then(_PreWorkoutInput(
painByMuscle: null == painByMuscle ? _self._painByMuscle : painByMuscle // ignore: cast_nullable_to_non_nullable
as Map<String, int>,fatigue: null == fatigue ? _self.fatigue : fatigue // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
