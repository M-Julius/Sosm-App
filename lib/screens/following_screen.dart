import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/models/user.dart';

class FollowingScreen extends StatefulWidget {
  final int userId;

  const FollowingScreen({super.key, required this.userId});

  @override
  FollowingScreenState createState() => FollowingScreenState();
}

class FollowingScreenState extends State<FollowingScreen> {
  List<User> following = [];

  @override
  void initState() {
    super.initState();
    _fetchFollowing();
  }

  Future<void> _fetchFollowing() async {
    final fetchedFollowing = await DatabaseHelper().getFollowing(widget.userId);
    setState(() {
      following = fetchedFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: ListView.builder(
        itemCount: following.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: following[index].profilePicture != null
                  ? FileImage(File(following[index].profilePicture!))
                  : const NetworkImage(
                      'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
                    ) as ImageProvider,
            ),
            title: Text(following[index].username),
            subtitle: Text(following[index].email),
          );
        },
      ),
    );
  }
}
