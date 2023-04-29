import 'package:chat_x/Screens/Chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  final bool isMainPage;
  const GroupList(this.isMainPage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (context, streamsnapshots) {
          if (streamsnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return streamsnapshots.data != null
              ? Padding(
                  padding: const EdgeInsets.all(5),
                  child: ListView.builder(
                    itemCount: streamsnapshots.data!.docs.length,
                    itemBuilder: (context, index) {
                      final groups = streamsnapshots.data!.docs[index];
                      //guruh a`zolariga nisbatan saralash
                      final usersid = [];
                      (groups['users'] as List<dynamic>).map((e) {
                        usersid.add(e['id']);
                      }).toList();
                      return InkWell(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => ChatScreen(groups['name'],
                              groups['AvatarUrl'], groups['users'] as List),
                        )),
                        child: usersid.contains(currentUser!.uid)
                            ? ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    groups['AvatarUrl'],
                                  ),
                                  radius: 25,
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15),
                                    Text(
                                      groups['name'],
                                      style: TextStyle(
                                        color: isMainPage
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              )
                            : const Center(),
                      );
                    },
                  ),
                )
              : const Center(
                  child: Text(
                    'Group now',
                  ),
                );
        });
  }
}
