// ignore_for_file: camel_case_types, unused_local_variable, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Screens/creatGroup.dart/NamedGroup.dart';

class creatGroup extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> userdata;

  const creatGroup(this.userdata, {super.key});

  @override
  State<creatGroup> createState() => _creatGroupState();
}

class userg {
  final String name;
  final String url;
  final String id;
  userg({
    required this.name,
    required this.url,
    required this.id,
  });
}

class _creatGroupState extends State<creatGroup> {
  final List<String> userIds = [];
  final List<userg> userinfo = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Creat Group',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Select Users:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: widget.userdata.length,
                itemBuilder: (context, index) {
                  final users = widget.userdata[index];

                  return ListTile(
                    onTap: () {
                      setState(() {
                        if (!userIds.contains(users.id)) {
                          userIds.add(users.id);
                          userinfo.add(userg(
                            name: users['username'],
                            url: users['AvatarUrl'],
                            id: users.id,
                          ));
                        } else {
                          userIds.remove(users.id);
                          userinfo.add(userg(
                            name: users['username'],
                            url: users['AvatarUrl'],
                            id: users.id,
                          ));
                        }
                      });
                    },
                    tileColor: userIds.contains(users.id)
                        ? Theme.of(context).primaryColorLight
                        : Colors.transparent,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        users['AvatarUrl'],
                      ),
                      radius: 22,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                users['username'],
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            if (userIds.contains(users.id))
                              Checkbox(
                                value:
                                    userIds.contains(users.id) ? true : false,
                                onChanged: (value) {},
                              )
                          ],
                        ),
                        const Divider(
                          height: 0,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => NamedGroup(userIds, userinfo),
            ),
          );
        },
        child: const Icon(
          Icons.navigate_next_sharp,
          size: 35,
        ),
      ),
    );
  }
}
