import 'package:flutter/material.dart';

import 'models/block.dart';
import 'widgets/custom_text.dart';

class ViewRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Block block = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('EHR RECORD'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemBuilder: (ctx, i) => SizedBox(
            height: 100,
            child: Card(
              elevation: 7,
              child: ListTile(
                title: CustomText(
                  'Transaction',
                  fontweight: FontWeight.bold,
                  fontsize: 16,
                ),
                subtitle: CustomText('View this transaction'),
                contentPadding: EdgeInsets.all(10),
                trailing: IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Theme.of(context).primaryColor,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      'view_transaction',
                      arguments: block.transaction[i],
                    );
                  },
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    'view_transaction',
                    arguments: block.transaction[i],
                  );
                },
              ),
            ),
          ),
          // ViewTransaction(
          //   index: block.index,
          //   transaction: block.transaction[i],
          // ),
          itemCount: block.transaction.length,
        ),
      ),
    );
  }
}
