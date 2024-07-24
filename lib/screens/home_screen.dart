import 'package:flutter/material.dart';
import 'package:social_media_app/helpers/database_helper.dart';
import 'package:social_media_app/models/user.dart';
import 'package:social_media_app/screens/profile_screen.dart';
import 'package:social_media_app/screens/direct_message_screen.dart';
import 'package:social_media_app/screens/group_screen.dart';
import 'package:social_media_app/screens/timeline_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  User? currentUser;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _getCurrentUser() async {
    currentUser = await DatabaseHelper().getCurrentUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (currentUser == null) {
          return const Scaffold(
            body: Center(child: Text('User not found')),
          );
        } else {
          _widgetOptions = <Widget>[
            const TimelineScreen(),
            const GroupScreen(),
            const DirectMessageScreen(),
            const ProfileScreen(),
          ];
          return Scaffold(
            appBar: AppBar(
              title: const Text('Sosm App'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Groups',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
            ),
          );
        }
      },
    );
  }
}
