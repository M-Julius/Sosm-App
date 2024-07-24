import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/helpers/format_helper.dart';
import 'package:social_media_app/helpers/image.dart';
import 'package:social_media_app/models/comment.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/screens/comment_screen.dart';
import 'package:social_media_app/screens/user_screen.dart';
import 'package:share_plus/share_plus.dart';

Widget postWidget(Post post, BuildContext context, {bool isDetail = false}) {
  return FutureBuilder<bool>(
      future: DatabaseHelper().isPostLikedByCurrentUser(post.id!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        bool isLiked = snapshot.data!;
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
                          builder: (context) =>
                              UserScreen(username: post.username),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        FutureBuilder<ImageProvider>(
                          future: imageAvatar(post.username),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                        Text(post.username),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(formatTimeDifference(post.time)),
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
                    child: Image.file(File(post.image!)),
                  ),
                ),
              const SizedBox(height: 10),
              !isDetail
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            final isLikedPost = await DatabaseHelper()
                                .isPostLikedByCurrentUser(post.id!);
                            if (isLikedPost) {
                              await DatabaseHelper().unlikePost(post.id!);
                              post.likeCount--;
                            } else {
                              await DatabaseHelper().likePost(post.id!);
                              post.likeCount++;
                            }
                            (context as Element)
                                .markNeedsBuild(); // Update the UI
                          },
                          icon: Icon(
                            isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                            color: isLiked ? Colors.blue : Colors.grey,
                          ),
                          label: Text('${post.likeCount}'),
                        ),
                        TextButton.icon(
                          icon: const Icon(
                            Icons.comment,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            // goto to comment screen with material route
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentScreen(post: post),
                              ),
                            );
                          },
                          label: FutureBuilder<List<Comment>>(
                              future: DatabaseHelper().getComments(post.id!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Loading...');
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return Text('${snapshot.data!.length}');
                                }
                              }),
                        ),
                        TextButton(
                          onPressed: () {
                            Share.share(post.content,
                                subject: 'Look what I made!');
                          },
                          child: const Icon(
                            Icons.share,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          ),
        );
      });
}
