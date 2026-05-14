// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoachState {

/// Phase from the previous analysis cycle.
 TrainingPhase? get lastPhase;/// The two most recent action items (most recent first).
 List<ActionItem> get lastActions;/// ISO week number of the last deload (to prevent back-to-back deloads).
 int? get lastDeloadWeek;
/// Create a copy of CoachState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachStateCopyWith<CoachState> get copyWith => _$CoachStateCopyWithImpl<CoachState>(this as CoachState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachState&&(identical(other.lastPhase, lastPhase) || other.lastPhase == lastPhase)&&const DeepCollectionEquality().equals(other.lastActions, lastActions)&&(identical(other.lastDeloadWeek, lastDeloadWeek) || other.lastDeloadWeek == lastDeloadWeek));
}


@override
int get hashCode => Object.hash(runtimeType,lastPhase,const DeepCollectionEquality().hash(lastActions),lastDeloadWeek);

@override
String toString() {
  return 'CoachState(lastPhase: $lastPhase, lastActions: $lastActions, lastDeloadWeek: $lastDeloadWeek)';
}


}

/// @nodoc
abstract mixin class $CoachStateCopyWith<$Res>  {
  factory $CoachStateCopyWith(CoachState value, $Res Function(CoachState) _then) = _$CoachStateCopyWithImpl;
@useResult
$Res call({
 TrainingPhase? lastPhase, List<ActionItem> lastActions, int? lastDeloadWeek
});




}
/// @nodoc
class _$CoachStateCopyWithImpl<$Res>
    implements $CoachStateCopyWith<$Res> {
  _$CoachStateCopyWithImpl(this._self, this._then);

  final CoachState _self;
  final $Res Function(CoachState) _then;

/// Create a copy of CoachState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastPhase = freezed,Object? lastActions = null,Object? lastDeloadWeek = freezed,}) {
  return _then(_self.copyWith(
lastPhase: freezed == lastPhase ? _self.lastPhase : lastPhase // ignore: cast_nullable_to_non_nullable
as TrainingPhase?,lastActions: null == lastActions ? _self.lastActions : lastActions // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,lastDeloadWeek: freezed == lastDeloadWeek ? _self.lastDeloadWeek : lastDeloadWeek // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachState].
extension CoachStatePatterns on CoachState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachState value)  $default,){
final _that = this;
switch (_that) {
case _CoachState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachState value)?  $default,){
final _that = this;
switch (_that) {
case _CoachState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TrainingPhase? lastPhase,  List<ActionItem> lastActions,  int? lastDeloadWeek)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachState() when $default != null:
return $default(_that.lastPhase,_that.lastActions,_that.lastDeloadWeek);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TrainingPhase? lastPhase,  List<ActionItem> lastActions,  int? lastDeloadWeek)  $default,) {final _that = this;
switch (_that) {
case _CoachState():
return $default(_that.lastPhase,_that.lastActions,_that.lastDeloadWeek);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TrainingPhase? lastPhase,  List<ActionItem> lastActions,  int? lastDeloadWeek)?  $default,) {final _that = this;
switch (_that) {
case _CoachState() when $default != null:
return $default(_that.lastPhase,_that.lastActions,_that.lastDeloadWeek);case _:
  return null;

}
}

}

/// @nodoc


class _CoachState implements CoachState {
  const _CoachState({this.lastPhase, final  List<ActionItem> lastActions = const [], this.lastDeloadWeek}): _lastActions = lastActions;
  

/// Phase from the previous analysis cycle.
@override final  TrainingPhase? lastPhase;
/// The two most recent action items (most recent first).
 final  List<ActionItem> _lastActions;
/// The two most recent action items (most recent first).
@override@JsonKey() List<ActionItem> get lastActions {
  if (_lastActions is EqualUnmodifiableListView) return _lastActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastActions);
}

/// ISO week number of the last deload (to prevent back-to-back deloads).
@override final  int? lastDeloadWeek;

/// Create a copy of CoachState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachStateCopyWith<_CoachState> get copyWith => __$CoachStateCopyWithImpl<_CoachState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachState&&(identical(other.lastPhase, lastPhase) || other.lastPhase == lastPhase)&&const DeepCollectionEquality().equals(other._lastActions, _lastActions)&&(identical(other.lastDeloadWeek, lastDeloadWeek) || other.lastDeloadWeek == lastDeloadWeek));
}


@override
int get hashCode => Object.hash(runtimeType,lastPhase,const DeepCollectionEquality().hash(_lastActions),lastDeloadWeek);

@override
String toString() {
  return 'CoachState(lastPhase: $lastPhase, lastActions: $lastActions, lastDeloadWeek: $lastDeloadWeek)';
}


}

/// @nodoc
abstract mixin class _$CoachStateCopyWith<$Res> implements $CoachStateCopyWith<$Res> {
  factory _$CoachStateCopyWith(_CoachState value, $Res Function(_CoachState) _then) = __$CoachStateCopyWithImpl;
@override @useResult
$Res call({
 TrainingPhase? lastPhase, List<ActionItem> lastActions, int? lastDeloadWeek
});




}
/// @nodoc
class __$CoachStateCopyWithImpl<$Res>
    implements _$CoachStateCopyWith<$Res> {
  __$CoachStateCopyWithImpl(this._self, this._then);

  final _CoachState _self;
  final $Res Function(_CoachState) _then;

/// Create a copy of CoachState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastPhase = freezed,Object? lastActions = null,Object? lastDeloadWeek = freezed,}) {
  return _then(_CoachState(
lastPhase: freezed == lastPhase ? _self.lastPhase : lastPhase // ignore: cast_nullable_to_non_nullable
as TrainingPhase?,lastActions: null == lastActions ? _self._lastActions : lastActions // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,lastDeloadWeek: freezed == lastDeloadWeek ? _self.lastDeloadWeek : lastDeloadWeek // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
