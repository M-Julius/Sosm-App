import 'package:flutter/material.dart';
import 'chat_screen.dart';

class DirectMessageScreen extends StatelessWidget {
  
final List<String> users = ['John Doe', 'Jane Doe', 'Michael Doe'];

  DirectMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(users[index][0]),
            ),
            title: Text(users[index]),
            subtitle: const Text('Last message'),
            trailing: const Icon(Icons.chevron_right),
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
