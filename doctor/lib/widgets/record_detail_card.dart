import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../visit_details.dart';
import 'custom_button.dart';

import 'custom_text.dart';
import '../models/transaction.dart';

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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VisitDetails(
                    transaction[i],
                  ),
                ),
              );
            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VisitDetails(
                  transaction[i],
                ),
              ),
            );
          },
        ),
      ),
      itemCount: transaction.length,
    );
  }
}
