import '../models/block.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_text.dart';
import 'custom_button.dart';

class RecordCard extends StatelessWidget {
  final Block block;
  RecordCard(this.block);
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final f = DateFormat.yMd().add_jm();

    final date = DateTime.fromMillisecondsSinceEpoch(
        double.parse(block.timestamp).toInt() * 1000);

    return Container(
      height: deviceheight * 0.10,
      padding: EdgeInsets.all(10),
      child: ListTile(
        title: Row(
          children: [
            Icon(Icons.apps),
            CustomText(
              'EHR Record',
              fontsize: 20,
            ),
          ],
        ),
        subtitle: CustomText(
          f.format(date),
          fontsize: 16,
        ),
        trailing: CustomButton(
          'VIEW RECORD',
          () => {
            Navigator.of(context).pushNamed('view_record', arguments: block)
          },
          elevation: 0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
