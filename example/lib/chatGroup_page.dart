import 'package:flutter/material.dart';

class ChatGroupPage extends StatelessWidget {
  final String groupId;

  const ChatGroupPage({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat del Grupo $groupId'),
      ),
      body: Center(
        child: Text('Aquí va el chat del grupo $groupId'),
      ),
    );
  }
}
