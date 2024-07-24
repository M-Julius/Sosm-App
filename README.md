# Social Media App

This is a simple social media app built with Flutter and SQLite for local database storage. The project serves as a learning material for using SQLite as a local database in Flutter applications.

## Features

- User registration and login
- Post creation with image upload
- Like and comment functionality on posts
- User profile with the ability to update profile picture and bio
- View and interact with other users' posts
- View list of followers and following users

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine
- A code editor like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)

### Installation

1. Clone the repository

   ```bash
   git clone https://github.com/M-Julius/Sosm-App.git
   cd Sosm-App
   ```
2. Install dependencies

   ```bash
   flutter pub get
   ```

3. Run the app

   ```bash
   flutter run
   ```

### Project Structure
```lib/
├── db/
│   └── database_helper.dart
├── models/
│   ├── comment.dart
│   ├── post.dart
│   └── user.dart
├── screens/
│   ├── chat_screen.dart
│   ├── comment_screen.dart
│   ├── direct_message_screen.dart
│   ├── group_screen.dart
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── profile_screen.dart
│   ├── register_screen.dart
│   ├── timeline_screen.dart
│   ├── update_password_screen.dart
│   ├── update_profile_screen.dart
│   └── user_posts_screen.dart
├── widgets/
│   ├── post_widget.dart
│   └── post_card.dart
└── main.dart
```
