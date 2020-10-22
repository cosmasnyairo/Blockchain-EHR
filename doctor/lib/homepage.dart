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

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });

    fetch(false);

    setState(() {
      _isloading = false;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _isloading = true;
    });

    fetch(false);

    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  void fetch(bool listen) async {
    await Provider.of<RecordsProvider>(context, listen: listen).loadKeys();
    await Provider.of<RecordsProvider>(context, listen: listen).getChain();
    await Provider.of<RecordsProvider>(context, listen: listen)
        .resolveConflicts();
  }

  @override
  Widget build(BuildContext context) {
    String _publicKey =
        Provider.of<RecordsProvider>(context, listen: false).publickey;

    List<Block> _updatedrecords =
        Provider.of<RecordsProvider>(context, listen: false)
            .records
            .skip(1)
            .toList()
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
                        .pushNamed('add_visit', arguments: _publicKey);
                  }),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // SizedBox(height: 10),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     CustomButton(
                  //       'Add records',
                  //       () {
                  //         Navigator.of(context).pushNamed('add_record');
                  //       },
                  //     ),
                  //     CustomButton(
                  //       'Add Visit ',
                  //       () {
                  //         Navigator.of(context)
                  //             .pushNamed('share_record', arguments: _nodes);
                  //       },
                  //     )
                  //   ],
                  // ),
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
            // floatingActionButton: FloatingActionButton.extended(
            //   onPressed: () {
            //     Navigator.of(context).pushNamed(
            //       'view_open_transaction',
            //       arguments: _opentransactions,
            //     );
            //   },
            //   label: Row(
            //     children: [
            //       CustomText(
            //         'Pending records (${_opentransactions.length.toString()})',
            //       ),
            //     ],
            //   ),
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10)),
            //   backgroundColor: Theme.of(context).primaryColor,
            // ),
          );
  }
}
