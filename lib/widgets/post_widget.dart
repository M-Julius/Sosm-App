import 'package:flutter/material.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/screens/comment_screen.dart';
import 'package:social_media_app/screens/user_screen.dart';

Widget postWidget(Post post, BuildContext context, {bool isDetail = false}) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                // go to user screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(post.profilePicture),
                  ),
                  const SizedBox(width: 8),
                  Text(post.username),
                ],
              ),
            ),
            const Spacer(),
            Text(post.time),
          ],
        ),
        const SizedBox(height: 8),
        Text(post.content),
        if (post.image != null)
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(post.image!),
            ),
          ),
        const SizedBox(height: 10),
        !isDetail
            ? Row(
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
                    onPressed: () {
                      // goto to comment screen with material route
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentScreen(post: post),
                        ),
                      );
                    },
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
              )
            : const SizedBox(),
      ],
    ),
  );
}
