import 'package:flutter/material.dart';

class GroupScreen extends StatelessWidget {
  final List<String> groups = ['Group 1', 'Group 2', 'Group 3'];

  GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.group, color: Colors.white),
              ),
              title: Text(groups[index]),
              subtitle: Text('${groups.length} members'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to group details screen
              },
            ),
          );
        },
      ),
    );
  }
}
