import 'package:chat_x/Screens/Chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupList extends StatelessWidget {
  final bool isMainPage;
  const GroupList(this.isMainPage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Groups').snapshots(),
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

                      return InkWell(
                        onTap: !isMainPage
                            ? () {}
                            : () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => ChatScreen(groups['name']),
                                )),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              groups['avatar'],
                            ),
                            radius: 25,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15),
                              Text(
                                groups['name'],
                                style:  TextStyle(
                                  color:
                                      isMainPage ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Divider(
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
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
