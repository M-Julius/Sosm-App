import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/widgets/post_widget.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key});
  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final TextEditingController _textController = TextEditingController();
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

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
                  backgroundImage: NetworkImage(
                      'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png'),
                ),
                SizedBox(width: 8),
                Text('John Doe'),
                // Spacer(),
              ],
            ),
            _image != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: Image.file(File(_image!.path))),
                  )
                : const SizedBox(),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  suffixIcon: InkWell(
                      onTap: _pickImage, child: const Icon(Icons.image))),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post created'),
                      ),
                    );
                    setState(() {
                      _textController.clear();
                      _image = null;
                    });
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Post'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
        profilePicture:
            'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
        state: 'Active',
        content: 'This is my first post!',
        image:
            'https://contentoo.com/wp-content/uploads/2023/04/Content-creation-V1-e1680617593807.png',
        time: '1 hours'),
    Post(
        username: 'Jane Doe',
        profilePicture:
            'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
        state: 'Inactive',
        content: 'This is my second post!',
        time: '7 hours'),
    Post(
        username: 'Bob Smith',
        profilePicture:
            'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png',
        state: 'Active',
        content: 'This is my third post!',
        image:
            'https://contentoo.com/wp-content/uploads/2023/04/Content-creation-V1-e1680617593807.png',
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
              child: postWidget(posts[index], context, isDetail: false),
            );
          }
        },
      ),
    );
  }
}
