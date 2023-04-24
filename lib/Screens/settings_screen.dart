// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:chat_x/Widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SettingsApp extends StatelessWidget {
  final String avatar;
  final String username;
  final String email;
  const SettingsApp(this.avatar, this.username, this.email, {super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: scaffoldKey,
      drawer: const SideBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              color: Theme.of(context).primaryColorDark,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () =>
                              scaffoldKey.currentState!.openDrawer(),
                          icon: const Icon(
                            Icons.format_align_left,
                            size: 30,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(0.0),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 120,
                      child: Row(
                        children: [
                          AvatarWidgets(avatar: avatar),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 30),
                              Text(
                                username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                              ),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AvatarWidgets extends StatefulWidget {
  const AvatarWidgets({Key? key, required this.avatar}) : super(key: key);

  final String avatar;

  @override
  State<AvatarWidgets> createState() => _AvatarWidgetsState();
}

class _AvatarWidgetsState extends State<AvatarWidgets> {
  final currentUser = FirebaseAuth.instance.currentUser;
  File? getimage;
  void changeavatar() async {
    ImagePicker pickedimage = ImagePicker();
    XFile? xfile = await pickedimage.pickImage(
      source: ImageSource.gallery,
    );

    if (xfile != null) {
      setState(() {
        getimage = File(xfile.path);
      });
    }
    //firebasestorega yuborish jarayoni
    final StrogePath = FirebaseStorage.instance
        .ref()
        .child('UserAvatar')
        .child('${currentUser!.uid}.jpg');

    await StrogePath.putFile(getimage!);
    final getURLAvatar = await StrogePath.getDownloadURL();
    final firestorePath =
        FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
    await firestorePath.update(
      {
        'AvatarUrl': getURLAvatar,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        getimage != null
            ? CircleAvatar(
                backgroundImage: FileImage(
                  getimage!,
                ),
                minRadius: 50,
              )
            : CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.avatar,
                ),
                minRadius: 50,
              ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).primaryColorLight,
            ),
            child: IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: changeavatar,
                icon: Icon(
                  Icons.add_a_photo_sharp,
                  color: Theme.of(context).primaryColorDark,
                  size: 25,
                )),
          ),
        )
      ],
    );
  }
}
