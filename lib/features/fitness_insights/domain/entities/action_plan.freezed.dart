// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActionPlan {

/// Ordered list of actions (already sorted by priority).
 List<ActionItem> get actions;/// Overall coaching directive for the week.
 String get summary;
/// Create a copy of ActionPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionPlanCopyWith<ActionPlan> get copyWith => _$ActionPlanCopyWithImpl<ActionPlan>(this as ActionPlan, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionPlan&&const DeepCollectionEquality().equals(other.actions, actions)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(actions),summary);

@override
String toString() {
  return 'ActionPlan(actions: $actions, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $ActionPlanCopyWith<$Res>  {
  factory $ActionPlanCopyWith(ActionPlan value, $Res Function(ActionPlan) _then) = _$ActionPlanCopyWithImpl;
@useResult
$Res call({
 List<ActionItem> actions, String summary
});




}
/// @nodoc
class _$ActionPlanCopyWithImpl<$Res>
    implements $ActionPlanCopyWith<$Res> {
  _$ActionPlanCopyWithImpl(this._self, this._then);

  final ActionPlan _self;
  final $Res Function(ActionPlan) _then;

/// Create a copy of ActionPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? actions = null,Object? summary = null,}) {
  return _then(_self.copyWith(
actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionPlan].
extension ActionPlanPatterns on ActionPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionPlan value)  $default,){
final _that = this;
switch (_that) {
case _ActionPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionPlan value)?  $default,){
final _that = this;
switch (_that) {
case _ActionPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ActionItem> actions,  String summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionPlan() when $default != null:
return $default(_that.actions,_that.summary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ActionItem> actions,  String summary)  $default,) {final _that = this;
switch (_that) {
case _ActionPlan():
return $default(_that.actions,_that.summary);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ActionItem> actions,  String summary)?  $default,) {final _that = this;
switch (_that) {
case _ActionPlan() when $default != null:
return $default(_that.actions,_that.summary);case _:
  return null;

}
}

}

/// @nodoc


class _ActionPlan implements ActionPlan {
  const _ActionPlan({final  List<ActionItem> actions = const [], this.summary = ''}): _actions = actions;
  

/// Ordered list of actions (already sorted by priority).
 final  List<ActionItem> _actions;
/// Ordered list of actions (already sorted by priority).
@override@JsonKey() List<ActionItem> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}

/// Overall coaching directive for the week.
@override@JsonKey() final  String summary;

/// Create a copy of ActionPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionPlanCopyWith<_ActionPlan> get copyWith => __$ActionPlanCopyWithImpl<_ActionPlan>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionPlan&&const DeepCollectionEquality().equals(other._actions, _actions)&&(identical(other.summary, summary) || other.summary == summary));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_actions),summary);

@override
String toString() {
  return 'ActionPlan(actions: $actions, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$ActionPlanCopyWith<$Res> implements $ActionPlanCopyWith<$Res> {
  factory _$ActionPlanCopyWith(_ActionPlan value, $Res Function(_ActionPlan) _then) = __$ActionPlanCopyWithImpl;
@override @useResult
$Res call({
 List<ActionItem> actions, String summary
});




}
/// @nodoc
class __$ActionPlanCopyWithImpl<$Res>
    implements _$ActionPlanCopyWith<$Res> {
  __$ActionPlanCopyWithImpl(this._self, this._then);

  final _ActionPlan _self;
  final $Res Function(_ActionPlan) _then;

/// Create a copy of ActionPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? actions = null,Object? summary = null,}) {
  return _then(_ActionPlan(
actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<ActionItem>,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
