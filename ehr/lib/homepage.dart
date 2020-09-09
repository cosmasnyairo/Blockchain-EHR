import 'package:flutter/material.dart';

import 'widgets/custom_button.dart';
import 'widgets/custom_text.dart';
import 'widgets/record.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              'Welcome,',
              color: Colors.black54,
              fontsize: 20,
            ),
            CustomText(
              'Kenneth Erickson',
              fontsize: 20,
              fontweight: FontWeight.bold,
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButton(
                  'ADD RECORD',
                  () {
                    Navigator.of(context).pushNamed('add_record');
                  },
                ),
                CustomButton('SHARE RECORDS', () {})
              ],
            ),
            SizedBox(height: 20),
            CustomText('RECORDS', fontweight: FontWeight.bold),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, i) => RecordCard(i),
                itemCount: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
