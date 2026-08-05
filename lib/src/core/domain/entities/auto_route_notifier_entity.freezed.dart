// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_route_notifier_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AutoRouteNotifierEntity {

 Failure? get failure; set failure(Failure? value); bool get hasInternet; set hasInternet(bool value);
/// Create a copy of AutoRouteNotifierEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AutoRouteNotifierEntityCopyWith<AutoRouteNotifierEntity> get copyWith => _$AutoRouteNotifierEntityCopyWithImpl<AutoRouteNotifierEntity>(this as AutoRouteNotifierEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AutoRouteNotifierEntity&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.hasInternet, hasInternet) || other.hasInternet == hasInternet));
}


@override
int get hashCode => Object.hash(runtimeType,failure,hasInternet);

@override
String toString() {
  return 'AutoRouteNotifierEntity(failure: $failure, hasInternet: $hasInternet)';
}


}

/// @nodoc
abstract mixin class $AutoRouteNotifierEntityCopyWith<$Res>  {
  factory $AutoRouteNotifierEntityCopyWith(AutoRouteNotifierEntity value, $Res Function(AutoRouteNotifierEntity) _then) = _$AutoRouteNotifierEntityCopyWithImpl;
@useResult
$Res call({
 Failure? failure, bool hasInternet
});




}
/// @nodoc
class _$AutoRouteNotifierEntityCopyWithImpl<$Res>
    implements $AutoRouteNotifierEntityCopyWith<$Res> {
  _$AutoRouteNotifierEntityCopyWithImpl(this._self, this._then);

  final AutoRouteNotifierEntity _self;
  final $Res Function(AutoRouteNotifierEntity) _then;

/// Create a copy of AutoRouteNotifierEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? failure = freezed,Object? hasInternet = null,}) {
  return _then(AutoRouteNotifierEntity(
failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,hasInternet: null == hasInternet ? _self.hasInternet : hasInternet // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AutoRouteNotifierEntity].
extension AutoRouteNotifierEntityPatterns on AutoRouteNotifierEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({required TResult orElse(),}){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(){
final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({required TResult orElse(),}) {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>() {final _that = this;
switch (_that) {
case _:
  return null;

}
}

}

// dart format on
