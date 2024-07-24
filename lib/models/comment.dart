class Comment {
  final int? id;
  final int postId;
  final String username;
  final String text;
  final String time;

  Comment({
    this.id,
    required this.postId,
    required this.username,
    required this.text,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'username': username,
      'text': text,
      'time': time,
    };
  }

  static Comment fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      postId: map['postId'],
      username: map['username'],
      text: map['text'],
      time: map['time'],
    );
  }
}
