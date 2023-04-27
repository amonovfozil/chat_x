import 'package:chat_x/Screens/settings_screen.dart';
import 'package:flutter/material.dart';

class ChatInfo extends StatelessWidget {
  final String groupName;
  final String avatar;
  final List users;
  const ChatInfo(this.groupName, this.avatar, this.users, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 20),
                AvatarWidgets(
                  avatar: avatar,
                  groupname: 'groups',
                  childname: groupName,
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
          ],
        ),
      ),
    );
  }
}
