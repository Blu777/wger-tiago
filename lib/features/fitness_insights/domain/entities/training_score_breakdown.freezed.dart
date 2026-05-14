// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_score_breakdown.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrainingScoreBreakdown {

/// Score derived from exercise progression (0-40).
 num get progressScore;/// Score derived from training adherence (0-25).
 num get adherenceScore;/// Score derived from fatigue management (0-20).
 num get fatigueScore;/// Score derived from data quality (0-15).
 num get dataQualityScore;/// Total computed score.
 num get total;
/// Create a copy of TrainingScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrainingScoreBreakdownCopyWith<TrainingScoreBreakdown> get copyWith => _$TrainingScoreBreakdownCopyWithImpl<TrainingScoreBreakdown>(this as TrainingScoreBreakdown, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrainingScoreBreakdown&&(identical(other.progressScore, progressScore) || other.progressScore == progressScore)&&(identical(other.adherenceScore, adherenceScore) || other.adherenceScore == adherenceScore)&&(identical(other.fatigueScore, fatigueScore) || other.fatigueScore == fatigueScore)&&(identical(other.dataQualityScore, dataQualityScore) || other.dataQualityScore == dataQualityScore)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,progressScore,adherenceScore,fatigueScore,dataQualityScore,total);

@override
String toString() {
  return 'TrainingScoreBreakdown(progressScore: $progressScore, adherenceScore: $adherenceScore, fatigueScore: $fatigueScore, dataQualityScore: $dataQualityScore, total: $total)';
}


}

/// @nodoc
abstract mixin class $TrainingScoreBreakdownCopyWith<$Res>  {
  factory $TrainingScoreBreakdownCopyWith(TrainingScoreBreakdown value, $Res Function(TrainingScoreBreakdown) _then) = _$TrainingScoreBreakdownCopyWithImpl;
@useResult
$Res call({
 num progressScore, num adherenceScore, num fatigueScore, num dataQualityScore, num total
});




}
/// @nodoc
class _$TrainingScoreBreakdownCopyWithImpl<$Res>
    implements $TrainingScoreBreakdownCopyWith<$Res> {
  _$TrainingScoreBreakdownCopyWithImpl(this._self, this._then);

  final TrainingScoreBreakdown _self;
  final $Res Function(TrainingScoreBreakdown) _then;

/// Create a copy of TrainingScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? progressScore = null,Object? adherenceScore = null,Object? fatigueScore = null,Object? dataQualityScore = null,Object? total = null,}) {
  return _then(_self.copyWith(
progressScore: null == progressScore ? _self.progressScore : progressScore // ignore: cast_nullable_to_non_nullable
as num,adherenceScore: null == adherenceScore ? _self.adherenceScore : adherenceScore // ignore: cast_nullable_to_non_nullable
as num,fatigueScore: null == fatigueScore ? _self.fatigueScore : fatigueScore // ignore: cast_nullable_to_non_nullable
as num,dataQualityScore: null == dataQualityScore ? _self.dataQualityScore : dataQualityScore // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [TrainingScoreBreakdown].
extension TrainingScoreBreakdownPatterns on TrainingScoreBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrainingScoreBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrainingScoreBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrainingScoreBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _TrainingScoreBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrainingScoreBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _TrainingScoreBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num progressScore,  num adherenceScore,  num fatigueScore,  num dataQualityScore,  num total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrainingScoreBreakdown() when $default != null:
return $default(_that.progressScore,_that.adherenceScore,_that.fatigueScore,_that.dataQualityScore,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num progressScore,  num adherenceScore,  num fatigueScore,  num dataQualityScore,  num total)  $default,) {final _that = this;
switch (_that) {
case _TrainingScoreBreakdown():
return $default(_that.progressScore,_that.adherenceScore,_that.fatigueScore,_that.dataQualityScore,_that.total);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num progressScore,  num adherenceScore,  num fatigueScore,  num dataQualityScore,  num total)?  $default,) {final _that = this;
switch (_that) {
case _TrainingScoreBreakdown() when $default != null:
return $default(_that.progressScore,_that.adherenceScore,_that.fatigueScore,_that.dataQualityScore,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _TrainingScoreBreakdown implements TrainingScoreBreakdown {
  const _TrainingScoreBreakdown({required this.progressScore, required this.adherenceScore, required this.fatigueScore, required this.dataQualityScore, required this.total});
  

/// Score derived from exercise progression (0-40).
@override final  num progressScore;
/// Score derived from training adherence (0-25).
@override final  num adherenceScore;
/// Score derived from fatigue management (0-20).
@override final  num fatigueScore;
/// Score derived from data quality (0-15).
@override final  num dataQualityScore;
/// Total computed score.
@override final  num total;

/// Create a copy of TrainingScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrainingScoreBreakdownCopyWith<_TrainingScoreBreakdown> get copyWith => __$TrainingScoreBreakdownCopyWithImpl<_TrainingScoreBreakdown>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrainingScoreBreakdown&&(identical(other.progressScore, progressScore) || other.progressScore == progressScore)&&(identical(other.adherenceScore, adherenceScore) || other.adherenceScore == adherenceScore)&&(identical(other.fatigueScore, fatigueScore) || other.fatigueScore == fatigueScore)&&(identical(other.dataQualityScore, dataQualityScore) || other.dataQualityScore == dataQualityScore)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,progressScore,adherenceScore,fatigueScore,dataQualityScore,total);

@override
String toString() {
  return 'TrainingScoreBreakdown(progressScore: $progressScore, adherenceScore: $adherenceScore, fatigueScore: $fatigueScore, dataQualityScore: $dataQualityScore, total: $total)';
}


}

/// @nodoc
abstract mixin class _$TrainingScoreBreakdownCopyWith<$Res> implements $TrainingScoreBreakdownCopyWith<$Res> {
  factory _$TrainingScoreBreakdownCopyWith(_TrainingScoreBreakdown value, $Res Function(_TrainingScoreBreakdown) _then) = __$TrainingScoreBreakdownCopyWithImpl;
@override @useResult
$Res call({
 num progressScore, num adherenceScore, num fatigueScore, num dataQualityScore, num total
});




}
/// @nodoc
class __$TrainingScoreBreakdownCopyWithImpl<$Res>
    implements _$TrainingScoreBreakdownCopyWith<$Res> {
  __$TrainingScoreBreakdownCopyWithImpl(this._self, this._then);

  final _TrainingScoreBreakdown _self;
  final $Res Function(_TrainingScoreBreakdown) _then;

/// Create a copy of TrainingScoreBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progressScore = null,Object? adherenceScore = null,Object? fatigueScore = null,Object? dataQualityScore = null,Object? total = null,}) {
  return _then(_TrainingScoreBreakdown(
progressScore: null == progressScore ? _self.progressScore : progressScore // ignore: cast_nullable_to_non_nullable
as num,adherenceScore: null == adherenceScore ? _self.adherenceScore : adherenceScore // ignore: cast_nullable_to_non_nullable
as num,fatigueScore: null == fatigueScore ? _self.fatigueScore : fatigueScore // ignore: cast_nullable_to_non_nullable
as num,dataQualityScore: null == dataQualityScore ? _self.dataQualityScore : dataQualityScore // ignore: cast_nullable_to_non_nullable
as num,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
