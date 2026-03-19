
import 'package:echochat/core/services/message_service.dart';
import 'package:echochat/core/singleton.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageInput extends HookConsumerWidget {
  final int conversationId;
  const MessageInput({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.attach_file)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 228, 228),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5, // expands like WhatsApp
                  decoration: const InputDecoration(
                    hintText: 'Message',
                    contentPadding: EdgeInsets.all(4),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
        
            IconButton(
              color: Theme.of(context).primaryColor,
              iconSize: 35,
              onPressed: () => {
                logger.d("Send button pressed with message: ${controller.text}"),
                MessageService.sendMessage(conversationId: conversationId, content: controller.text)
              },
              icon: Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
