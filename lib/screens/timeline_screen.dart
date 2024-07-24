import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/post_card.dart';
import 'package:social_media_app/widgets/post_widget.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  TimelineScreenState createState() => TimelineScreenState();
}

class TimelineScreenState extends State<TimelineScreen> {
  late Future<void> _initialLoad;

  @override
  void initState() {
    super.initState();
    _initialLoad = _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchCurrentUser();
    await _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    final fetchedPosts = await DatabaseHelper().getPosts();
    setState(() {
      posts = fetchedPosts;
    });
  }

  Future<void> _fetchCurrentUser() async {
    final user = await DatabaseHelper().getCurrentUser();
    setState(() {
      currentUser = user!;
    });
  }

  List<Post> posts = [];
  late User currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initialLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: posts.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return PostCard(
                    onPostCreated: _fetchPosts,
                    currentUser: currentUser,
                  );
                  // New post card
                } else {
                  index--; // Adjust index to match posts list
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: postWidget(posts[index], context, isDetail: false),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
