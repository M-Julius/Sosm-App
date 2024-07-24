import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/models/message.dart';
import 'package:social_media_app/screens/chat_screen.dart';

class DirectMessageScreen extends StatefulWidget {
  const DirectMessageScreen({super.key});

  @override
  DirectMessageScreenState createState() => DirectMessageScreenState();
}

class DirectMessageScreenState extends State<DirectMessageScreen> {
  List<String> users = [];
  Map<String, List<Message>> userMessages = {};

  @override
  void initState() {
    super.initState();
    _fetchUsersAndMessages();
  }

  Future<void> _fetchUsersAndMessages() async {
    final currentUser = await DatabaseHelper().getCurrentUser();
    final messages = await DatabaseHelper().getMessages(currentUser!.username);
    Set<String> uniqueUsers = {};
    for (var message in messages) {
      if (message.sender != currentUser.username) {
        uniqueUsers.add(message.sender);
      }
      if (message.receiver != currentUser.username) {
        uniqueUsers.add(message.receiver);
      }
    }
    setState(() {
      users = uniqueUsers.toList();
      for (var user in users) {
        userMessages[user] = messages
            .where((msg) => msg.sender == user || msg.receiver == user)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          final lastMessage = userMessages[user]?.last;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(user[0]),
            ),
            title: Text(user),
            subtitle: Text(lastMessage?.message ?? 'No messages yet'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    chatUser: user,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
