// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class AvatarWidgets extends StatefulWidget {
  const AvatarWidgets(
      {Key? key,
      required this.avatar,
      required this.groupname,
      required this.childname})
      : super(key: key);

  final String avatar;
  final String groupname;
  final String childname;

  @override
  State<AvatarWidgets> createState() => _AvatarWidgetsState();
}

class _AvatarWidgetsState extends State<AvatarWidgets> {
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
        .child(widget.groupname)
        .child('${widget.childname}.jpg');

    await StrogePath.putFile(getimage!);
    // final getURLAvatar = await StrogePath.getDownloadURL();
    // final firestorePath =
    //     FirebaseFirestore.instance.collection(widget.groupname).doc(widget.childname);
    // await firestorePath.update(
    //   {
    //     'AvatarUrl': getURLAvatar,
    //   },
    // );
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