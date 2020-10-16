import 'package:flutter/material.dart';

import 'widgets/custom_text.dart';
import 'models/node.dart';

class AddVisit extends StatefulWidget {
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  @override
  Widget build(BuildContext context) {
    List<Node> _nodes = ModalRoute.of(context).settings.arguments;
    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('Add Visit'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: deviceheight,
        padding: EdgeInsets.all(20),
        child: Center(
          child: FloatingActionButton.extended(
            onPressed: () {
              print('pressed');
            },
            backgroundColor: Theme.of(context).primaryColor,
            label: CustomText('Scan QR Code'),
            icon: Icon(Icons.filter_center_focus),
          ),
        ),
      ),
    );
  }
}
