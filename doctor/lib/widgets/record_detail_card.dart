import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/block.dart';
import 'custom_button.dart';

import 'custom_text.dart';

class RecordDetailCard extends StatelessWidget {
  final Block block;
  RecordDetailCard(this.block);
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final f = DateFormat.yMd().add_jm();
    return Container(
      padding: EdgeInsets.all(10),
      height: deviceheight * 0.15,
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (ctx, i) => Card(
          elevation: 7,
          child: ListTile(
            title: CustomText('View record'),
            subtitle: CustomText(
              'Date: ${f.format(
                block.transaction[i].timestamp,
              )}',
            ),
            trailing: CustomButton(
              'View Record',
              () {
                Navigator.of(context).pushNamed(
                  'visit_detail',
                  arguments: block.transaction[i],
                );
              },
            ),
            onTap: () {
              Navigator.of(context).pushNamed(
                'visit_detail',
                arguments: block.transaction[i],
              );
            },
          ),
        ),
        itemCount: block.transaction.length,
      ),
    );
  }
}
