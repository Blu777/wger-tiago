// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subjective_feedback.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubjectiveFeedback {

/// Date of the feedback entry.
 DateTime get date;/// Fatigue level on a 1–10 scale (10 = extreme fatigue).
 int get fatigue;/// Energy level on a 1–10 scale (10 = peak energy).
 int get energy;
/// Create a copy of SubjectiveFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubjectiveFeedbackCopyWith<SubjectiveFeedback> get copyWith => _$SubjectiveFeedbackCopyWithImpl<SubjectiveFeedback>(this as SubjectiveFeedback, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubjectiveFeedback&&(identical(other.date, date) || other.date == date)&&(identical(other.fatigue, fatigue) || other.fatigue == fatigue)&&(identical(other.energy, energy) || other.energy == energy));
}


@override
int get hashCode => Object.hash(runtimeType,date,fatigue,energy);

@override
String toString() {
  return 'SubjectiveFeedback(date: $date, fatigue: $fatigue, energy: $energy)';
}


}

/// @nodoc
abstract mixin class $SubjectiveFeedbackCopyWith<$Res>  {
  factory $SubjectiveFeedbackCopyWith(SubjectiveFeedback value, $Res Function(SubjectiveFeedback) _then) = _$SubjectiveFeedbackCopyWithImpl;
@useResult
$Res call({
 DateTime date, int fatigue, int energy
});




}
/// @nodoc
class _$SubjectiveFeedbackCopyWithImpl<$Res>
    implements $SubjectiveFeedbackCopyWith<$Res> {
  _$SubjectiveFeedbackCopyWithImpl(this._self, this._then);

  final SubjectiveFeedback _self;
  final $Res Function(SubjectiveFeedback) _then;

/// Create a copy of SubjectiveFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? fatigue = null,Object? energy = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fatigue: null == fatigue ? _self.fatigue : fatigue // ignore: cast_nullable_to_non_nullable
as int,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SubjectiveFeedback].
extension SubjectiveFeedbackPatterns on SubjectiveFeedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubjectiveFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubjectiveFeedback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubjectiveFeedback value)  $default,){
final _that = this;
switch (_that) {
case _SubjectiveFeedback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubjectiveFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _SubjectiveFeedback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int fatigue,  int energy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubjectiveFeedback() when $default != null:
return $default(_that.date,_that.fatigue,_that.energy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int fatigue,  int energy)  $default,) {final _that = this;
switch (_that) {
case _SubjectiveFeedback():
return $default(_that.date,_that.fatigue,_that.energy);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int fatigue,  int energy)?  $default,) {final _that = this;
switch (_that) {
case _SubjectiveFeedback() when $default != null:
return $default(_that.date,_that.fatigue,_that.energy);case _:
  return null;

}
}

}

/// @nodoc


class _SubjectiveFeedback implements SubjectiveFeedback {
  const _SubjectiveFeedback({required this.date, required this.fatigue, required this.energy});
  

/// Date of the feedback entry.
@override final  DateTime date;
/// Fatigue level on a 1–10 scale (10 = extreme fatigue).
@override final  int fatigue;
/// Energy level on a 1–10 scale (10 = peak energy).
@override final  int energy;

/// Create a copy of SubjectiveFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubjectiveFeedbackCopyWith<_SubjectiveFeedback> get copyWith => __$SubjectiveFeedbackCopyWithImpl<_SubjectiveFeedback>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubjectiveFeedback&&(identical(other.date, date) || other.date == date)&&(identical(other.fatigue, fatigue) || other.fatigue == fatigue)&&(identical(other.energy, energy) || other.energy == energy));
}


@override
int get hashCode => Object.hash(runtimeType,date,fatigue,energy);

@override
String toString() {
  return 'SubjectiveFeedback(date: $date, fatigue: $fatigue, energy: $energy)';
}


}

/// @nodoc
abstract mixin class _$SubjectiveFeedbackCopyWith<$Res> implements $SubjectiveFeedbackCopyWith<$Res> {
  factory _$SubjectiveFeedbackCopyWith(_SubjectiveFeedback value, $Res Function(_SubjectiveFeedback) _then) = __$SubjectiveFeedbackCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int fatigue, int energy
});




}
/// @nodoc
class __$SubjectiveFeedbackCopyWithImpl<$Res>
    implements _$SubjectiveFeedbackCopyWith<$Res> {
  __$SubjectiveFeedbackCopyWithImpl(this._self, this._then);

  final _SubjectiveFeedback _self;
  final $Res Function(_SubjectiveFeedback) _then;

/// Create a copy of SubjectiveFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? fatigue = null,Object? energy = null,}) {
  return _then(_SubjectiveFeedback(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,fatigue: null == fatigue ? _self.fatigue : fatigue // ignore: cast_nullable_to_non_nullable
as int,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
