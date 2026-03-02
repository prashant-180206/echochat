// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_participant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationParticipant {

@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'conversation_id') int get conversationId;
/// Create a copy of ConversationParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationParticipantCopyWith<ConversationParticipant> get copyWith => _$ConversationParticipantCopyWithImpl<ConversationParticipant>(this as ConversationParticipant, _$identity);

  /// Serializes this ConversationParticipant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationParticipant&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,conversationId);

@override
String toString() {
  return 'ConversationParticipant(userId: $userId, conversationId: $conversationId)';
}


}

/// @nodoc
abstract mixin class $ConversationParticipantCopyWith<$Res>  {
  factory $ConversationParticipantCopyWith(ConversationParticipant value, $Res Function(ConversationParticipant) _then) = _$ConversationParticipantCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'conversation_id') int conversationId
});




}
/// @nodoc
class _$ConversationParticipantCopyWithImpl<$Res>
    implements $ConversationParticipantCopyWith<$Res> {
  _$ConversationParticipantCopyWithImpl(this._self, this._then);

  final ConversationParticipant _self;
  final $Res Function(ConversationParticipant) _then;

/// Create a copy of ConversationParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? conversationId = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationParticipant].
extension ConversationParticipantPatterns on ConversationParticipant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationParticipant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationParticipant value)  $default,){
final _that = this;
switch (_that) {
case _ConversationParticipant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationParticipant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'conversation_id')  int conversationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationParticipant() when $default != null:
return $default(_that.userId,_that.conversationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'conversation_id')  int conversationId)  $default,) {final _that = this;
switch (_that) {
case _ConversationParticipant():
return $default(_that.userId,_that.conversationId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'conversation_id')  int conversationId)?  $default,) {final _that = this;
switch (_that) {
case _ConversationParticipant() when $default != null:
return $default(_that.userId,_that.conversationId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationParticipant implements ConversationParticipant {
   _ConversationParticipant({@JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'conversation_id') required this.conversationId});
  factory _ConversationParticipant.fromJson(Map<String, dynamic> json) => _$ConversationParticipantFromJson(json);

@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'conversation_id') final  int conversationId;

/// Create a copy of ConversationParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationParticipantCopyWith<_ConversationParticipant> get copyWith => __$ConversationParticipantCopyWithImpl<_ConversationParticipant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationParticipant&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,conversationId);

@override
String toString() {
  return 'ConversationParticipant(userId: $userId, conversationId: $conversationId)';
}


}

/// @nodoc
abstract mixin class _$ConversationParticipantCopyWith<$Res> implements $ConversationParticipantCopyWith<$Res> {
  factory _$ConversationParticipantCopyWith(_ConversationParticipant value, $Res Function(_ConversationParticipant) _then) = __$ConversationParticipantCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'conversation_id') int conversationId
});




}
/// @nodoc
class __$ConversationParticipantCopyWithImpl<$Res>
    implements _$ConversationParticipantCopyWith<$Res> {
  __$ConversationParticipantCopyWithImpl(this._self, this._then);

  final _ConversationParticipant _self;
  final $Res Function(_ConversationParticipant) _then;

/// Create a copy of ConversationParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? conversationId = null,}) {
  return _then(_ConversationParticipant(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
