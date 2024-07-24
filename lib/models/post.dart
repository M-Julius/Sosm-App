class Post {
  final int? id;
  final String username;
  final String profilePicture;
  final String state;
  final String content;
  final String? image;
  final String time;
  int likeCount;

  Post({
    this.id,
    required this.username,
    required this.profilePicture,
    required this.state,
    required this.content,
    this.image,
    required this.time,
    this.likeCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'profilePicture': profilePicture,
      'state': state,
      'content': content,
      'image': image,
      'time': time,
      'likeCount': likeCount,
    };
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      username: map['username'],
      profilePicture: map['profilePicture'],
      state: map['state'],
      content: map['content'],
      image: map['image'],
      time: map['time'],
      likeCount: map['likeCount'],
    );
  }
}
