// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoachSummary {

/// What is currently happening (e.g. "Fatiga creciente con progreso sostenido").
 String get situation;/// What to do this week (e.g. "Mantené volumen, planificá deload en 7 días").
 String get directive;/// Optional longer explanation or warning.
 String? get note;
/// Create a copy of CoachSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachSummaryCopyWith<CoachSummary> get copyWith => _$CoachSummaryCopyWithImpl<CoachSummary>(this as CoachSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachSummary&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.directive, directive) || other.directive == directive)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,situation,directive,note);

@override
String toString() {
  return 'CoachSummary(situation: $situation, directive: $directive, note: $note)';
}


}

/// @nodoc
abstract mixin class $CoachSummaryCopyWith<$Res>  {
  factory $CoachSummaryCopyWith(CoachSummary value, $Res Function(CoachSummary) _then) = _$CoachSummaryCopyWithImpl;
@useResult
$Res call({
 String situation, String directive, String? note
});




}
/// @nodoc
class _$CoachSummaryCopyWithImpl<$Res>
    implements $CoachSummaryCopyWith<$Res> {
  _$CoachSummaryCopyWithImpl(this._self, this._then);

  final CoachSummary _self;
  final $Res Function(CoachSummary) _then;

/// Create a copy of CoachSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? situation = null,Object? directive = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String,directive: null == directive ? _self.directive : directive // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachSummary].
extension CoachSummaryPatterns on CoachSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachSummary value)  $default,){
final _that = this;
switch (_that) {
case _CoachSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CoachSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String situation,  String directive,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachSummary() when $default != null:
return $default(_that.situation,_that.directive,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String situation,  String directive,  String? note)  $default,) {final _that = this;
switch (_that) {
case _CoachSummary():
return $default(_that.situation,_that.directive,_that.note);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String situation,  String directive,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _CoachSummary() when $default != null:
return $default(_that.situation,_that.directive,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _CoachSummary implements CoachSummary {
  const _CoachSummary({required this.situation, required this.directive, this.note});
  

/// What is currently happening (e.g. "Fatiga creciente con progreso sostenido").
@override final  String situation;
/// What to do this week (e.g. "Mantené volumen, planificá deload en 7 días").
@override final  String directive;
/// Optional longer explanation or warning.
@override final  String? note;

/// Create a copy of CoachSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachSummaryCopyWith<_CoachSummary> get copyWith => __$CoachSummaryCopyWithImpl<_CoachSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachSummary&&(identical(other.situation, situation) || other.situation == situation)&&(identical(other.directive, directive) || other.directive == directive)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,situation,directive,note);

@override
String toString() {
  return 'CoachSummary(situation: $situation, directive: $directive, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CoachSummaryCopyWith<$Res> implements $CoachSummaryCopyWith<$Res> {
  factory _$CoachSummaryCopyWith(_CoachSummary value, $Res Function(_CoachSummary) _then) = __$CoachSummaryCopyWithImpl;
@override @useResult
$Res call({
 String situation, String directive, String? note
});




}
/// @nodoc
class __$CoachSummaryCopyWithImpl<$Res>
    implements _$CoachSummaryCopyWith<$Res> {
  __$CoachSummaryCopyWithImpl(this._self, this._then);

  final _CoachSummary _self;
  final $Res Function(_CoachSummary) _then;

/// Create a copy of CoachSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? situation = null,Object? directive = null,Object? note = freezed,}) {
  return _then(_CoachSummary(
situation: null == situation ? _self.situation : situation // ignore: cast_nullable_to_non_nullable
as String,directive: null == directive ? _self.directive : directive // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
