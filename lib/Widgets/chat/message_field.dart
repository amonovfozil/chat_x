// ignore_for_file: avoid_print

import 'package:chat_x/Widgets/chat/Bubble_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageField extends StatelessWidget {
  final String groupName;
  const MessageField(this.groupName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chats/wTbrb3MnCRv8A7vGF2pj/$groupName')
          .orderBy('writeTime', descending: true)
          .snapshots(),
      builder: (ctx, streamsnapshot) {
        if (streamsnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return streamsnapshot.data != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  reverse: true,
                  itemCount: streamsnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final message = streamsnapshot.data!.docs[index];
                    return MesssageBubble(
                      message: message['text'],
                      Avatar: message['avatar'],
                      userName: message['username'],
                      isMe: message['userid'] == currentUser!.uid,
                      userid: message['userid'],
                    );
                  },
                ),
              )
            : const Center(
                child: Text('data now'),
              );
      },
    );
  }
}
