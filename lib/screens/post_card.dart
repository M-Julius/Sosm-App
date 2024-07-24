import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/helpers/image.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/user.dart';

class PostCard extends StatefulWidget {
  final VoidCallback onPostCreated;
  final User? currentUser;

  const PostCard(
      {super.key, required this.onPostCreated, required this.currentUser});

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

  Future<void> _createPost() async {
    if (widget.currentUser == null) return;

    final newPost = Post(
      username: widget.currentUser!.username,
      profilePicture: '',
      state: 'Active',
      content: _textController.text,
      image: _image?.path,
      time: DateTime.now().toString(),
    );

    print(newPost);
    await DatabaseHelper().insertPost(newPost);
    widget.onPostCreated();
    _textController.clear();
    setState(() {
      _image = null;
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
            Row(
              children: [
                FutureBuilder<ImageProvider>(
                  future: imageAvatar(widget.currentUser!.username),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Icon(Icons.person);
                    } else {
                      return CircleAvatar(
                        backgroundImage: snapshot.data,
                        radius: 20,
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                Text(widget.currentUser?.username ?? 'Unknown User'),
              ],
            ),
            _image != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.file(File(_image!.path)),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 8),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'What\'s on your mind?',
                suffixIcon: InkWell(
                  onTap: _pickImage,
                  child: const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _createPost,
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
