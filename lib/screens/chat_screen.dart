import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/models/message.dart';
import 'package:social_media_app/helpers/database_helper.dart';

class ChatScreen extends StatefulWidget {
  final String chatUser;

  const ChatScreen({super.key, required this.chatUser});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Message> messages = [];
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final currentUser = await DatabaseHelper().getCurrentUser();

    setState(() {
      _currentUser = currentUser!;
    });
    final fetchedMessages =
        await DatabaseHelper().getMessages(currentUser!.username);
    setState(() {
      messages = fetchedMessages
          .where((msg) =>
              (msg.sender == currentUser.username &&
                  msg.receiver == widget.chatUser) ||
              (msg.sender == widget.chatUser &&
                  msg.receiver == currentUser.username))
          .toList();
    });
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      final newMessage = Message(
        sender: _currentUser.username,
        receiver: widget.chatUser,
        message: messageText,
        timestamp: DateTime.now().toString(),
      );
      await DatabaseHelper().insertMessage(newMessage);
      _messageController.clear();
      _fetchMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.chatUser}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isCurrentUser = message.sender == _currentUser.username;
                return ChatBubble(
                  clipper: ChatBubbleClipper1(
                      type: isCurrentUser
                          ? BubbleType.sendBubble
                          : BubbleType.receiverBubble),
                  alignment:
                      isCurrentUser ? Alignment.topRight : Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20),
                  backGroundColor:
                      isCurrentUser ? Colors.blue : const Color(0xffE7E7ED),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(
                          color: isCurrentUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
