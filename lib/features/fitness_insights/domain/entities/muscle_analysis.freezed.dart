// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'muscle_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MuscleAnalysis {

/// Muscle group name.
 String get muscleName;/// Total sets per week (average over analysis period).
 num get weeklySets;/// Training frequency per week (sessions hitting this muscle).
 num get weeklyFrequency;/// Total volume (weight × reps) for this muscle.
 num get totalVolume;/// Status based on weekly sets thresholds.
 MuscleTrainingStatus get status;
/// Create a copy of MuscleAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MuscleAnalysisCopyWith<MuscleAnalysis> get copyWith => _$MuscleAnalysisCopyWithImpl<MuscleAnalysis>(this as MuscleAnalysis, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MuscleAnalysis&&(identical(other.muscleName, muscleName) || other.muscleName == muscleName)&&(identical(other.weeklySets, weeklySets) || other.weeklySets == weeklySets)&&(identical(other.weeklyFrequency, weeklyFrequency) || other.weeklyFrequency == weeklyFrequency)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,muscleName,weeklySets,weeklyFrequency,totalVolume,status);

@override
String toString() {
  return 'MuscleAnalysis(muscleName: $muscleName, weeklySets: $weeklySets, weeklyFrequency: $weeklyFrequency, totalVolume: $totalVolume, status: $status)';
}


}

/// @nodoc
abstract mixin class $MuscleAnalysisCopyWith<$Res>  {
  factory $MuscleAnalysisCopyWith(MuscleAnalysis value, $Res Function(MuscleAnalysis) _then) = _$MuscleAnalysisCopyWithImpl;
@useResult
$Res call({
 String muscleName, num weeklySets, num weeklyFrequency, num totalVolume, MuscleTrainingStatus status
});




}
/// @nodoc
class _$MuscleAnalysisCopyWithImpl<$Res>
    implements $MuscleAnalysisCopyWith<$Res> {
  _$MuscleAnalysisCopyWithImpl(this._self, this._then);

  final MuscleAnalysis _self;
  final $Res Function(MuscleAnalysis) _then;

/// Create a copy of MuscleAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? muscleName = null,Object? weeklySets = null,Object? weeklyFrequency = null,Object? totalVolume = null,Object? status = null,}) {
  return _then(_self.copyWith(
muscleName: null == muscleName ? _self.muscleName : muscleName // ignore: cast_nullable_to_non_nullable
as String,weeklySets: null == weeklySets ? _self.weeklySets : weeklySets // ignore: cast_nullable_to_non_nullable
as num,weeklyFrequency: null == weeklyFrequency ? _self.weeklyFrequency : weeklyFrequency // ignore: cast_nullable_to_non_nullable
as num,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as num,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MuscleTrainingStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [MuscleAnalysis].
extension MuscleAnalysisPatterns on MuscleAnalysis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MuscleAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MuscleAnalysis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MuscleAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _MuscleAnalysis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MuscleAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _MuscleAnalysis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String muscleName,  num weeklySets,  num weeklyFrequency,  num totalVolume,  MuscleTrainingStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MuscleAnalysis() when $default != null:
return $default(_that.muscleName,_that.weeklySets,_that.weeklyFrequency,_that.totalVolume,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String muscleName,  num weeklySets,  num weeklyFrequency,  num totalVolume,  MuscleTrainingStatus status)  $default,) {final _that = this;
switch (_that) {
case _MuscleAnalysis():
return $default(_that.muscleName,_that.weeklySets,_that.weeklyFrequency,_that.totalVolume,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String muscleName,  num weeklySets,  num weeklyFrequency,  num totalVolume,  MuscleTrainingStatus status)?  $default,) {final _that = this;
switch (_that) {
case _MuscleAnalysis() when $default != null:
return $default(_that.muscleName,_that.weeklySets,_that.weeklyFrequency,_that.totalVolume,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _MuscleAnalysis implements MuscleAnalysis {
  const _MuscleAnalysis({required this.muscleName, required this.weeklySets, required this.weeklyFrequency, required this.totalVolume, required this.status});
  

/// Muscle group name.
@override final  String muscleName;
/// Total sets per week (average over analysis period).
@override final  num weeklySets;
/// Training frequency per week (sessions hitting this muscle).
@override final  num weeklyFrequency;
/// Total volume (weight × reps) for this muscle.
@override final  num totalVolume;
/// Status based on weekly sets thresholds.
@override final  MuscleTrainingStatus status;

/// Create a copy of MuscleAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MuscleAnalysisCopyWith<_MuscleAnalysis> get copyWith => __$MuscleAnalysisCopyWithImpl<_MuscleAnalysis>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MuscleAnalysis&&(identical(other.muscleName, muscleName) || other.muscleName == muscleName)&&(identical(other.weeklySets, weeklySets) || other.weeklySets == weeklySets)&&(identical(other.weeklyFrequency, weeklyFrequency) || other.weeklyFrequency == weeklyFrequency)&&(identical(other.totalVolume, totalVolume) || other.totalVolume == totalVolume)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,muscleName,weeklySets,weeklyFrequency,totalVolume,status);

@override
String toString() {
  return 'MuscleAnalysis(muscleName: $muscleName, weeklySets: $weeklySets, weeklyFrequency: $weeklyFrequency, totalVolume: $totalVolume, status: $status)';
}


}

/// @nodoc
abstract mixin class _$MuscleAnalysisCopyWith<$Res> implements $MuscleAnalysisCopyWith<$Res> {
  factory _$MuscleAnalysisCopyWith(_MuscleAnalysis value, $Res Function(_MuscleAnalysis) _then) = __$MuscleAnalysisCopyWithImpl;
@override @useResult
$Res call({
 String muscleName, num weeklySets, num weeklyFrequency, num totalVolume, MuscleTrainingStatus status
});




}
/// @nodoc
class __$MuscleAnalysisCopyWithImpl<$Res>
    implements _$MuscleAnalysisCopyWith<$Res> {
  __$MuscleAnalysisCopyWithImpl(this._self, this._then);

  final _MuscleAnalysis _self;
  final $Res Function(_MuscleAnalysis) _then;

/// Create a copy of MuscleAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? muscleName = null,Object? weeklySets = null,Object? weeklyFrequency = null,Object? totalVolume = null,Object? status = null,}) {
  return _then(_MuscleAnalysis(
muscleName: null == muscleName ? _self.muscleName : muscleName // ignore: cast_nullable_to_non_nullable
as String,weeklySets: null == weeklySets ? _self.weeklySets : weeklySets // ignore: cast_nullable_to_non_nullable
as num,weeklyFrequency: null == weeklyFrequency ? _self.weeklyFrequency : weeklyFrequency // ignore: cast_nullable_to_non_nullable
as num,totalVolume: null == totalVolume ? _self.totalVolume : totalVolume // ignore: cast_nullable_to_non_nullable
as num,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MuscleTrainingStatus,
  ));
}


}

// dart format on
