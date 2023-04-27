import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String groupName;
  const NewMessage(this.groupName, {super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  // ignore: non_constant_identifier_names
  final Messagecontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String? _newMessage;

  User? user;
  // ignore: prefer_typing_uninitialized_variables
  late final userdata;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 50), () async {
      user = FirebaseAuth.instance.currentUser;
      userdata = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
    });
  }

  void sendNewMessage() {
    FocusScope.of(context).unfocus();

    _formkey.currentState!.save();
    if (_newMessage != null && _newMessage!.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('chats/wTbrb3MnCRv8A7vGF2pj/${widget.groupName}')
          .add(
        {
          'text': _newMessage,
          'writeTime': Timestamp.now(),
          'username': userdata['username'],
          'avatar': userdata['AvatarUrl'],
          'userid': user!.uid,
        },
      );
    }
    Messagecontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(
              5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: TextFormField(
                    controller: Messagecontroller,
                    decoration: const InputDecoration(
                      hintText: 'new message:',
                    ),
                    onSaved: (newValue) => _newMessage = newValue!,
                  ),
                ),
              ),
              IconButton(
                onPressed: sendNewMessage,
                icon: const Icon(
                  Icons.send,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
