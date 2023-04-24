// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, avoid_print

import 'dart:io';

import 'package:chat_x/Widgets/Auth/Auth_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String? getURLAvatar;
  bool _isloading = false;
  void getAuthData(
      Map<String, String> userData, bool islogin, File? Avatar) async {
    setState(() {
      _isloading = true;
    });
    UserCredential userCredential;
    try {
      if (islogin) {
        //part login
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userData['email']!,
          password: userData['password']!,
        );
      } else {
        //part registr
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userData['email']!,
          password: userData['password']!,
        );
      }
      if (!islogin) {
        final StrogePath = FirebaseStorage.instance
            .ref()
            .child('UserAvatar')
            .child('${userCredential.user!.uid}.jpg');
        if (Avatar != null) {
          await StrogePath.putFile(Avatar);
          getURLAvatar = await StrogePath.getDownloadURL();
        }
        final firestorePath = FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid);
        await firestorePath.set(
          {
            'email': userData['email']!,
            'password': userData['password']!,
            'username': userData['userName']!,
            'AvatarUrl': Avatar == null
                ? 'https://firebasestorage.googleapis.com/v0/b/reliable-plasma-382001.appspot.com/o/images.png?alt=media&token=a7059296-1642-4aa3-af86-7578aa0129d0'
                : getURLAvatar,
          },
        );
      }
    } on FirebaseException catch (error) {
      var message = 'texnik xatolik iltimos qaytib urinib ko`ring';
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).errorColor,
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
      setState(() {
        _isloading = false;
      });
    } catch (er) {
      print(er);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: AuthField(getAuthData, _isloading),
    );
  }
}
