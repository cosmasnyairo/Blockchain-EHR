import 'package:flutter/material.dart';
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
  var _isInit = true;
  String _publicKey;

  Future<void> fetch() async {
    await Provider.of<RecordsProvider>(context, listen: false).loadKeys();
    _publicKey = Provider.of<RecordsProvider>(context, listen: false).publickey;
    await Provider.of<RecordsProvider>(context, listen: false)
        .getPatientChain(_publicKey);
    await Provider.of<RecordsProvider>(context, listen: false)
        .resolveConflicts();
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

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;

    List<Block> _updatedrecords =
        Provider.of<RecordsProvider>(context, listen: false)
            .records
            .reversed
            .toList();

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
          );
  }
}
