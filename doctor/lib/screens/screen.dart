import 'package:flutter/material.dart';

import '../widgets/custom_text.dart';
import 'add_visit.dart';
import 'homepage.dart';
import 'profile.dart';

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
        'page': AddVisit(),
      },
      {
        'page': ProfilePage(),
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
            title: CustomText('Add visit'),
            icon: Icon(Icons.people),
          ),
          BottomNavigationBarItem(
            title: CustomText('Profile'),
            icon: Icon(Icons.person),
          )
        ],
      ),
    );
  }
}
