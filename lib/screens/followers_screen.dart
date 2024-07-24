import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/models/user.dart';

class FollowersScreen extends StatefulWidget {
  final int userId;

  const FollowersScreen({super.key, required this.userId});

  @override
  FollowersScreenState createState() => FollowersScreenState();
}

class FollowersScreenState extends State<FollowersScreen> {
  List<User> followers = [];

  @override
  void initState() {
    super.initState();
    _fetchFollowers();
  }

  Future<void> _fetchFollowers() async {
    final fetchedFollowers = await DatabaseHelper().getFollowers(widget.userId);
    setState(() {
      followers = fetchedFollowers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: followers[index].profilePicture != null
                  ? FileImage(File(followers[index].profilePicture!))
                  : const NetworkImage(
                      'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
                    ) as ImageProvider,
            ),
            title: Text(followers[index].username),
            subtitle: Text(followers[index].email),
          );
        },
      ),
    );
  }
}
