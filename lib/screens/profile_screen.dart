import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _image != null
                        ? InkWell(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(File(_image!.path)),
                            ),
                          )
                        : InkWell(
                            onTap: _pickImage,
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png'),
                            ),
                          ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.ltr,
                        children: [
                          Text('John Doe', style: TextStyle(fontSize: 24)),
                          Text(
                            '''Helo, I am John Doe, Software Engineer''',
                            style: TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Followers',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '100',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Total Following',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        '150',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
      ),
    );
  }
}
