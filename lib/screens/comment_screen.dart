import 'package:flutter/material.dart';
import 'package:social_media_app/models/comment.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/widgets/post_widget.dart';

class CommentScreen extends StatelessWidget {
  final Post post;
  final List<Comment> comment = [
    Comment(
        username: 'John Doe',
        text: 'Greats looks like me',
        time: '10 minutes ago'),
    Comment(username: 'Abdul', text: 'Nice post John', time: '1 hours ago'),
    Comment(username: 'Jane', text: 'I want to!', time: '1 hours ago'),
  ];

  CommentScreen({super.key, required this.post});

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
              itemCount: comment.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return postWidget(post, context, isDetail: true);
                }
                return CommentWidget(comment: comment[index - 1]);
              },
            ),
          ),

          // Text field for adding a new comment
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                    ),
                  ),
                ),

                // Button to post the comment
                IconButton(
                  onPressed: () {
                    // show message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Comment posted'),
                      ),
                    );
                  },
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
                  const CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                        'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    comment.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                comment.time,
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
