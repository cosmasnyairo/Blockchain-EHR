import '../models/block.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'custom_text.dart';
import 'custom_button.dart';

class RecordCard extends StatelessWidget {
  final String index;
  final String publicKey;
  final String timestamp;
  final Block block;
  RecordCard(this.index, this.publicKey, this.timestamp, this.block);
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final f = DateFormat('dd-MM-yyyy hh:mm');
    String date = f.format(DateTime.fromMillisecondsSinceEpoch(
        double.parse(timestamp).toInt() * 1000));

    return Container(
      height: deviceheight * 0.16,
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        elevation: 7,
        child: Center(
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
            isThreeLine: true,
            subtitle: CustomText(
              'Date: $date',
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
        ),
      ),
    );
  }
}
