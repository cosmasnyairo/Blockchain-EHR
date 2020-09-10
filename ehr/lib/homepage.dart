import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'models/block.dart';
import 'providers/record_provider.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text.dart';
import 'widgets/record.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isloading = false;
  @override
  void didChangeDependencies() {
    setState(() {
      _isloading = true;
    });
    _getRecords().then(
      (value) => {
        setState(() {
          _isloading = false;
        }),
      },
    );
    super.didChangeDependencies();
  }

  Future _getRecords() async {
    await Provider.of<RecordsProvider>(context, listen: false).getChain();
  }

  @override
  Widget build(BuildContext context) {
    List<Block> _records =
        Provider.of<RecordsProvider>(context, listen: false).records;
    _records = _records.skip(1).toList();

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
                  )
                ],
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomButton(
                        'ADD RECORD',
                        () {
                          Navigator.of(context).pushNamed('add_record');
                        },
                      ),
                      CustomButton('SHARE RECORDS', () {})
                    ],
                  ),
                  SizedBox(height: 20),
                  CustomText('RECORDS', fontweight: FontWeight.bold),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (ctx, i) => RecordCard(
                        _records[i].index,
                        _records[i].timestamp,
                      ),
                      itemCount: _records.length,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
