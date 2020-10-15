import 'widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'widgets/custom_text.dart';
import 'models/node.dart';
import 'widgets/dismissible_node.dart';

class ShareRecord extends StatefulWidget {
  @override
  _ShareRecordState createState() => _ShareRecordState();
}

class _ShareRecordState extends State<ShareRecord> {
  @override
  Widget build(BuildContext context) {
    List<Node> _nodes = ModalRoute.of(context).settings.arguments;
    final _formkey = GlobalKey<FormState>();
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('SHARE EHR RECORD'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: height,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              'Add a new node to share files to:',
              fontsize: 16,
            ),
            SizedBox(height: 10),
            Container(
              height: height * 0.18,
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomButton(
                        'Add node',
                        () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.black54,
            ),
            SizedBox(height: 10),
            CustomText(
              'Available nodes you can share files to:',
              fontsize: 16,
            ),
            CustomText(
              'Swipe right on a node to delete a node',
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (ctx, i) => SizedBox(height: 10),
                itemBuilder: (ctx, i) => DismissibleNode(
                  node: _nodes[i],
                  id: i.toString(),
                ),
                itemCount: _nodes.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
