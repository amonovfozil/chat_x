import 'package:chat_x/Widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact',
        ),
        centerTitle: true,
      ),
      drawer: const SideBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                      final users = streamsnapshots.data!.docs[index];

                      return InkWell(
                        onTap: () {},
                        child: ListTile(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    users['username'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      //
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                    ),
                                  ),
                                ],
                              ),
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
        },
      ),
    );
  }
}
