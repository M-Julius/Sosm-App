class GroupMessage {
  final int? id;
  final int groupId;
  final String sender;
  final String message;
  final String timestamp;

  GroupMessage({
    this.id,
    required this.groupId,
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'sender': sender,
      'message': message,
      'timestamp': timestamp,
    };
  }

  static GroupMessage fromMap(Map<String, dynamic> map) {
    return GroupMessage(
      id: map['id'],
      groupId: map['groupId'],
      sender: map['sender'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
