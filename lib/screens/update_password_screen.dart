import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/models/user.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  UpdatePasswordScreenState createState() => UpdatePasswordScreenState();
}

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late Future<User?> _currentUserFuture;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUserFuture = _fetchCurrentUser();
  }

  Future<User?> _fetchCurrentUser() async {
    final user = await DatabaseHelper().getCurrentUser();
    setState(() {
      _currentUser = user;
    });
    return user;
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text == _confirmPasswordController.text) {
        final updatedUser = User(
          id: _currentUser!.id,
          username: _currentUser!.username,
          name: _currentUser!.name,
          bio: _currentUser!.bio,
          email: _currentUser!.email,
          password: _newPasswordController.text,
          profilePicture: _currentUser!.profilePicture,
        );
        await DatabaseHelper().updateUser(updatedUser);
        Navigator.pop(context, updatedUser);
      } else {
        // Show error if passwords do not match
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New passwords do not match')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Password'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<User?>(
          future: _currentUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final currentUser = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _oldPasswordController,
                        decoration:
                            const InputDecoration(labelText: 'Old Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your old password';
                          }
                          if (value != currentUser!.password) {
                            return 'Incorrect old password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _newPasswordController,
                        decoration:
                            const InputDecoration(labelText: 'New Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updatePassword,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          maximumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text('Update Password'),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
