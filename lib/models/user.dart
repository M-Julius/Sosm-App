class User {
  final int? id;
  final String username;
  final String name;
  final String bio;
  final String email;
  final String password;
  final String? profilePicture;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.bio,
    required this.password,
    this.profilePicture,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'bio': bio,
      'password': password,
      'profilePicture': profilePicture,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      name: map['name'],
      bio: map['bio'],
      password: map['password'],
      profilePicture: map['profilePicture'],
    );
  }
}
