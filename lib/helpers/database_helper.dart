// db/database_helper.dart
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE likes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          postId INTEGER,
          userId INTEGER,
          FOREIGN KEY(postId) REFERENCES posts(id),
          FOREIGN KEY(userId) REFERENCES users(id)
        )
      ''');
    }
    if (oldVersion < 4) {
      await _migratePostsTable(db);
    }
  }

  Future<void> _migratePostsTable(Database db) async {
    // Create a temporary table with the new schema
    await db.execute('''
      CREATE TABLE posts_temp(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        profilePicture TEXT, -- Allow NULL values
        state TEXT,
        content TEXT,
        image TEXT,
        time TEXT,
        likeCount INTEGER DEFAULT 0
      )
    ''');

    // Copy data from the old table to the new table
    await db.execute('''
      INSERT INTO posts_temp (id, username, profilePicture, state, content, image, time, likeCount)
      SELECT id, username, profilePicture, state, content, image, time, likeCount
      FROM posts
    ''');

    // Drop the old table
    await db.execute('DROP TABLE posts');

    // Rename the new table to the old table name
    await db.execute('ALTER TABLE posts_temp RENAME TO posts');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'social_media_app.db');

    return await openDatabase(
      path,
      version: 4, // Increment version number
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        email TEXT,
        name TEXT,
        bio TEXT,
        password TEXT,
        profilePicture TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE posts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        profilePicture TEXT, -- Allow NULL values
        state TEXT,
        content TEXT,
        image TEXT,
        time TEXT,
        isLiked INTEGER DEFAULT 0,
        likeCount INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE likes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        postId INTEGER,
        userId INTEGER,
        FOREIGN KEY(postId) REFERENCES posts(id),
        FOREIGN KEY(userId) REFERENCES users(id)
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

    await db.execute('''
      CREATE TABLE followers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        followerId INTEGER,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (followerId) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE following(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        followingId INTEGER,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (followingId) REFERENCES users (id)
      )
    ''');
  }

  Future<void> onDeleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final pathDB = join(databasesPath, 'social_media_app.db');
    await deleteDatabase(pathDB);
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('currentUserEmail');
    if (email!.isNotEmpty) {
      return await getUserByEmail(email);
    }
    return null;
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

  Future<User?> getUserById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
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

  Future<void> likePost(int postId) async {
    final db = await database;
    final currentUser = await getCurrentUser();
    await db.insert('likes', {'postId': postId, 'userId': currentUser!.id});
    await db.rawUpdate(
        'UPDATE posts SET likeCount = likeCount + 1 WHERE id = ?', [postId]);
    await isPostLikedByCurrentUser(postId);
  }

  Future<void> unlikePost(int postId) async {
    final db = await database;
    final currentUser = await getCurrentUser();
    await db.delete('likes',
        where: 'postId = ? AND userId = ?',
        whereArgs: [postId, currentUser!.id]);
    await db.rawUpdate(
        'UPDATE posts SET likeCount = likeCount - 1 WHERE id = ?', [postId]);
    await isPostLikedByCurrentUser(postId);
  }

  Future<bool> isPostLikedByCurrentUser(int postId) async {
    final db = await database;
    final currentUser = await getCurrentUser();
    if (currentUser == null) {
      return false;
    }
    final result = await db.query('likes',
        where: 'postId = ? AND userId = ?',
        whereArgs: [postId, currentUser.id]);
    return result.isNotEmpty;
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

  Future<List<Message>> getMessages(String currentUser) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'sender = ? OR receiver = ?',
      whereArgs: [currentUser, currentUser],
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

  // Follower/Following-related operations...
  Future<void> followUser(int userId, int followerId) async {
    final db = await database;
    await db.insert('followers', {'userId': userId, 'followerId': followerId});
  }

  Future<void> unfollowUser(int userId, int followerId) async {
    final db = await database;
    await db.delete('followers',
        where: 'userId = ? AND followerId = ?',
        whereArgs: [userId, followerId]);
  }

  Future<List<User>> getFollowers(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM users
      WHERE id IN (SELECT followerId FROM followers WHERE userId = ?)
    ''', [userId]);

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<List<User>> getFollowing(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM users
      WHERE id IN (SELECT followingId FROM following WHERE userId = ?)
    ''', [userId]);

    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<bool> isFollowing(int userId, int followingId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'following',
      where: 'userId = ? AND followingId = ?',
      whereArgs: [userId, followingId],
    );
    return maps.isNotEmpty;
  }

  Future<void> toggleFollow(int userId, int followingId) async {
    final db = await database;
    if (await isFollowing(userId, followingId)) {
      await db.delete(
        'following',
        where: 'userId = ? AND followingId = ?',
        whereArgs: [userId, followingId],
      );
      await db.delete(
        'followers',
        where: 'userId = ? AND followerId = ?',
        whereArgs: [followingId, userId],
      );
    } else {
      await db
          .insert('following', {'userId': userId, 'followingId': followingId});
      await db
          .insert('followers', {'userId': followingId, 'followerId': userId});
    }
  }
}
