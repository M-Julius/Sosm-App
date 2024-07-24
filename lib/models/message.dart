class Message {
  final int? id;
  final String sender;
  final String receiver;
  final String message;
  final String timestamp;

  Message({
    this.id,
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp,
    };
  }

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      sender: map['sender'],
      receiver: map['receiver'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
