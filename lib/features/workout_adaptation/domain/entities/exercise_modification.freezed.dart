// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_modification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExerciseModification {

/// Type of change.
 ModificationType get type;/// Target exercise name.
 String get exerciseName;/// Human-readable reason for the modification.
 String get reason;/// New weight after modification (null if unchanged).
 num? get newWeight;/// New set count after modification (null if unchanged).
 num? get newSets;
/// Create a copy of ExerciseModification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExerciseModificationCopyWith<ExerciseModification> get copyWith => _$ExerciseModificationCopyWithImpl<ExerciseModification>(this as ExerciseModification, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExerciseModification&&(identical(other.type, type) || other.type == type)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.newWeight, newWeight) || other.newWeight == newWeight)&&(identical(other.newSets, newSets) || other.newSets == newSets));
}


@override
int get hashCode => Object.hash(runtimeType,type,exerciseName,reason,newWeight,newSets);

@override
String toString() {
  return 'ExerciseModification(type: $type, exerciseName: $exerciseName, reason: $reason, newWeight: $newWeight, newSets: $newSets)';
}


}

/// @nodoc
abstract mixin class $ExerciseModificationCopyWith<$Res>  {
  factory $ExerciseModificationCopyWith(ExerciseModification value, $Res Function(ExerciseModification) _then) = _$ExerciseModificationCopyWithImpl;
@useResult
$Res call({
 ModificationType type, String exerciseName, String reason, num? newWeight, num? newSets
});




}
/// @nodoc
class _$ExerciseModificationCopyWithImpl<$Res>
    implements $ExerciseModificationCopyWith<$Res> {
  _$ExerciseModificationCopyWithImpl(this._self, this._then);

  final ExerciseModification _self;
  final $Res Function(ExerciseModification) _then;

/// Create a copy of ExerciseModification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? exerciseName = null,Object? reason = null,Object? newWeight = freezed,Object? newSets = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModificationType,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,newWeight: freezed == newWeight ? _self.newWeight : newWeight // ignore: cast_nullable_to_non_nullable
as num?,newSets: freezed == newSets ? _self.newSets : newSets // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExerciseModification].
extension ExerciseModificationPatterns on ExerciseModification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExerciseModification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExerciseModification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExerciseModification value)  $default,){
final _that = this;
switch (_that) {
case _ExerciseModification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExerciseModification value)?  $default,){
final _that = this;
switch (_that) {
case _ExerciseModification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ModificationType type,  String exerciseName,  String reason,  num? newWeight,  num? newSets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExerciseModification() when $default != null:
return $default(_that.type,_that.exerciseName,_that.reason,_that.newWeight,_that.newSets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ModificationType type,  String exerciseName,  String reason,  num? newWeight,  num? newSets)  $default,) {final _that = this;
switch (_that) {
case _ExerciseModification():
return $default(_that.type,_that.exerciseName,_that.reason,_that.newWeight,_that.newSets);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ModificationType type,  String exerciseName,  String reason,  num? newWeight,  num? newSets)?  $default,) {final _that = this;
switch (_that) {
case _ExerciseModification() when $default != null:
return $default(_that.type,_that.exerciseName,_that.reason,_that.newWeight,_that.newSets);case _:
  return null;

}
}

}

/// @nodoc


class _ExerciseModification implements ExerciseModification {
  const _ExerciseModification({required this.type, required this.exerciseName, required this.reason, this.newWeight, this.newSets});
  

/// Type of change.
@override final  ModificationType type;
/// Target exercise name.
@override final  String exerciseName;
/// Human-readable reason for the modification.
@override final  String reason;
/// New weight after modification (null if unchanged).
@override final  num? newWeight;
/// New set count after modification (null if unchanged).
@override final  num? newSets;

/// Create a copy of ExerciseModification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExerciseModificationCopyWith<_ExerciseModification> get copyWith => __$ExerciseModificationCopyWithImpl<_ExerciseModification>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExerciseModification&&(identical(other.type, type) || other.type == type)&&(identical(other.exerciseName, exerciseName) || other.exerciseName == exerciseName)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.newWeight, newWeight) || other.newWeight == newWeight)&&(identical(other.newSets, newSets) || other.newSets == newSets));
}


@override
int get hashCode => Object.hash(runtimeType,type,exerciseName,reason,newWeight,newSets);

@override
String toString() {
  return 'ExerciseModification(type: $type, exerciseName: $exerciseName, reason: $reason, newWeight: $newWeight, newSets: $newSets)';
}


}

/// @nodoc
abstract mixin class _$ExerciseModificationCopyWith<$Res> implements $ExerciseModificationCopyWith<$Res> {
  factory _$ExerciseModificationCopyWith(_ExerciseModification value, $Res Function(_ExerciseModification) _then) = __$ExerciseModificationCopyWithImpl;
@override @useResult
$Res call({
 ModificationType type, String exerciseName, String reason, num? newWeight, num? newSets
});




}
/// @nodoc
class __$ExerciseModificationCopyWithImpl<$Res>
    implements _$ExerciseModificationCopyWith<$Res> {
  __$ExerciseModificationCopyWithImpl(this._self, this._then);

  final _ExerciseModification _self;
  final $Res Function(_ExerciseModification) _then;

/// Create a copy of ExerciseModification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? exerciseName = null,Object? reason = null,Object? newWeight = freezed,Object? newSets = freezed,}) {
  return _then(_ExerciseModification(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ModificationType,exerciseName: null == exerciseName ? _self.exerciseName : exerciseName // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,newWeight: freezed == newWeight ? _self.newWeight : newWeight // ignore: cast_nullable_to_non_nullable
as num?,newSets: freezed == newSets ? _self.newSets : newSets // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
