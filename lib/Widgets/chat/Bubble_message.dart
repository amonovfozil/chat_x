// ignore_for_file: file_names, non_constant_identifier_names, unnecessary_null_comparison

import 'package:flutter/material.dart';

class MesssageBubble extends StatelessWidget {
  final String message;
  final String Avatar;
  final String userName;
  final bool isMe;

  final String userid;
  const MesssageBubble(
      {required this.message,
      required this.Avatar,
      required this.userName,
      required this.isMe,
      required this.userid,
      super.key});

  @override
  Widget build(BuildContext context) {
    return message != null
        ? Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe)
                CircleAvatar(
                  backgroundImage: NetworkImage(Avatar),
                  radius: 18,
                ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.black26
                        : Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomRight: isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(15),
                      bottomLeft: isMe
                          ? const Radius.circular(15)
                          : const Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Text(
                            userName,
                            style: const TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        if (!isMe) const SizedBox(height: 5),
                        Text(
                          message,
                          maxLines: 5,
                          style: TextStyle(
                            color: isMe
                                ? Colors.black
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isMe)
                CircleAvatar(
                  backgroundImage: NetworkImage(Avatar),
                  radius: 18,
                ),
            ],
          )
        : const Center();
  }
}
