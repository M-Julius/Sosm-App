import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/helpers/image.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/update_password_screen.dart';
import 'package:social_media_app/screens/update_profile_screen.dart';
import 'package:social_media_app/screens/user_posts_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _image;
  late Future<void> _initialLoad;

  int _followersCount = 0;
  int _followingCount = 0;
  User? _user;

  @override
  void initState() {
    super.initState();
    _initialLoad = _fetchData();
  }

  Future<void> _fetchData() async {
    _user = await DatabaseHelper().getCurrentUser();
    final followers = await DatabaseHelper().getFollowers(_user!.id!);
    final following = await DatabaseHelper().getFollowing(_user!.id!);
    setState(() {
      _followersCount = followers.length;
      _followingCount = following.length;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    if (_image != null) {
      _updateProfilePicture();
    }
  }

  Future<void> _updateProfilePicture() async {
    final updatedUser = User(
      id: _user!.id,
      username: _user!.username,
      name: _user!.name,
      bio: _user!.bio,
      email: _user!.email,
      password: _user!.password,
      profilePicture: _image!.path,
    );
    await DatabaseHelper().updateUser(updatedUser);
    setState(() {
      _user = updatedUser;
    });
  }

  Future<void> _navigateToUpdateProfile() async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfileScreen(currentUser: _user!),
      ),
    );
    if (updatedUser != null) {
      setState(() {
        _user = updatedUser;
      });
    }
  }

  Future<void> _navigateToUpdatePassword() async {
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UpdatePasswordScreen(),
      ),
    );
    if (updatedUser != null) {
      setState(() {
        _user = updatedUser;
      });
    }
  }

  Future<void> _navigateToUserPosts() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserPostsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initialLoad,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: _pickImage,
                            child: FutureBuilder<ImageProvider>(
                              future: imageAvatar(_user!.username),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Icon(Icons.error);
                                } else {
                                  return CircleAvatar(
                                    backgroundImage: snapshot.data,
                                    radius: 50,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _user!.name,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                Text(
                                  _user!.bio,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _navigateToUpdateProfile,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Total Followers',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '$_followersCount',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              'Total Following',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '$_followingCount',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _navigateToUserPosts,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.post_add),
                                SizedBox(width: 10),
                                Text('Posted'),
                              ],
                            ),
                            Icon(Icons.arrow_right, size: 30),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _navigateToUpdatePassword,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.account_box),
                                SizedBox(width: 10),
                                Text('Account'),
                              ],
                            ),
                            Icon(Icons.arrow_right, size: 30),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.settings),
                              SizedBox(width: 10),
                              Text('Setting'),
                            ],
                          ),
                          Icon(Icons.arrow_right, size: 30),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/', (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          maximumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text('Logout'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
