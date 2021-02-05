import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/record_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_text.dart';
import 'visit_details.dart';

class ViewOpenTransactions extends StatefulWidget {
  @override
  _ViewOpenTransactionsState createState() => _ViewOpenTransactionsState();
}

class _ViewOpenTransactionsState extends State<ViewOpenTransactions> {
  var _isloading = false;
  Future<void> minerecords() async {
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    try {
      setState(() {
        _isloading = !_isloading;
      });
      await provider.mine(provider.peernode).then(
            (value) => {
              setState(() {
                _isloading = false;
              })
            },
          );
      Navigator.of(context).pop('Mined Records to blockchain');
    } catch (e) {
      setState(() {
        _isloading = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) => CustomAlertDialog(
          message: e.toString(),
          success: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Transaction> transaction = ModalRoute.of(context).settings.arguments;
    final f = DateFormat.yMd().add_jm();
    return Scaffold(
      appBar: AppBar(
        title: CustomText('Added Records'),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : transaction.length <= 0
              ? Center(child: CustomText('You have no added records'))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemBuilder: (ctx, i) => SizedBox(
                    height: 100,
                    child: Card(
                      child: ListTile(
                        title: CustomText(
                          'Transaction  ${(i + 1).toString()}',
                          fontsize: 16,
                        ),
                        subtitle: CustomText('Date: ${f.format(
                          transaction[i].timestamp,
                        )}'),
                        contentPadding: EdgeInsets.all(10),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.navigate_next,
                            color: Theme.of(context).primaryColor,
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    VisitDetails(transaction[i], false),
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  VisitDetails(transaction[i], false),
                            ),
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
              onPressed: minerecords,
            ),
    );
  }
}
