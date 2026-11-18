// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filter_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FilterRule {

 String get id; String get name; String get pattern; DateTime get createdAt; DateTime get updatedAt; bool get isEnabled; int get priority; String? get description;
/// Create a copy of FilterRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilterRuleCopyWith<FilterRule> get copyWith => _$FilterRuleCopyWithImpl<FilterRule>(this as FilterRule, _$identity);

  /// Serializes this FilterRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FilterRule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilterRule&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.pattern, _this.pattern) || other.pattern == _this.pattern)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.isEnabled, _this.isEnabled) || other.isEnabled == _this.isEnabled)&&(identical(other.priority, _this.priority) || other.priority == _this.priority)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FilterRule;
  return Object.hash(runtimeType,_this.id,_this.name,_this.pattern,_this.createdAt,_this.updatedAt,_this.isEnabled,_this.priority,_this.description);
}

@override
String toString() {
  final _this = this as FilterRule;
  return 'FilterRule(id: ${_this.id}, name: ${_this.name}, pattern: ${_this.pattern}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, isEnabled: ${_this.isEnabled}, priority: ${_this.priority}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $FilterRuleCopyWith<$Res>  {
  factory $FilterRuleCopyWith(FilterRule value, $Res Function(FilterRule) _then) = _$FilterRuleCopyWithImpl;
@useResult
$Res call({
 String id, String name, String pattern, DateTime createdAt, DateTime updatedAt, bool isEnabled, int priority, String? description
});




}
/// @nodoc
class _$FilterRuleCopyWithImpl<$Res>
    implements $FilterRuleCopyWith<$Res> {
  _$FilterRuleCopyWithImpl(this._self, this._then);

  final FilterRule _self;
  final $Res Function(FilterRule) _then;

/// Create a copy of FilterRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pattern = null,Object? createdAt = null,Object? updatedAt = null,Object? isEnabled = null,Object? priority = null,Object? description = freezed,}) {
  return _then(FilterRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FilterRule].
extension FilterRulePatterns on FilterRule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilterRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilterRule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilterRule value)  $default,){
final _that = this;
switch (_that) {
case _FilterRule():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilterRule value)?  $default,){
final _that = this;
switch (_that) {
case _FilterRule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String pattern,  DateTime createdAt,  DateTime updatedAt,  bool isEnabled,  int priority,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilterRule() when $default != null:
return $default(_that.id,_that.name,_that.pattern,_that.createdAt,_that.updatedAt,_that.isEnabled,_that.priority,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String pattern,  DateTime createdAt,  DateTime updatedAt,  bool isEnabled,  int priority,  String? description)  $default,) {final _that = this;
switch (_that) {
case _FilterRule():
return $default(_that.id,_that.name,_that.pattern,_that.createdAt,_that.updatedAt,_that.isEnabled,_that.priority,_that.description);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String pattern,  DateTime createdAt,  DateTime updatedAt,  bool isEnabled,  int priority,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _FilterRule() when $default != null:
return $default(_that.id,_that.name,_that.pattern,_that.createdAt,_that.updatedAt,_that.isEnabled,_that.priority,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FilterRule implements FilterRule {
  const _FilterRule({required this.id, required this.name, required this.pattern, required this.createdAt, required this.updatedAt, this.isEnabled = true, this.priority = 0, this.description});
  factory _FilterRule.fromJson(Map<String, dynamic> json) => _$FilterRuleFromJson(json);

@override final  String id;
@override final  String name;
@override final  String pattern;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  bool isEnabled;
@override@JsonKey() final  int priority;
@override final  String? description;

/// Create a copy of FilterRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterRuleCopyWith<_FilterRule> get copyWith => __$FilterRuleCopyWithImpl<_FilterRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilterRuleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterRule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pattern, pattern) || other.pattern == pattern)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,pattern,createdAt,updatedAt,isEnabled,priority,description);
}

@override
String toString() {
    return 'FilterRule(id: $id, name: $name, pattern: $pattern, createdAt: $createdAt, updatedAt: $updatedAt, isEnabled: $isEnabled, priority: $priority, description: $description)';
}


}

/// @nodoc
abstract mixin class _$FilterRuleCopyWith<$Res> implements $FilterRuleCopyWith<$Res> {
  factory _$FilterRuleCopyWith(_FilterRule value, $Res Function(_FilterRule) _then) = __$FilterRuleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String pattern, DateTime createdAt, DateTime updatedAt, bool isEnabled, int priority, String? description
});




}
/// @nodoc
class __$FilterRuleCopyWithImpl<$Res>
    implements _$FilterRuleCopyWith<$Res> {
  __$FilterRuleCopyWithImpl(this._self, this._then);

  final _FilterRule _self;
  final $Res Function(_FilterRule) _then;

/// Create a copy of FilterRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pattern = null,Object? createdAt = null,Object? updatedAt = null,Object? isEnabled = null,Object? priority = null,Object? description = freezed,}) {
  return _then(_FilterRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pattern: null == pattern ? _self.pattern : pattern // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
