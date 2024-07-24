import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/helpers/image.dart';
import 'package:social_media_app/models/user.dart';

class UpdateProfileScreen extends StatefulWidget {
  final User currentUser;

  const UpdateProfileScreen({super.key, required this.currentUser});

  @override
  UpdateProfileScreenState createState() => UpdateProfileScreenState();
}

class UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  XFile? _image;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.currentUser;
    _usernameController.text = _user.username;
    _nameController.text = _user.name;
    _bioController.text = _user.bio;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> _updateProfile() async {
    final updatedUser = User(
      id: _user.id,
      username: _usernameController.text,
      name: _nameController.text,
      bio: _bioController.text,
      email: _user.email,
      password: _user.password,
      profilePicture: _image?.path ?? _user.profilePicture,
    );
    await DatabaseHelper().updateUser(updatedUser);
    Navigator.pop(context, updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                onTap: _pickImage,
                child: FutureBuilder<ImageProvider>(
                  future: imageAvatar(_user.username),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  maximumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
