import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/widgets/post_widget.dart';

class UserPostsScreen extends StatefulWidget {
  const UserPostsScreen({super.key});

  @override
  UserPostsScreenState createState() => UserPostsScreenState();
}

class UserPostsScreenState extends State<UserPostsScreen> {
  late Future<User?> _currentUserFuture;
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    _currentUserFuture = _fetchCurrentUser();
  }

  Future<User?> _fetchCurrentUser() async {
    final user = await DatabaseHelper().getCurrentUser();
    if (user != null) {
      final fetchedPosts = await DatabaseHelper().getPostsByUser(user.username);
      setState(() {
        posts = fetchedPosts;
      });
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
      ),
      body: FutureBuilder<User?>(
        future: _currentUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: postWidget(posts[index], context, isDetail: false),
                );
              },
            );
          }
        },
      ),
    );
  }
}
