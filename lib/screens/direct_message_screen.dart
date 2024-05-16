import 'package:flutter/material.dart';
import 'chat_screen.dart';

class DirectMessageScreen extends StatelessWidget {
  final List<String> users = ['User 1', 'User 2', 'User 3'];

  DirectMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(username: users[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
