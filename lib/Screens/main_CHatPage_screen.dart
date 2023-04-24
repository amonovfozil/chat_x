// ignore_for_file: file_names

import 'package:chat_x/Widgets/group_list.dart';
import 'package:chat_x/Widgets/sidebar.dart';
import 'package:flutter/material.dart';

class MainChatPageScreen extends StatelessWidget {
  const MainChatPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: const Text(
          'Chat X',
        ),
        centerTitle: true,
        actions: const [],
      ),
      drawer: const SideBar(),
      body: const GroupList(true),
    );
  }
}
