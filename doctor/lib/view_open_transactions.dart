import 'models/transaction.dart';
import 'providers/record_provider.dart';
import 'widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_button.dart';
import 'widgets/custom_text.dart';

class ViewOpenTransactions extends StatefulWidget {
  bool _isloading = false;
  @override
  _ViewOpenTransactionsState createState() => _ViewOpenTransactionsState();
}

class _ViewOpenTransactionsState extends State<ViewOpenTransactions> {
  @override
  Widget build(BuildContext context) {
    List<Transaction> transaction = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('Open Transactions'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: widget._isloading
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
                              'view_transaction',
                              arguments: transaction[i],
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            'view_transaction',
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
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  isExtended: true,
                  heroTag: null,
                  label: CustomText('Resolve conflicts'),
                  icon: Icon(Icons.error),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    setState(() {
                      widget._isloading = true;
                    });
                    try {
                      await Provider.of<RecordsProvider>(context, listen: false)
                          .resolveConflicts();
                      setState(() {
                        widget._isloading = false;
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
                          widget._isloading = false;
                        });
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                FloatingActionButton.extended(
                  label: CustomText('Confirm add records'),
                  icon: Icon(Icons.check),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    setState(() {
                      widget._isloading = true;
                    });
                    try {
                      await Provider.of<RecordsProvider>(context, listen: false)
                          .mine();
                      setState(() {
                        widget._isloading = false;
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
                          widget._isloading = false;
                          Navigator.of(context).pop();
                        });
                      });
                    }
                  },
                ),
              ],
            ),
    );
  }
}
