import 'package:flutter/material.dart';
import 'package:patient/providers/node_provider.dart';

import 'package:provider/provider.dart';

import 'models/block.dart';
import 'providers/record_provider.dart';
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
    _loadnodes();
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

  Future _loadnodes() async {
    await Provider.of<NodeProvider>(context, listen: false).getNodes();
  }

  Future _getRecords(bool listen) async {
    final provider = Provider.of<RecordsProvider>(context, listen: listen);
    await provider.getChain();
    await provider.loadKeys();
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    String _publicKey = provider.publickey;
    List<Block> _updatedrecords =
        provider.records.skip(1).toList().reversed.toList();

    _updatedrecords
        .removeWhere((element) => element.userPublicKey != _publicKey);

    return _isloading
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(deviceheight * 0.08),
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Welcome,',
                      color: Colors.black54,
                      fontsize: 16,
                    ),
                    CustomText(
                      'Kenneth Erickson',
                      fontsize: 20,
                    ),
                  ],
                ),
                actions: [
                  Container(
                    padding: EdgeInsets.all(8),
                    child: CustomButton(
                      'ADD VISIT',
                      () {
                        Navigator.of(context).pushNamed(
                          'share_record',
                        );
                      },
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10)
                ],
              ),
            ),
            body: Container(
              height: deviceheight,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                children: [
                  Center(
                    child: CustomText(
                      'MY RECORDS (${_updatedrecords.length})',
                      fontweight: FontWeight.bold,
                      fontsize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: deviceheight * 0.9,
                    child: ListView.builder(
                      itemBuilder: (ctx, i) => RecordCard(
                        _updatedrecords[i].index,
                        _publicKey,
                        _updatedrecords[i].timestamp,
                        _updatedrecords[i],
                      ),
                      itemCount: _updatedrecords.length,
                    ),
                  ),
                ],
              ),
            ),
            // floatingActionButtonLocation:
            //     FloatingActionButtonLocation.centerFloat,
            // floatingActionButton: _ongoingvisit
            //     ? FloatingActionButton.extended(
            //         onPressed: () {
            //           print('pressed');
            //         },
            //         backgroundColor: Theme.of(context).errorColor,
            //         label: CustomText('You have an ongoing visit'),
            //         icon: Icon(Icons.cancel),
            //       )
            //     : SizedBox(),
          );
  }
}
