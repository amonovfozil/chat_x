// ignore_for_file: file_names

import 'package:chat_x/Widgets/chat/chat_info.dart';
import 'package:flutter/material.dart';

import '../Widgets/chat/new_message.dart';
import '../Widgets/chat/message_field.dart';

class ChatScreen extends StatelessWidget {
  final String groupName;
  final String avatar;
  final List users;
  const ChatScreen(this.groupName, this.avatar, this.users, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ChatInfo(groupName, avatar, users))),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  avatar,
                ),
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    groupName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    '${users.length} users',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageField(groupName),
          ),
          NewMessage(groupName),
          const SizedBox(height: 5)
        ],
      ),
    );
  }
}
