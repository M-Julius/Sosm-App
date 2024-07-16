// db/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/comment.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/models/message.dart';
import 'package:social_media_app/models/group.dart';
import 'package:social_media_app/models/group_message.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'social_media.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT,
        password TEXT,
        profilePicture TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE posts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        profilePicture TEXT,
        state TEXT,
        content TEXT,
        image TEXT,
        time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE comments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        postId INTEGER,
        username TEXT,
        text TEXT,
        time TEXT,
        FOREIGN KEY (postId) REFERENCES posts (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender TEXT,
        receiver TEXT,
        message TEXT,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE groups(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE group_messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        groupId INTEGER,
        sender TEXT,
        message TEXT,
        timestamp TEXT,
        FOREIGN KEY (groupId) REFERENCES groups (id)
      )
    ''');
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Post>> getPostsByUser(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'posts',
      where: 'username = ?',
      whereArgs: [username],
    );

    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  Future<void> insertPost(Post post) async {
    final db = await database;
    await db.insert('posts', post.toMap());
  }

  Future<List<Post>> getPosts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('posts');

    return List.generate(maps.length, (i) {
      return Post.fromMap(maps[i]);
    });
  }

  Future<void> insertComment(Comment comment) async {
    final db = await database;
    await db.insert('comments', comment.toMap());
  }

  Future<List<Comment>> getComments(int postId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'comments',
      where: 'postId = ?',
      whereArgs: [postId],
    );

    return List.generate(maps.length, (i) {
      return Comment.fromMap(maps[i]);
    });
  }

  Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getMessages(String sender, String receiver) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: '(sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)',
      whereArgs: [sender, receiver, receiver, sender],
    );

    return List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });
  }

  Future<void> insertGroup(Group group) async {
    final db = await database;
    await db.insert('groups', group.toMap());
  }

  Future<List<Group>> getGroups() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('groups');

    return List.generate(maps.length, (i) {
      return Group.fromMap(maps[i]);
    });
  }

  Future<void> insertGroupMessage(GroupMessage message) async {
    final db = await database;
    await db.insert('group_messages', message.toMap());
  }

  Future<List<GroupMessage>> getGroupMessages(int groupId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'group_messages',
      where: 'groupId = ?',
      whereArgs: [groupId],
    );

    return List.generate(maps.length, (i) {
      return GroupMessage.fromMap(maps[i]);
    });
  }
}
