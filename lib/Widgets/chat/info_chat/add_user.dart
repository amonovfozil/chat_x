// ignore_for_file: non_constant_identifier_names

import 'package:chat_x/Screens/creatGroup.dart/creat_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> userdata;

  final List groupusers;
  final String groupname;
  const AddUser(this.userdata, this.groupusers, this.groupname, {super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  var init = true;
  final List<String> usersId = [];
  final List<userg> usersInfo = [];

  @override
  Widget build(BuildContext context) {
    if (init) {
      widget.groupusers.map((e) => usersId.add(e['id'])).toList();
      widget.groupusers
          .map((userData) => usersInfo.add(
                userg(
                    name: userData['name'],
                    url: userData['avatar'],
                    id: userData['id']),
              ))
          .toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Users'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.userdata.map((User) {
          return ListTile(
            onTap: () {
              if (!usersId.contains(User.id)) {
                usersId.add(User.id);
                usersInfo.add(
                  userg(
                      name: User['username'],
                      url: User['AvatarUrl'],
                      id: User.id),
                );
              }

              setState(() {});
              init = false;
              // print(usersInfo.length);
              // print(usersInfo);
              // print(init);
            },
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                User['AvatarUrl'],
              ),
            ),
            title: Text(
              User['username'],
            ),
            subtitle: Text(
              User['email'],
            ),
            trailing: Checkbox(
              value: usersId.contains(User.id),
              onChanged: (value) {},
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('groups')
              .doc(widget.groupname)
              .update(
            {
              'users': usersInfo
                  .map((users) =>
                      {'avatar': users.url, 'name': users.name, 'id': users.id})
                  .toList(),
            },
          );
        },
        child: const Icon(
          Icons.check,
        ),
      ),
    );
  }
}
