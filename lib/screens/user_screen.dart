import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/helpers/image.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/chat_screen.dart';
import 'package:social_media_app/screens/followers_screen.dart';
import 'package:social_media_app/screens/following_screen.dart';
import 'package:social_media_app/widgets/post_widget.dart';

class UserScreen extends StatefulWidget {
  final String username;
  const UserScreen({super.key, required this.username});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  User? user;
  List<Post> posts = [];
  int _followersCount = 0;
  int _followingCount = 0;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserAndPosts();
  }

  Future<void> _fetchUserAndPosts() async {
    final fetchedUser =
        await DatabaseHelper().getUserByUsername(widget.username);
    final currentUser = await DatabaseHelper().getCurrentUser();

    if (fetchedUser != null) {
      final fetchedPosts =
          await DatabaseHelper().getPostsByUser(fetchedUser.username);
      final followers = await DatabaseHelper().getFollowers(fetchedUser.id!);
      final following = await DatabaseHelper().getFollowing(fetchedUser.id!);
      final isFollowing =
          await DatabaseHelper().isFollowing(fetchedUser.id!, currentUser!.id!);

      setState(() {
        user = fetchedUser;
        posts = fetchedPosts;
        _followersCount = followers.length;
        _followingCount = following.length;
        _isFollowing = isFollowing;
      });
    }
  }

  Future<void> _toggleFollow() async {
    if (user != null) {
      final currentUser = await DatabaseHelper().getCurrentUser();
      await DatabaseHelper().toggleFollow(
        currentUser!.id!,
        user!.id!,
      );
      _fetchUserAndPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  FutureBuilder<ImageProvider>(
                    future: imageAvatar(user!.username),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error);
                      } else {
                        return CircleAvatar(
                          backgroundImage: snapshot.data,
                          radius: 50,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.ltr,
                      children: [
                        Text(user!.name, style: const TextStyle(fontSize: 24)),
                        Text(
                          user!.bio,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FollowersScreen(userId: user!.id!),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      const Text(
                        'Total Followers',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '$_followersCount',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FollowingScreen(userId: user!.id!),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      const Text(
                        'Total Following',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '$_followingCount',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: _toggleFollow,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    label: Text(_isFollowing ? 'Unfollow' : 'Follow'),
                    icon: Icon(_isFollowing ? Icons.remove : Icons.add),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatUser: user!.username,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    label: const Text('Message'),
                    icon: const Icon(Icons.messenger_outline),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            ...posts.map((post) => postWidget(post, context, isDetail: true)),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
