import 'models/transaction.dart';
import 'providers/node_provider.dart';
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
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      fetch().then((value) => {
            setState(() {
              _isloading = false;
            }),
          });
    }
    super.didChangeDependencies();
    _isInit = false;
  }

  Future<void> fetch() async {
    await Provider.of<RecordsProvider>(context, listen: false).loadKeys();
    await Provider.of<RecordsProvider>(context, listen: false).getChain();
    await Provider.of<RecordsProvider>(context, listen: false)
        .resolveConflicts();
  }

  @override
  Widget build(BuildContext context) {
    String _publicKey =
        Provider.of<RecordsProvider>(context, listen: false).publickey;

    List<Block> _updatedrecords =
        Provider.of<RecordsProvider>(context, listen: false)
            .records
            .reversed
            .toList();

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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton('Add Visit', () {
                    Navigator.of(context)
                        .pushNamed('add_visit', arguments: _publicKey)
                        .then((value) => {
                              setState(() {
                                _isloading = true;
                              }),
                              fetch().then((value) => {
                                    setState(() {
                                      _isloading = false;
                                    }),
                                  }),
                            });
                  }),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CustomText(
                    'Patient Records (${_updatedrecords.length})',
                    fontweight: FontWeight.bold,
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, i) => RecordCard(
                        _updatedrecords[i].index,
                        _publicKey,
                        _updatedrecords[i].timestamp,
                        _updatedrecords[i],
                      ),
                      itemCount: _updatedrecords.length,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
