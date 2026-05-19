// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ActionItem {

/// Type of action.
 ActionType get type;/// Target entity name (exercise or muscle group).
 String get target;/// Numeric value associated with the action (kg, sets, %, etc.).
 num get value;/// Impact priority (1 = highest, 3 = lowest).
 int get priority;/// Human-readable justification for the action.
 String get reason;/// Detailed explanation shown when the user taps the action.
 String get detailReason;
/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionItemCopyWith<ActionItem> get copyWith => _$ActionItemCopyWithImpl<ActionItem>(this as ActionItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionItem&&(identical(other.type, type) || other.type == type)&&(identical(other.target, target) || other.target == target)&&(identical(other.value, value) || other.value == value)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.detailReason, detailReason) || other.detailReason == detailReason));
}


@override
int get hashCode => Object.hash(runtimeType,type,target,value,priority,reason,detailReason);

@override
String toString() {
  return 'ActionItem(type: $type, target: $target, value: $value, priority: $priority, reason: $reason, detailReason: $detailReason)';
}


}

/// @nodoc
abstract mixin class $ActionItemCopyWith<$Res>  {
  factory $ActionItemCopyWith(ActionItem value, $Res Function(ActionItem) _then) = _$ActionItemCopyWithImpl;
@useResult
$Res call({
 ActionType type, String target, num value, int priority, String reason, String detailReason
});




}
/// @nodoc
class _$ActionItemCopyWithImpl<$Res>
    implements $ActionItemCopyWith<$Res> {
  _$ActionItemCopyWithImpl(this._self, this._then);

  final ActionItem _self;
  final $Res Function(ActionItem) _then;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? target = null,Object? value = null,Object? priority = null,Object? reason = null,Object? detailReason = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActionType,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,detailReason: null == detailReason ? _self.detailReason : detailReason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionItem].
extension ActionItemPatterns on ActionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionItem value)  $default,){
final _that = this;
switch (_that) {
case _ActionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionItem value)?  $default,){
final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActionType type,  String target,  num value,  int priority,  String reason,  String detailReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that.type,_that.target,_that.value,_that.priority,_that.reason,_that.detailReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActionType type,  String target,  num value,  int priority,  String reason,  String detailReason)  $default,) {final _that = this;
switch (_that) {
case _ActionItem():
return $default(_that.type,_that.target,_that.value,_that.priority,_that.reason,_that.detailReason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActionType type,  String target,  num value,  int priority,  String reason,  String detailReason)?  $default,) {final _that = this;
switch (_that) {
case _ActionItem() when $default != null:
return $default(_that.type,_that.target,_that.value,_that.priority,_that.reason,_that.detailReason);case _:
  return null;

}
}

}

/// @nodoc


class _ActionItem implements ActionItem {
  const _ActionItem({required this.type, required this.target, required this.value, this.priority = 2, required this.reason, this.detailReason = ''});
  

/// Type of action.
@override final  ActionType type;
/// Target entity name (exercise or muscle group).
@override final  String target;
/// Numeric value associated with the action (kg, sets, %, etc.).
@override final  num value;
/// Impact priority (1 = highest, 3 = lowest).
@override@JsonKey() final  int priority;
/// Human-readable justification for the action.
@override final  String reason;
/// Detailed explanation shown when the user taps the action.
@override@JsonKey() final  String detailReason;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionItemCopyWith<_ActionItem> get copyWith => __$ActionItemCopyWithImpl<_ActionItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionItem&&(identical(other.type, type) || other.type == type)&&(identical(other.target, target) || other.target == target)&&(identical(other.value, value) || other.value == value)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.detailReason, detailReason) || other.detailReason == detailReason));
}


@override
int get hashCode => Object.hash(runtimeType,type,target,value,priority,reason,detailReason);

@override
String toString() {
  return 'ActionItem(type: $type, target: $target, value: $value, priority: $priority, reason: $reason, detailReason: $detailReason)';
}


}

/// @nodoc
abstract mixin class _$ActionItemCopyWith<$Res> implements $ActionItemCopyWith<$Res> {
  factory _$ActionItemCopyWith(_ActionItem value, $Res Function(_ActionItem) _then) = __$ActionItemCopyWithImpl;
@override @useResult
$Res call({
 ActionType type, String target, num value, int priority, String reason, String detailReason
});




}
/// @nodoc
class __$ActionItemCopyWithImpl<$Res>
    implements _$ActionItemCopyWith<$Res> {
  __$ActionItemCopyWithImpl(this._self, this._then);

  final _ActionItem _self;
  final $Res Function(_ActionItem) _then;

/// Create a copy of ActionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? target = null,Object? value = null,Object? priority = null,Object? reason = null,Object? detailReason = null,}) {
  return _then(_ActionItem(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ActionType,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as num,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,detailReason: null == detailReason ? _self.detailReason : detailReason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
