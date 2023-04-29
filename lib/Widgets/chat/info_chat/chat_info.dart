// ignore_for_file: non_constant_identifier_names

import 'package:chat_x/Screens/creatGroup.dart/creat_group.dart';
import 'package:chat_x/Widgets/change_avatar.dart';
import 'package:chat_x/Widgets/chat/info_chat/add_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatInfo extends StatefulWidget {
  final String groupName;
  final String avatar;
  final List groupusers;
  const ChatInfo(this.groupName, this.avatar, this.groupusers, {super.key});

  @override
  State<ChatInfo> createState() => _ChatInfoState();
}

class _ChatInfoState extends State<ChatInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, streamsnapshot) {
            if (streamsnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Theme.of(context).primaryColorDark,
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
                              avatar: widget.avatar,
                              groupname: 'groups',
                              childname: widget.groupName,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.groupName.toUpperCase(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${widget.groupusers.length} users',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 2,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextButton.icon(
                        onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (ctx) => AddUser(
                                    streamsnapshot.data!.docs,
                                    widget.groupusers,
                                    widget.groupName))),
                        icon: const Icon(
                          Icons.group_add_outlined,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'add freind',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      'users:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.groupusers.length,
                      itemBuilder: (context, index) {
                        final user = widget.groupusers[index];

                        return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                user['avatar'],
                              ),
                              radius: 22,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        user['name'],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                                tooltip: 'delete User',
                                itemBuilder: (ctx) => [
                                      PopupMenuItem(
                                          child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            widget.groupusers.removeWhere(
                                                (element) =>
                                                    element['id'] ==
                                                    user['id']);
                                          });
                                          FirebaseFirestore.instance
                                              .collection('groups')
                                              .doc(widget.groupName)
                                              .update(
                                            {
                                              'users': widget.groupusers
                                                  .map((users) => {
                                                        'avatar':
                                                            users['avatar'],
                                                        'name': users['name'],
                                                        'id': users['id']
                                                      })
                                                  .toList(),
                                            },
                                          );

                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Delete'),
                                      ))
                                    ]));
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
