import 'package:flutter/material.dart';

class TimelineScreen extends StatelessWidget {
  final List<String> posts = ['Post 1', 'Post 2', 'Post 3'];

  TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(posts[index], style: const TextStyle(fontSize: 18)),
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
        },
      ),
    );
  }
}
