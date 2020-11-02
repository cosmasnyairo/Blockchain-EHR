import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'widgets/record_detail_card.dart';

import 'models/block.dart';
import 'widgets/custom_text.dart';

class RecordsDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final List<Block> blocks = ModalRoute.of(context).settings.arguments;

    final List<List<Transaction>> fetchedtransaction = [];

    for (Block block in blocks) {
      fetchedtransaction.add(block.transaction);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('EHR Visits'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: deviceheight,
        padding: EdgeInsets.all(20),
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (ctx, i) => RecordDetailCard(fetchedtransaction[i], i),
          itemCount: fetchedtransaction.length,
        ),
      ),
    );
  }
}
