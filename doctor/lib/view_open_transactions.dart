import 'models/transaction.dart';
import 'providers/record_provider.dart';
import 'widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_button.dart';

class ViewOpenTransactions extends StatefulWidget {
  @override
  _ViewOpenTransactionsState createState() => _ViewOpenTransactionsState();
}

class _ViewOpenTransactionsState extends State<ViewOpenTransactions> {
  @override
  Widget build(BuildContext context) {
    bool _isloading = false;

    List<Transaction> transaction = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('Open Transactions'),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : transaction.length <= 0
              ? Center(child: CustomText('You have no open transactions'))
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemBuilder: (ctx, i) => SizedBox(
                    height: 100,
                    child: Card(
                      elevation: 7,
                      child: ListTile(
                        title: CustomText(
                          'Transaction  (${(i + 1).toString()})',
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
                  ),
                  itemCount: transaction.length,
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: transaction.length <= 0
          ? null
          : FloatingActionButton.extended(
              label: CustomText('Confirm add records'),
              icon: Icon(Icons.check),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () async {
                setState(() {
                  _isloading = true;
                });
                try {
                  await Provider.of<RecordsProvider>(context, listen: false)
                      .mine();
                  await Provider.of<RecordsProvider>(context, listen: false)
                      .resolveConflicts();
                  setState(() {
                    _isloading = false;
                  });
                } catch (e) {
                  await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      title: CustomText('Error'),
                      content: CustomText(e.toString()),
                      actions: <Widget>[
                        Center(
                          child: CustomButton(
                            'Ok',
                            () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ).then((value) {
                    setState(() {
                      _isloading = false;
                      Navigator.of(context).pop();
                    });
                  });
                }
              },
            ),
    );
  }
}
