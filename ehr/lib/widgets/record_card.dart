import 'package:ehr/models/block.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_text.dart';
import 'custom_button.dart';

class RecordCard extends StatelessWidget {
  final String index;
  final String timestamp;
  final Block block;
  RecordCard(this.index, this.timestamp, this.block);
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final f = DateFormat('dd-MM-yyyy hh:mm');
    String date = f.format(DateTime.fromMillisecondsSinceEpoch(
        double.parse(timestamp).toInt() * 1000));

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
                  'Date: $date',
                  fontsize: 16,
                ),
                CustomButton(
                  'VIEW RECORD',
                  () => {
                    Navigator.of(context)
                        .pushNamed('view_record', arguments: block)
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
