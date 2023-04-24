// ignore_for_file: camel_case_types, unused_local_variable, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, avoid_print

import 'dart:io';

import 'package:chat_x/Widgets/get_AvatarImage.dart';
import 'package:chat_x/Widgets/group_list.dart';
import 'package:chat_x/Widgets/sidebar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class creatGroup extends StatelessWidget {
  const creatGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();
    File? getImage;
    bool isloading;

    String? title;
    void getImageOfAvatar(File image) {
      getImage = image;
    }

    void submitNewGroupData() async {
      if (getImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: const Text(
              'Please enter Avatar',
            ),
          ),
        );
        return;
      }
      if (_formkey.currentState!.validate()) {
        _formkey.currentState!.save();
        try {
          final path = FirebaseStorage.instance
              .ref()
              .child('groups')
              .child('$title.jpg');
          await path.putFile(getImage!);
          final AvatarUrl = await path.getDownloadURL();
          FirebaseFirestore.instance.collection('Groups').doc(title!).set(
            {
              'name': title,
              'avatar': AvatarUrl,
            },
          );
        } on FirebaseException catch (error) {
          var message = 'texnik xatolik iltimos qaytib urinib ko`ring';
          if (error.message != null) {
            message = error.message!;
          }
          ScaffoldMessenger.of(context).showMaterialBanner(
            MaterialBanner(
              backgroundColor: Theme.of(context).errorColor,
              content: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
                  child: const Text(
                    'OK',
                  ),
                ),
              ],
            ),
          );
          print(error);
        } catch (e) {
          print(e);
        }

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    }

    void showAddNewGroup() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          content: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'CREAT GROUP',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                getAvatarImage(getImageOfAvatar),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Group name:',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Group name';
                    }
                    return null;
                  },
                  onSaved: (newValue) => title = newValue!,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submitNewGroupData,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 10)),
                  child: const Text(
                    'OK',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Groups',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: showAddNewGroup,
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      drawer: const SideBar(),
      body: const GroupList(false),
    );
  }
}
