import 'package:ehr/add_record.dart';
import 'package:flutter/material.dart';

import 'screen.dart';
import 'view_record.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff3FD5AE),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Screen(),
      routes: {
        'view_record': (ctx) => ViewRecord(),
        'add_record': (ctx) => AddRecord(),
      },
    );
  }
}
