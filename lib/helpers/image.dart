import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';

Future<ImageProvider> imageAvatar(String? username) async {
  if (username!.isNotEmpty) {
    final user = await DatabaseHelper().getUserByUsername(username);
    if (user!.profilePicture != null) {
      return FileImage(File(user.profilePicture!));
    } else {
      return const NetworkImage(
          'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png');
    }
  } else {
    return const NetworkImage(
        'https://cdn3.iconfinder.com/data/icons/vector-icons-6/96/256-1024.png');
  }
}
