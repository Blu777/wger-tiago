// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adapted_workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdaptedWorkout {

/// Ordered list of modifications per exercise.
 List<ExerciseModification> get modifications;/// Human-readable summary of what changed and why.
 String get summary;
/// Create a copy of AdaptedWorkout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdaptedWorkoutCopyWith<AdaptedWorkout> get copyWith => _$AdaptedWorkoutCopyWithImpl<AdaptedWorkout>(this as AdaptedWorkout, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdaptedWorkout&&const DeepCollectionEquality().equals(other.modifications, modifications)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(modifications),summary);

@override
String toString() {
  return 'AdaptedWorkout(modifications: $modifications, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $AdaptedWorkoutCopyWith<$Res>  {
  factory $AdaptedWorkoutCopyWith(AdaptedWorkout value, $Res Function(AdaptedWorkout) _then) = _$AdaptedWorkoutCopyWithImpl;
@useResult
$Res call({
 List<ExerciseModification> modifications, String summary
});




}
/// @nodoc
class _$AdaptedWorkoutCopyWithImpl<$Res>
    implements $AdaptedWorkoutCopyWith<$Res> {
  _$AdaptedWorkoutCopyWithImpl(this._self, this._then);

  final AdaptedWorkout _self;
  final $Res Function(AdaptedWorkout) _then;

/// Create a copy of AdaptedWorkout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? modifications = null,Object? summary = null,}) {
  return _then(_self.copyWith(
modifications: null == modifications ? _self.modifications : modifications // ignore: cast_nullable_to_non_nullable
as List<ExerciseModification>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AdaptedWorkout].
extension AdaptedWorkoutPatterns on AdaptedWorkout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdaptedWorkout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdaptedWorkout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdaptedWorkout value)  $default,){
final _that = this;
switch (_that) {
case _AdaptedWorkout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdaptedWorkout value)?  $default,){
final _that = this;
switch (_that) {
case _AdaptedWorkout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ExerciseModification> modifications,  String summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdaptedWorkout() when $default != null:
return $default(_that.modifications,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ExerciseModification> modifications,  String summary)  $default,) {final _that = this;
switch (_that) {
case _AdaptedWorkout():
return $default(_that.modifications,_that.summary);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ExerciseModification> modifications,  String summary)?  $default,) {final _that = this;
switch (_that) {
case _AdaptedWorkout() when $default != null:
return $default(_that.modifications,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _AdaptedWorkout implements AdaptedWorkout {
  const _AdaptedWorkout({final  List<ExerciseModification> modifications = const [], this.summary = ''}): _modifications = modifications;
  

/// Ordered list of modifications per exercise.
 final  List<ExerciseModification> _modifications;
/// Ordered list of modifications per exercise.
@override@JsonKey() List<ExerciseModification> get modifications {
  if (_modifications is EqualUnmodifiableListView) return _modifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modifications);
}

/// Human-readable summary of what changed and why.
@override@JsonKey() final  String summary;

/// Create a copy of AdaptedWorkout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdaptedWorkoutCopyWith<_AdaptedWorkout> get copyWith => __$AdaptedWorkoutCopyWithImpl<_AdaptedWorkout>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdaptedWorkout&&const DeepCollectionEquality().equals(other._modifications, _modifications)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_modifications),summary);

@override
String toString() {
  return 'AdaptedWorkout(modifications: $modifications, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$AdaptedWorkoutCopyWith<$Res> implements $AdaptedWorkoutCopyWith<$Res> {
  factory _$AdaptedWorkoutCopyWith(_AdaptedWorkout value, $Res Function(_AdaptedWorkout) _then) = __$AdaptedWorkoutCopyWithImpl;
@override @useResult
$Res call({
 List<ExerciseModification> modifications, String summary
});




}
/// @nodoc
class __$AdaptedWorkoutCopyWithImpl<$Res>
    implements _$AdaptedWorkoutCopyWith<$Res> {
  __$AdaptedWorkoutCopyWithImpl(this._self, this._then);

  final _AdaptedWorkout _self;
  final $Res Function(_AdaptedWorkout) _then;

/// Create a copy of AdaptedWorkout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? modifications = null,Object? summary = null,}) {
  return _then(_AdaptedWorkout(
modifications: null == modifications ? _self._modifications : modifications // ignore: cast_nullable_to_non_nullable
as List<ExerciseModification>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
