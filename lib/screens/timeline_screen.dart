import 'package:flutter/material.dart';
import 'package:social_media_app/models/post.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController _textController = TextEditingController();
  bool _isImageSelected = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/default_profile_picture.png'),
                ),
                SizedBox(width: 8),
                Text('Username'),
                Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind?',
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Add image selection logic here
                    setState(() {
                      _isImageSelected = true;
                    });
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Add Image'),
                ),
                if (_isImageSelected)
                  Expanded(
                    child: Image.asset('assets/images/selected_image.png'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.post_add),
                  label: const Text('Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineScreen extends StatelessWidget {
  final List<Post> posts = [
    Post(
        username: 'John Doe',
        profilePicture: 'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
        state: 'Active',
        content: 'This is my first post!',
        // image:
        //     'https://pixnio.com/free-images/2017/10/12/2017-10-12-09-01-56.jpg',
        time: '1 hours'),
    Post(
        username: 'Jane Doe',
        profilePicture: 'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
        state: 'Inactive',
        content: 'This is my second post!',
        time: '7 hours'),
    Post(
        username: 'Bob Smith',
        profilePicture: 'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
        state: 'Active',
        content: 'This is my third post!',
        // image:
        //     'https://pixnio.com/free-images/2017/10/12/2017-10-12-09-01-56.jpg',
        time: '7 hours'),
  ];

  TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length + 1, // Add 1 for the new post card
        itemBuilder: (context, index) {
          if (index == 0) {
            return const PostCard(); // New post card
          } else {
            index--; // Adjust index to match posts list
            return Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage(posts[index].profilePicture),
                        ),
                        const SizedBox(width: 8),
                        Text(posts[index].username),
                        const Spacer(),
                        Text(posts[index].time),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(posts[index].content),
                    if (posts[index].image != null)
                      Image.network(posts[index].image!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Column(
                            children: [
                              Icon(Icons.thumb_up),
                              Text('Like'),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Column(
                            children: [
                              Icon(Icons.comment),
                              Text('Comment'),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Column(
                            children: [
                              Icon(Icons.share),
                              Text('Share'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
