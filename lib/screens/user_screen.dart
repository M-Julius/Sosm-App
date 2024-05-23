import 'package:flutter/material.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/widgets/post_widget.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final List<Post> posts = [
    Post(
        username: 'John Doe',
        profilePicture:
            'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
        state: 'Active',
        content: 'This is my first post!',
        image:
            'https://contentoo.com/wp-content/uploads/2023/04/Content-creation-V1-e1680617593807.png',
        time: '1 hours'),
    Post(
        username: 'John Doe',
        profilePicture:
            'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
        state: 'Inactive',
        content: 'This is my second post!',
        time: '7 hours'),
    Post(
        username: 'John Doe',
        profilePicture:
            'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
        state: 'Active',
        content: 'This is my third post!',
        image:
            'https://contentoo.com/wp-content/uploads/2023/04/Content-creation-V1-e1680617593807.png',
        time: '7 hours'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png'),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.ltr,
                      children: [
                        Text('John Doe', style: TextStyle(fontSize: 24)),
                        Text(
                          '''Helo, I am John Doe, Software Engineer''',
                          style: TextStyle(fontSize: 16),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Total Followers',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '100',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Total Following',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '150',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  maximumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                label: const Text('Follow'),
                icon: const Icon(Icons.add),
              ),
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
