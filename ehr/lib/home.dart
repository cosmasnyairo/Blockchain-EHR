import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EHR'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Homepage of app'),
      ),
    );
  }
}
