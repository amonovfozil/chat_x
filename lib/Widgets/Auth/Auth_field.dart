// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:chat_x/Widgets/get_AvatarImage.dart';
import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final Function getAuthData;
  final bool isloading;
  const AuthField(this.getAuthData, this.isloading, {super.key});

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  final _formkey = GlobalKey<FormState>();
  bool isLogin = true;
  File? getImage;

  // ignore: non_constant_identifier_names
  Map<String, String> AuthData = {
    'email': '',
    'password': '',
    "userName": '',
  };

  void getImageOfAvatar(File image) {
    getImage = image;
  }

  void submitAuthData() {
    FocusScope.of(context).unfocus();

    if (getImage == null && !isLogin) {
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
      widget.getAuthData(
        AuthData,
        isLogin,
        getImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isLogin) getAvatarImage(getImageOfAvatar),
                  TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      suffixIconColor: Colors.black,
                      labelText: 'email:',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Enter email adress';
                      } else if (!email.contains('@')) {
                        return 'The email address is incorrect';
                      }
                      return null;
                    },
                    onSaved: (newValue) => AuthData['email'] = newValue!,
                  ),
                  if (!isLogin)
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,

                      decoration: const InputDecoration(
                        labelText: 'User name:',
                      ),
                      textInputAction: TextInputAction.next,

                      // ignore: non_constant_identifier_names
                      validator: (Username) {
                        if (Username == null || Username.isEmpty) {
                          return 'Enter User name';
                        }
                        return null;
                      },
                      onSaved: (newValue) => AuthData['userName'] = newValue!,
                    ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'password:',
                    ),
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Enter password';
                      } else if (password.length < 6) {
                        return 'The email address is incorrect';
                      }
                      return null;
                    },
                    onSaved: (newValue) => AuthData['password'] = newValue!,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitAuthData,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15)),
                    child: widget.isloading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            isLogin ? 'Kirish' : "Ro'xatdan o'tish",
                          ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin ? "Ro'xatdan o'tish" : 'Kirish',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
