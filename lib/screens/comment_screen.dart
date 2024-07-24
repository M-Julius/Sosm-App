import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/helpers/format_helper.dart';
import 'package:social_media_app/helpers/image.dart';
import 'package:social_media_app/models/comment.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/widgets/post_widget.dart';

class CommentScreen extends StatefulWidget {
  final Post post;

  const CommentScreen({super.key, required this.post});

  @override
  CommentScreenState createState() => CommentScreenState();
}

class CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    final comments = await DatabaseHelper().getComments(widget.post.id!);
    setState(() {
      _comments = comments;
    });
  }

  Future<void> _addComment() async {
    final newComment = Comment(
      postId: widget.post.id!,
      username: widget.post.username,
      text: _commentController.text,
      time: DateTime.now().toString(),
    );
    await DatabaseHelper().insertComment(newComment);
    _commentController.clear();
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return postWidget(widget.post, context, isDetail: true);
                }
                return CommentWidget(comment: _comments[index - 1]);
              },
            ),
          ),

          // Text field for adding a new comment
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),

                // Button to post the comment
                IconButton(
                  onPressed: _addComment,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;

  const CommentWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FutureBuilder<ImageProvider>(
                    future: imageAvatar(comment.username),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error);
                      } else {
                        return CircleAvatar(
                          backgroundImage: snapshot.data,
                          radius: 20,
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    comment.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                formatTimeDifference(comment.time),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(comment.text),
        ],
      ),
    );
  }
}
