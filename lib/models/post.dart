class Post {
  final String username;
  final String profilePicture;
  final String state;
  final String content;
  final String? image;
  final String time;

  Post({
    required this.username,
    required this.profilePicture,
    required this.state,
    required this.content,
    this.image,
    required this.time,
  });
}
