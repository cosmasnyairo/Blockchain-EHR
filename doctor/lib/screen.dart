import 'package:flutter/material.dart';

import 'homepage.dart';
import 'profile.dart';
import 'settings.dart';

import 'widgets/custom_text.dart';

class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int _currentindex = 0;

  List<Map<String, Object>> _pages;

  @override
  void initState() {
    _pages = [
      {
        'page': HomePage(),
      },
      {
        'page': ProfilePage(),
      },
      {
        'page': SettingsPage(),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentindex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {});
          _currentindex = index;
        },
        currentIndex: _currentindex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            title: CustomText('Home'),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: CustomText('Profile'),
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            title: CustomText('Settings'),
            icon: Icon(Icons.settings),
          )
        ],
      ),
    );
  }
}
