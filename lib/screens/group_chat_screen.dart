import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/helpers/image.dart';
import 'package:social_media_app/models/group_message.dart';
import 'package:social_media_app/models/user.dart';

class GroupChatScreen extends StatefulWidget {
  final int groupId;
  final String groupName;

  const GroupChatScreen(
      {super.key, required this.groupId, required this.groupName});

  @override
  GroupChatScreenState createState() => GroupChatScreenState();
}

class GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<GroupMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    final messages = await DatabaseHelper().getGroupMessages(widget.groupId);
    setState(() {
      _messages = messages;
    });
  }

  Future<User?> _getUser() async {
    final user = await DatabaseHelper().getCurrentUser();
    return user;
  }

  Future<void> _sendMessage() async {
    final currentUser = await _getUser();
    final message = GroupMessage(
      groupId: widget.groupId,
      sender: currentUser!.username,
      message: _messageController.text,
      timestamp: DateTime.now().toString(),
    );
    await DatabaseHelper().insertGroupMessage(message);
    _messageController.clear();
    _fetchMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group ${widget.groupName}'),
      ),
      body: Column(
        children: [
          FutureBuilder<User?>(
              future: _getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final user = snapshot.data;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isSentByMe = message.sender == user!.username;
                        return Align(
                          alignment: isSentByMe
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: ChatBubble(
                            clipper: ChatBubbleClipper1(
                                type: isSentByMe
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble),
                            alignment: isSentByMe
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            margin: const EdgeInsets.only(top: 20),
                            backGroundColor: isSentByMe
                                ? Colors.blue
                                : const Color(0xffE7E7ED),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FutureBuilder(
                                          future: imageAvatar(message.sender),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return const Icon(Icons.person);
                                            } else {
                                              return CircleAvatar(
                                                backgroundImage: snapshot.data,
                                                radius: 10,
                                              );
                                            }
                                          }),
                                      const SizedBox(width: 8),
                                      Text(
                                        message.sender,
                                        style: TextStyle(
                                            color: isSentByMe
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    message.message,
                                    style: TextStyle(
                                        color: isSentByMe
                                            ? Colors.white
                                            : Colors.black),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
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
