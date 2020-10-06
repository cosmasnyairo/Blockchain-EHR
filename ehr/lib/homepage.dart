import 'package:ehr/models/transaction.dart';
import 'package:ehr/providers/node_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'models/block.dart';
import 'models/node.dart';
import 'providers/record_provider.dart';
import 'widgets/badge.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text.dart';
import 'widgets/record_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isloading = false;

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    _getNodes(false);
    _loadKeys();
    _getRecords(false).then(
      (value) => {
        setState(() {
          _isloading = false;
        }),
      },
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getRecords(true);
    super.didChangeDependencies();
  }

  Future _loadKeys() async {
    await Provider.of<RecordsProvider>(context, listen: false).loadKeys();
  }

  Future _getRecords(bool listen) async {
    final provider = Provider.of<RecordsProvider>(context, listen: listen);
    await provider.getChain();
    await provider.getOpenTransactions();
  }

  Future _getNodes(bool listen) async {
    await Provider.of<NodeProvider>(context, listen: listen).getNodes();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    String _publicKey = provider.publickey;
    List<Block> _records = provider.records;
    List<Block> _updatedrecords = _records.skip(1).toList().reversed.toList();
    List<Transaction> _opentransactions = provider.opentransactions;

    List<Node> _nodes = Provider.of<NodeProvider>(context, listen: false).nodes;
    final length = _updatedrecords.length;

    return _isloading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'Welcome,',
                    color: Colors.black54,
                    fontsize: 20,
                  ),
                  CustomText(
                    'Kenneth Erickson',
                    fontsize: 20,
                    fontweight: FontWeight.bold,
                  ),
                ],
              ),
              actions: [
                Consumer<RecordsProvider>(
                  builder: (_, records, child) => Badge(
                    value: records.opentransactions.length.toString(),
                    child: child,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 15,
                      top: 15,
                      right: 20,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.assignment,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          'view_open_transaction',
                          arguments: _opentransactions,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomButton(
                        'Add record',
                        () {
                          Navigator.of(context).pushNamed('add_record');
                        },
                      ),
                      CustomButton('Add visit', () {
                        Navigator.of(context)
                            .pushNamed('share_record', arguments: _nodes);
                      })
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomText(
                    'RECORDS ($length)',
                    fontweight: FontWeight.bold,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, i) => RecordCard(
                        _updatedrecords[i].index,
                        _updatedrecords[i].timestamp,
                        _updatedrecords[i],
                      ),
                      itemCount: _updatedrecords.length,
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  'view_open_transaction',
                  arguments: _opentransactions,
                );
              },
              label: Row(
                children: [
                  CustomText(
                    'Open transactions (${_opentransactions.length.toString()})',
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
  }
}
