import 'package:intl/intl.dart';

/// Formats a DateTime into a human-readable relative time string.
/// Examples: "Just now", "5 min ago", "Yesterday", "03/31/2026"
String formatTime(DateTime time) {
  final now = DateTime.now();
  final difference = now.difference(time);

  if (difference.inSeconds < 60) return 'Just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
  if (difference.inHours < 24 && now.day == time.day) {
    return '${difference.inHours} hr ago';
  }
  if (difference.inDays == 1 && now.day - time.day == 1) {
    return 'Yesterday';
  }
  if (difference.inDays < 7) return DateFormat('EEE').format(time);

  return DateFormat('dd/MM/yyyy').format(time);
}
