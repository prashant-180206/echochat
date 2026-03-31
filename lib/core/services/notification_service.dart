import 'dart:async';

import 'package:echochat/core/singleton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(settings);

    final androidPermission =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidPermission?.requestNotificationsPermission();

    final iosPermission =
        _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    await iosPermission?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    _initialized = true;
  }

  static Future<void> showIncomingMessage({
    required String title,
    required String body,
  }) async {
    if (!_initialized) {
      await init();
    }

    const androidDetails = AndroidNotificationDetails(
      'echochat_messages',
      'EchoChat Messages',
      channelDescription: 'Notifications for new incoming messages',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _plugin.show(notificationId, title, body, details);
  }
}

class MessageNotificationService {
  static RealtimeChannel? _channel;
  static StreamSubscription<AuthState>? _authStateSub;
  static String? _activeUserId;
  static bool _started = false;
  static final ValueNotifier<int?> activeConversationId = ValueNotifier(null);
  static final Map<int, int> _lastNotifiedMessageByConversation = {};

  static Future<void> start() async {
    if (_started) return;
    _started = true;

    await AppNotificationService.init();

    _authStateSub = supabase.auth.onAuthStateChange.listen((event) async {
      await _setupForUser(event.session?.user.id);
    });

    await _setupForUser(supabase.auth.currentUser?.id);
  }

  static Future<void> _setupForUser(String? userId) async {
    if (_activeUserId == userId) return;

    await _teardownChannel();
    _activeUserId = userId;
    _lastNotifiedMessageByConversation.clear();

    if (userId == null) return;

    final channel = supabase.channel('incoming-message-notify-$userId');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'conversation',
      callback: (payload) {
        final row = payload.newRecord;
        if (row.isEmpty) return;

        final senderId = row['last_message_sender_id']?.toString();
        if (senderId == null || senderId == userId) return;

        final unread = row['unread'];
        final unreadCount = unread is int
            ? unread
            : int.tryParse(unread?.toString() ?? '0') ?? 0;
        if (unreadCount <= 0) return;

        final convoIdRaw = row['id'];
        final conversationId = convoIdRaw is int
            ? convoIdRaw
            : int.tryParse(convoIdRaw?.toString() ?? '');
        if (conversationId == null) return;

        if (activeConversationId.value == conversationId) {
          return;
        }

        final msgIdRaw = row['last_message'];
        final messageId = msgIdRaw is int
            ? msgIdRaw
            : int.tryParse(msgIdRaw?.toString() ?? '');
        if (messageId == null) return;

        final lastNotified = _lastNotifiedMessageByConversation[conversationId];
        if (lastNotified == messageId) return;
        _lastNotifiedMessageByConversation[conversationId] = messageId;

        final membersRaw = row['members'];
        String senderName = 'New message';
        if (membersRaw is List) {
          for (final member in membersRaw) {
            if (member is Map && member['id']?.toString() == senderId) {
              final name = member['name']?.toString().trim();
              if (name != null && name.isNotEmpty) {
                senderName = name;
              }
              break;
            }
          }
        }

        final messageType = row['last_message_type']?.toString();
        final content = row['last_message_content']?.toString() ?? '';
        final body = messageType == 'image'
            ? 'Sent an image'
            : (content.trim().isEmpty ? 'New message' : content.trim());

        AppNotificationService.showIncomingMessage(title: senderName, body: body);
      },
    );

    _channel = channel;
    channel.subscribe();
  }

  static Future<void> _teardownChannel() async {
    final channel = _channel;
    if (channel == null) return;

    try {
      await channel.unsubscribe();
      await supabase.removeChannel(channel);
    } catch (e) {
      logger.w('MessageNotificationService: Failed to teardown channel: $e');
    } finally {
      _channel = null;
    }
  }

  static Future<void> stop() async {
    await _authStateSub?.cancel();
    _authStateSub = null;
    _activeUserId = null;
    _started = false;
    _lastNotifiedMessageByConversation.clear();
    await _teardownChannel();
  }
}