
import 'package:flutter/material.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';

class CustomMessagesPage extends StatefulWidget {
  const CustomMessagesPage(this.conversation, {super.key});

  final ChatConversation conversation;

  @override
  State<CustomMessagesPage> createState() => _CustomMessagesPageState();
}

class _CustomMessagesPageState extends State<CustomMessagesPage> {
  late final ChatMessageListController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatMessageListController(widget.conversation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.id),
        actions: [
          UnconstrainedBox(
            child: InkWell(
              onTap: () {
                controller.deleteAllMessages();
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Delete',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ChatMessagesView(
          messageListViewController: controller,
          conversation: widget.conversation,
          onError: (error) {
            showSnackBar('error: ${error.description}');
          },
          itemBuilder: (context, model) {
            return null;
          },
          onTap: (context, message) {
            bool hold = false;
            return hold;
          },
        ),
      ),
    );
  }

  void showSnackBar(String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
