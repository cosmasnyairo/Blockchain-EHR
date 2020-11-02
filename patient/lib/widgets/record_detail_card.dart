import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient/models/transaction.dart';
import 'custom_button.dart';

import 'custom_text.dart';

class RecordDetailCard extends StatelessWidget {
  final List<Transaction> transaction;
  final int index;
  RecordDetailCard(this.transaction, this.index);
  @override
  Widget build(BuildContext context) {
    final f = DateFormat.yMd().add_jm();
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (ctx, i) => Card(
        elevation: 7,
        child: ListTile(
          title: CustomText('Visit $index'),
          subtitle: CustomText(
            'Date: ${f.format(
              transaction[i].timestamp,
            )}',
          ),
          isThreeLine: true,
          trailing: CustomButton(
            'View',
            () {
              Navigator.of(context).pushNamed(
                'visit_detail',
                arguments: transaction[i],
              );
            },
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              'visit_detail',
              arguments: transaction[i],
            );
          },
        ),
      ),
      itemCount: transaction.length,
    );
    // ListView.builder(
    //   itemBuilder: (ctx, i) => Card(
    //     elevation: 7,
    //     child: ListTile(
    //       title: CustomText('Visit $index'),
    //       subtitle: CustomText(
    //         'Date: ${f.format(
    //           block.transaction[i].timestamp,
    //         )}',
    //       ),
    //       trailing: CustomButton(
    //         'View Record',
    //         () {
    //           Navigator.of(context).pushNamed(
    //             'visit_detail',
    //             arguments: block.transaction[i],
    //           );
    //         },
    //       ),
    //       onTap: () {
    //         Navigator.of(context).pushNamed(
    //           'visit_detail',
    //           arguments: block.transaction[i],
    //         );
    //       },
    //     ),
    //   ),
    //   itemCount: block.transaction.length,
    // );
  }
}
