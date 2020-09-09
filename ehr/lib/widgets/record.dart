import 'package:flutter/material.dart';

import 'custom_text.dart';
import 'custom_button.dart';

class RecordCard extends StatelessWidget {
  final int index;
  RecordCard(this.index);
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.2,
      width: w,
      padding: EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.apps),
                CustomText(
                  'EHR Record',
                  fontsize: 20,
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  'Date: 17/07/2017',
                  fontsize: 16,
                ),
                CustomButton(
                  'VIEW RECORD',
                  () => {
                    Navigator.of(context)
                        .pushNamed('view_record', arguments: index)
                  },
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
