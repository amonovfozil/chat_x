// ignore_for_file: file_names, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:io';

import 'package:chat_x/Screens/creatGroup.dart/creat_group.dart';
import 'package:chat_x/Widgets/get_AvatarImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NamedGroup extends StatelessWidget {
  final List<String> usersId;
  final List<userg> usersinfo;
  const NamedGroup(this.usersId, this.usersinfo, {super.key});

  @override
  Widget build(BuildContext context) {
    File? getImage;

    String? title;
    void getImageOfAvatar(File image) {
      getImage = image;
    }

    final formkey = GlobalKey<FormState>();

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
      if (formkey.currentState!.validate()) {
        formkey.currentState!.save();
        try {
          final path = FirebaseStorage.instance
              .ref()
              .child('groups')
              .child('$title.jpg');
          await path.putFile(getImage!);
          final AvatarUrl = await path.getDownloadURL();
          FirebaseFirestore.instance.collection('groups').doc(title!).set(
            {'name': title, 'AvatarUrl': AvatarUrl, 'users': usersId},
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
        } catch (e) {
          rethrow;
        }

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Creat Group',
        ),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  getAvatarImage(getImageOfAvatar),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextFormField(
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
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  'users:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              if (UserInfo != null)
                Expanded(
                  child: ListView.builder(
                      itemCount: usersinfo.length,
                      itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(usersinfo[i].url),
                          ),
                          title: Text(
                            usersinfo[i].name,
                          ))),
                )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitNewGroupData,
        child: const Icon(
          Icons.check,
          size: 35,
        ),
      ),
    );
  }
}
