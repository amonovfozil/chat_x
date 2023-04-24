import 'package:chat_x/Widgets/chat/new_message.dart';
import 'package:flutter/material.dart';

import '../Widgets/chat/message_field.dart';

class ChatScreen extends StatelessWidget {
  final String groupName;
  const ChatScreen(this.groupName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          groupName,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageField(groupName),
          ),
          NewMessage(groupName),
        ],
      ),
    );
  }
}
