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
          return ListTile(
            title: Text(groups[index]),
            onTap: () {
              // Navigate to group details screen
            },
          );
        },
      ),
    );
  }
}
