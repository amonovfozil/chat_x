// ignore_for_file: file_names, camel_case_types

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class getAvatarImage extends StatefulWidget {
  final Function getImage;
  const getAvatarImage(this.getImage, {super.key});

  @override
  State<getAvatarImage> createState() => _getAvatarImageState();
}

class _getAvatarImageState extends State<getAvatarImage> {
  File? _getimage;

  void getAvatar() async {
    ImagePicker pickedimage = ImagePicker();
    XFile? xfile = await pickedimage.pickImage(
      source: ImageSource.gallery,
    );

    if (xfile != null) {
      setState(() {
        _getimage = File(xfile.path);
      });
      widget.getImage(_getimage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getimage == null
            ? const CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
                radius: 45,
              )
            : CircleAvatar(
                backgroundImage: FileImage(_getimage!),
                radius: 45,
              ),
        TextButton(
          onPressed: getAvatar,
          child: const Text(
            'Enter User Avatar',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
