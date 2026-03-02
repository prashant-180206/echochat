// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_list_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConversationListView {

@JsonKey(name: 'conversation_id') int get conversationId;@JsonKey(name: 'created_at') DateTime get createdAt; int get unread;@JsonKey(name: 'last_time') DateTime get lastTime;@JsonKey(name: 'message_id') int? get messageId; String? get content;@JsonKey(name: 'sender_id') String? get senderId;@JsonKey(name: 'message_created_at') DateTime? get messageCreatedAt;@JsonKey(name: 'other_user_id') String get otherUserId; String get name; String get email;@JsonKey(name: 'avatar_url') String get avatarUrl;
/// Create a copy of ConversationListView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationListViewCopyWith<ConversationListView> get copyWith => _$ConversationListViewCopyWithImpl<ConversationListView>(this as ConversationListView, _$identity);

  /// Serializes this ConversationListView to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationListView&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.unread, unread) || other.unread == unread)&&(identical(other.lastTime, lastTime) || other.lastTime == lastTime)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.content, content) || other.content == content)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.messageCreatedAt, messageCreatedAt) || other.messageCreatedAt == messageCreatedAt)&&(identical(other.otherUserId, otherUserId) || other.otherUserId == otherUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,createdAt,unread,lastTime,messageId,content,senderId,messageCreatedAt,otherUserId,name,email,avatarUrl);

@override
String toString() {
  return 'ConversationListView(conversationId: $conversationId, createdAt: $createdAt, unread: $unread, lastTime: $lastTime, messageId: $messageId, content: $content, senderId: $senderId, messageCreatedAt: $messageCreatedAt, otherUserId: $otherUserId, name: $name, email: $email, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class $ConversationListViewCopyWith<$Res>  {
  factory $ConversationListViewCopyWith(ConversationListView value, $Res Function(ConversationListView) _then) = _$ConversationListViewCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conversation_id') int conversationId,@JsonKey(name: 'created_at') DateTime createdAt, int unread,@JsonKey(name: 'last_time') DateTime lastTime,@JsonKey(name: 'message_id') int? messageId, String? content,@JsonKey(name: 'sender_id') String? senderId,@JsonKey(name: 'message_created_at') DateTime? messageCreatedAt,@JsonKey(name: 'other_user_id') String otherUserId, String name, String email,@JsonKey(name: 'avatar_url') String avatarUrl
});




}
/// @nodoc
class _$ConversationListViewCopyWithImpl<$Res>
    implements $ConversationListViewCopyWith<$Res> {
  _$ConversationListViewCopyWithImpl(this._self, this._then);

  final ConversationListView _self;
  final $Res Function(ConversationListView) _then;

/// Create a copy of ConversationListView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? createdAt = null,Object? unread = null,Object? lastTime = null,Object? messageId = freezed,Object? content = freezed,Object? senderId = freezed,Object? messageCreatedAt = freezed,Object? otherUserId = null,Object? name = null,Object? email = null,Object? avatarUrl = null,}) {
  return _then(_self.copyWith(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,lastTime: null == lastTime ? _self.lastTime : lastTime // ignore: cast_nullable_to_non_nullable
as DateTime,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,messageCreatedAt: freezed == messageCreatedAt ? _self.messageCreatedAt : messageCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,otherUserId: null == otherUserId ? _self.otherUserId : otherUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationListView].
extension ConversationListViewPatterns on ConversationListView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationListView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationListView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationListView value)  $default,){
final _that = this;
switch (_that) {
case _ConversationListView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationListView value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationListView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  int conversationId, @JsonKey(name: 'created_at')  DateTime createdAt,  int unread, @JsonKey(name: 'last_time')  DateTime lastTime, @JsonKey(name: 'message_id')  int? messageId,  String? content, @JsonKey(name: 'sender_id')  String? senderId, @JsonKey(name: 'message_created_at')  DateTime? messageCreatedAt, @JsonKey(name: 'other_user_id')  String otherUserId,  String name,  String email, @JsonKey(name: 'avatar_url')  String avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationListView() when $default != null:
return $default(_that.conversationId,_that.createdAt,_that.unread,_that.lastTime,_that.messageId,_that.content,_that.senderId,_that.messageCreatedAt,_that.otherUserId,_that.name,_that.email,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id')  int conversationId, @JsonKey(name: 'created_at')  DateTime createdAt,  int unread, @JsonKey(name: 'last_time')  DateTime lastTime, @JsonKey(name: 'message_id')  int? messageId,  String? content, @JsonKey(name: 'sender_id')  String? senderId, @JsonKey(name: 'message_created_at')  DateTime? messageCreatedAt, @JsonKey(name: 'other_user_id')  String otherUserId,  String name,  String email, @JsonKey(name: 'avatar_url')  String avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ConversationListView():
return $default(_that.conversationId,_that.createdAt,_that.unread,_that.lastTime,_that.messageId,_that.content,_that.senderId,_that.messageCreatedAt,_that.otherUserId,_that.name,_that.email,_that.avatarUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'conversation_id')  int conversationId, @JsonKey(name: 'created_at')  DateTime createdAt,  int unread, @JsonKey(name: 'last_time')  DateTime lastTime, @JsonKey(name: 'message_id')  int? messageId,  String? content, @JsonKey(name: 'sender_id')  String? senderId, @JsonKey(name: 'message_created_at')  DateTime? messageCreatedAt, @JsonKey(name: 'other_user_id')  String otherUserId,  String name,  String email, @JsonKey(name: 'avatar_url')  String avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ConversationListView() when $default != null:
return $default(_that.conversationId,_that.createdAt,_that.unread,_that.lastTime,_that.messageId,_that.content,_that.senderId,_that.messageCreatedAt,_that.otherUserId,_that.name,_that.email,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationListView implements ConversationListView {
  const _ConversationListView({@JsonKey(name: 'conversation_id') required this.conversationId, @JsonKey(name: 'created_at') required this.createdAt, required this.unread, @JsonKey(name: 'last_time') required this.lastTime, @JsonKey(name: 'message_id') this.messageId, this.content, @JsonKey(name: 'sender_id') this.senderId, @JsonKey(name: 'message_created_at') this.messageCreatedAt, @JsonKey(name: 'other_user_id') required this.otherUserId, required this.name, required this.email, @JsonKey(name: 'avatar_url') required this.avatarUrl});
  factory _ConversationListView.fromJson(Map<String, dynamic> json) => _$ConversationListViewFromJson(json);

@override@JsonKey(name: 'conversation_id') final  int conversationId;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override final  int unread;
@override@JsonKey(name: 'last_time') final  DateTime lastTime;
@override@JsonKey(name: 'message_id') final  int? messageId;
@override final  String? content;
@override@JsonKey(name: 'sender_id') final  String? senderId;
@override@JsonKey(name: 'message_created_at') final  DateTime? messageCreatedAt;
@override@JsonKey(name: 'other_user_id') final  String otherUserId;
@override final  String name;
@override final  String email;
@override@JsonKey(name: 'avatar_url') final  String avatarUrl;

/// Create a copy of ConversationListView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationListViewCopyWith<_ConversationListView> get copyWith => __$ConversationListViewCopyWithImpl<_ConversationListView>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationListViewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationListView&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.unread, unread) || other.unread == unread)&&(identical(other.lastTime, lastTime) || other.lastTime == lastTime)&&(identical(other.messageId, messageId) || other.messageId == messageId)&&(identical(other.content, content) || other.content == content)&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.messageCreatedAt, messageCreatedAt) || other.messageCreatedAt == messageCreatedAt)&&(identical(other.otherUserId, otherUserId) || other.otherUserId == otherUserId)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,conversationId,createdAt,unread,lastTime,messageId,content,senderId,messageCreatedAt,otherUserId,name,email,avatarUrl);

@override
String toString() {
  return 'ConversationListView(conversationId: $conversationId, createdAt: $createdAt, unread: $unread, lastTime: $lastTime, messageId: $messageId, content: $content, senderId: $senderId, messageCreatedAt: $messageCreatedAt, otherUserId: $otherUserId, name: $name, email: $email, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ConversationListViewCopyWith<$Res> implements $ConversationListViewCopyWith<$Res> {
  factory _$ConversationListViewCopyWith(_ConversationListView value, $Res Function(_ConversationListView) _then) = __$ConversationListViewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'conversation_id') int conversationId,@JsonKey(name: 'created_at') DateTime createdAt, int unread,@JsonKey(name: 'last_time') DateTime lastTime,@JsonKey(name: 'message_id') int? messageId, String? content,@JsonKey(name: 'sender_id') String? senderId,@JsonKey(name: 'message_created_at') DateTime? messageCreatedAt,@JsonKey(name: 'other_user_id') String otherUserId, String name, String email,@JsonKey(name: 'avatar_url') String avatarUrl
});




}
/// @nodoc
class __$ConversationListViewCopyWithImpl<$Res>
    implements _$ConversationListViewCopyWith<$Res> {
  __$ConversationListViewCopyWithImpl(this._self, this._then);

  final _ConversationListView _self;
  final $Res Function(_ConversationListView) _then;

/// Create a copy of ConversationListView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? createdAt = null,Object? unread = null,Object? lastTime = null,Object? messageId = freezed,Object? content = freezed,Object? senderId = freezed,Object? messageCreatedAt = freezed,Object? otherUserId = null,Object? name = null,Object? email = null,Object? avatarUrl = null,}) {
  return _then(_ConversationListView(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,lastTime: null == lastTime ? _self.lastTime : lastTime // ignore: cast_nullable_to_non_nullable
as DateTime,messageId: freezed == messageId ? _self.messageId : messageId // ignore: cast_nullable_to_non_nullable
as int?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,senderId: freezed == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String?,messageCreatedAt: freezed == messageCreatedAt ? _self.messageCreatedAt : messageCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,otherUserId: null == otherUserId ? _self.otherUserId : otherUserId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: null == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
