// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrganizationMatch {

 String get organizationName; String get normalizedOrganizationName; String get ruleId; String get ruleName;
/// Create a copy of OrganizationMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationMatchCopyWith<OrganizationMatch> get copyWith => _$OrganizationMatchCopyWithImpl<OrganizationMatch>(this as OrganizationMatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrganizationMatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizationMatch&&(identical(other.organizationName, _this.organizationName) || other.organizationName == _this.organizationName)&&(identical(other.normalizedOrganizationName, _this.normalizedOrganizationName) || other.normalizedOrganizationName == _this.normalizedOrganizationName)&&(identical(other.ruleId, _this.ruleId) || other.ruleId == _this.ruleId)&&(identical(other.ruleName, _this.ruleName) || other.ruleName == _this.ruleName));
}


@override
int get hashCode {
  final _this = this as OrganizationMatch;
  return Object.hash(runtimeType,_this.organizationName,_this.normalizedOrganizationName,_this.ruleId,_this.ruleName);
}

@override
String toString() {
  final _this = this as OrganizationMatch;
  return 'OrganizationMatch(organizationName: ${_this.organizationName}, normalizedOrganizationName: ${_this.normalizedOrganizationName}, ruleId: ${_this.ruleId}, ruleName: ${_this.ruleName})';
}


}

/// @nodoc
abstract mixin class $OrganizationMatchCopyWith<$Res>  {
  factory $OrganizationMatchCopyWith(OrganizationMatch value, $Res Function(OrganizationMatch) _then) = _$OrganizationMatchCopyWithImpl;
@useResult
$Res call({
 String organizationName, String normalizedOrganizationName, String ruleId, String ruleName
});




}
/// @nodoc
class _$OrganizationMatchCopyWithImpl<$Res>
    implements $OrganizationMatchCopyWith<$Res> {
  _$OrganizationMatchCopyWithImpl(this._self, this._then);

  final OrganizationMatch _self;
  final $Res Function(OrganizationMatch) _then;

/// Create a copy of OrganizationMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizationName = null,Object? normalizedOrganizationName = null,Object? ruleId = null,Object? ruleName = null,}) {
  return _then(OrganizationMatch(
organizationName: null == organizationName ? _self.organizationName : organizationName // ignore: cast_nullable_to_non_nullable
as String,normalizedOrganizationName: null == normalizedOrganizationName ? _self.normalizedOrganizationName : normalizedOrganizationName // ignore: cast_nullable_to_non_nullable
as String,ruleId: null == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String,ruleName: null == ruleName ? _self.ruleName : ruleName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrganizationMatch].
extension OrganizationMatchPatterns on OrganizationMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizationMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizationMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizationMatch value)  $default,){
final _that = this;
switch (_that) {
case _OrganizationMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizationMatch value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizationMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String organizationName,  String normalizedOrganizationName,  String ruleId,  String ruleName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizationMatch() when $default != null:
return $default(_that.organizationName,_that.normalizedOrganizationName,_that.ruleId,_that.ruleName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String organizationName,  String normalizedOrganizationName,  String ruleId,  String ruleName)  $default,) {final _that = this;
switch (_that) {
case _OrganizationMatch():
return $default(_that.organizationName,_that.normalizedOrganizationName,_that.ruleId,_that.ruleName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String organizationName,  String normalizedOrganizationName,  String ruleId,  String ruleName)?  $default,) {final _that = this;
switch (_that) {
case _OrganizationMatch() when $default != null:
return $default(_that.organizationName,_that.normalizedOrganizationName,_that.ruleId,_that.ruleName);case _:
  return null;

}
}

}

/// @nodoc


class _OrganizationMatch implements OrganizationMatch {
  const _OrganizationMatch({required this.organizationName, required this.normalizedOrganizationName, required this.ruleId, required this.ruleName});
  

@override final  String organizationName;
@override final  String normalizedOrganizationName;
@override final  String ruleId;
@override final  String ruleName;

/// Create a copy of OrganizationMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationMatchCopyWith<_OrganizationMatch> get copyWith => __$OrganizationMatchCopyWithImpl<_OrganizationMatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizationMatch&&(identical(other.organizationName, organizationName) || other.organizationName == organizationName)&&(identical(other.normalizedOrganizationName, normalizedOrganizationName) || other.normalizedOrganizationName == normalizedOrganizationName)&&(identical(other.ruleId, ruleId) || other.ruleId == ruleId)&&(identical(other.ruleName, ruleName) || other.ruleName == ruleName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,organizationName,normalizedOrganizationName,ruleId,ruleName);
}

@override
String toString() {
    return 'OrganizationMatch(organizationName: $organizationName, normalizedOrganizationName: $normalizedOrganizationName, ruleId: $ruleId, ruleName: $ruleName)';
}


}

/// @nodoc
abstract mixin class _$OrganizationMatchCopyWith<$Res> implements $OrganizationMatchCopyWith<$Res> {
  factory _$OrganizationMatchCopyWith(_OrganizationMatch value, $Res Function(_OrganizationMatch) _then) = __$OrganizationMatchCopyWithImpl;
@override @useResult
$Res call({
 String organizationName, String normalizedOrganizationName, String ruleId, String ruleName
});




}
/// @nodoc
class __$OrganizationMatchCopyWithImpl<$Res>
    implements _$OrganizationMatchCopyWith<$Res> {
  __$OrganizationMatchCopyWithImpl(this._self, this._then);

  final _OrganizationMatch _self;
  final $Res Function(_OrganizationMatch) _then;

/// Create a copy of OrganizationMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizationName = null,Object? normalizedOrganizationName = null,Object? ruleId = null,Object? ruleName = null,}) {
  return _then(_OrganizationMatch(
organizationName: null == organizationName ? _self.organizationName : organizationName // ignore: cast_nullable_to_non_nullable
as String,normalizedOrganizationName: null == normalizedOrganizationName ? _self.normalizedOrganizationName : normalizedOrganizationName // ignore: cast_nullable_to_non_nullable
as String,ruleId: null == ruleId ? _self.ruleId : ruleId // ignore: cast_nullable_to_non_nullable
as String,ruleName: null == ruleName ? _self.ruleName : ruleName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
