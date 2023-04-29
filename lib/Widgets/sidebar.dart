// ignore_for_file: unnecessary_null_comparison

import 'package:chat_x/Screens/contac_list_screen.dart';
import 'package:chat_x/Screens/creatGroup.dart/creat_group.dart';
import 'package:chat_x/Screens/main_CHatPage_screen.dart';
import 'package:chat_x/Screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    Widget SideBarIteams(Widget RoutPage, IconData icon, String label) {
      return TextButton.icon(
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RoutPage,
          ),
        ),
        icon: Icon(
          icon,
          size: 25,
        ),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>> != null
            ? StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        streamsnapshots) {
                  if (streamsnapshots.connectionState ==
                      ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  // if (streamsnapshots.data!.docs == null) {
                  //   return Text('malumot topilmadi');
                  // }
                  final userdata = streamsnapshots.data!.docs
                      .where((element) => element.id == user!.uid)
                      .toList();

                  // if (userdata == null) {
                  //   return Container();
                  // }
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () => showDialog(
                          context: context,
                          builder: (ctx) => Center(
                            child: SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: Image.network(
                                userdata[0]['AvatarUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            userdata[0]['AvatarUrl'],
                          ),
                          radius: 70,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        userdata[0]['username'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SideBarIteams(
                                  const MainChatPageScreen(),
                                  Icons.home,
                                  'Bosh Sahifa',
                                ),
                                const Divider(
                                  height: 0,
                                ),
                                SideBarIteams(
                                    ContactList(streamsnapshots.data!.docs),
                                    Icons.contacts,
                                    'contacts'),
                                TextButton.icon(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => creatGroup(
                                          streamsnapshots.data!.docs),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.create_new_folder,
                                    size: 25,
                                  ),
                                  label: const Text(
                                    'Creat New Group',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                // SideBarIteams(const creatGroup(),
                                //     Icons.create_new_folder, 'Creat New Group'),
                                SideBarIteams(
                                    SettingsApp(
                                        userdata[0]['AvatarUrl'],
                                        userdata[0]['username'],
                                        userdata[0]['email']),
                                    Icons.settings,
                                    'Setting accaunt'),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                })
            : const Center(
                child: Text('data now'),
              ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.exit_to_app_outlined,
              ),
              label: const Text(
                'Exit From App',
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                final user = FirebaseAuth.instance.currentUser;
                Future.delayed(const Duration(milliseconds: 300))
                    .then((_) async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user!.uid)
                      .delete();
                  FirebaseStorage.instance
                      .ref()
                      .child('UserAvatar')
                      .child('${user.uid}.jpg')
                      .delete();
                  user.delete();

                  FirebaseAuth.instance.signOut();
                });
              },
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).errorColor,
              ),
              label: Text(
                'Log out',
                style: TextStyle(
                  color: Theme.of(context).errorColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
