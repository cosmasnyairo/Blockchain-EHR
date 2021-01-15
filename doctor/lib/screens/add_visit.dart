import 'package:barcode_scan/barcode_scan.dart';
import 'package:doctor/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/node.dart';
import '../models/transaction.dart';
import '../providers/node_provider.dart';
import '../providers/record_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_button.dart';

class AddVisit extends StatefulWidget {
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  List<Transaction> _opentransactions;
  String _publicKey;
  List<Node> _nodes;
  String _receiver;
  String _addednode;

  var _isloading = false;
  var _erroroccurred = false;

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    fetch().then(
      (value) => {
        setState(() {
          _isloading = false;
        }),
      },
    );
    super.initState();
  }

  Future<void> fetch() async {
    final recordprovider = Provider.of<RecordsProvider>(context, listen: false);
    final nodeprovider = Provider.of<NodeProvider>(context, listen: false);

    try {
      await recordprovider.loadKeys();
      await recordprovider.getOpenTransactions();
      await recordprovider.resolveConflicts();
      await nodeprovider.getNodes();

      _opentransactions = recordprovider.opentransactions;
      _publicKey = recordprovider.publickey;
      _nodes = nodeprovider.nodes;
    } catch (e) {
      setState(() {
        _erroroccurred = true;
        _isloading = false;
      });
    }
  }

  void showSnackBarMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: _erroroccurred ? null : AppBar(title: Text('Ehr Visit')),
      body: _erroroccurred
          ? ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  height: deviceheight * 0.6,
                  child: Image.asset('assets/404.png', fit: BoxFit.contain),
                ),
                SizedBox(height: 20),
                Text(
                  'An Error Occured!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
                SizedBox(height: 20),
                Text(
                  'The Server may be offline, please retry after some time',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Center(
                  child: CustomButton(
                    'Retry',
                    () {
                      setState(() {
                        _erroroccurred = false;
                      });
                      setState(() {
                        _isloading = true;
                      });
                      fetch().then(
                        (value) => {
                          setState(() {
                            _isloading = false;
                          }),
                        },
                      );
                    },
                  ),
                )
              ],
            )
          : _isloading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 10),
                    CustomText(
                      _nodes.length == 0
                          ? 'Choose patient node to add visit.'
                          : _receiver == null
                              ? 'You currently have an ongoing visit\n\nScan patient\'s Qr Code to add records'
                              : 'You currently have an ongoing visit.',
                      color: _nodes.length == 0
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      alignment: TextAlign.center,
                      fontStyle: FontStyle.italic,
                    ),
                    SizedBox(height: 10),
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(20),
                      physics: ClampingScrollPhysics(),
                      children: _nodes.length == 0
                          ? [
                              DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(
                                    Icons.person_outline,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                hint: Text("Choose node "),
                                items: [
                                  DropdownMenuItem(
                                    child: Text("5001"),
                                    value: "5001",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("5002"),
                                    value: "5002",
                                  ),
                                ],
                                onChanged: (value) {
                                  _addednode = value.toString().trim();
                                },
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: CustomButton(
                                  'Add Visit',
                                  () async {
                                    try {
                                      if (_addednode == null) {
                                        throw 'Choose patient node';
                                      } else {
                                        setState(() {
                                          _isloading = true;
                                        });
                                        await Provider.of<NodeProvider>(context,
                                                listen: false)
                                            .addNodes(_addednode);
                                      }
                                    } catch (e) {
                                      await showDialog(
                                        context: context,
                                        builder: (ctx) => CustomAlertDialog(
                                          message: e == 'True'
                                              ? 'Succesfully added visit'
                                              : e.toString(),
                                          success: e == 'True' ? true : false,
                                        ),
                                      );
                                      fetch().then(
                                        (value) => {
                                          setState(() {
                                            _isloading = false;
                                          }),
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                            ]
                          : [
                              ListTile(
                                title: Text(_nodes[0].node.toString()),
                                leading: Icon(Icons.person),
                                subtitle: Text(_nodes[0].node.toString()),
                                trailing: RaisedButton.icon(
                                  label: Text('End Visit'),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    try {
                                      setState(() {
                                        _isloading = true;
                                      });
                                      await Provider.of<NodeProvider>(context,
                                              listen: false)
                                          .removeNode(_nodes[0].node);
                                    } catch (e) {
                                      await showDialog(
                                        context: context,
                                        builder: (ctx) => CustomAlertDialog(
                                          message: e == 'True'
                                              ? 'Visit removed'
                                              : e.toString(),
                                          success: e == 'True' ? true : false,
                                        ),
                                      );
                                      fetch().then(
                                        (value) => {
                                          setState(
                                            () {
                                              _receiver = null;
                                              _isloading = false;
                                            },
                                          ),
                                        },
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                    )
                  ],
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _erroroccurred || _isloading
          ? SizedBox()
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _opentransactions.length > 0
                    ? customFAB(
                        'View added records',
                        Icons.description_outlined,
                        () {
                          Navigator.of(context)
                              .pushNamed(
                            'view_open_transaction',
                            arguments: _opentransactions,
                          )
                              .then((value) {
                            showSnackBarMessage(value.toString());
                            setState(() {
                              _isloading = true;
                            });
                            fetch().then(
                              (value) => {
                                setState(() {
                                  _isloading = false;
                                }),
                              },
                            );
                          });
                        },
                        color: _opentransactions.length > 0
                            ? Theme.of(context).errorColor
                            : Theme.of(context).primaryColor,
                      )
                    : SizedBox(),
                _opentransactions.length > 0
                    ? SizedBox(height: 20)
                    : SizedBox(),
                _receiver == null
                    ? customFAB(
                        'Scan QR Code',
                        Icons.center_focus_weak,
                        _nodes.length == 0
                            ? () async {
                                await showDialog(
                                  context: context,
                                  builder: (ctx) => CustomAlertDialog(
                                    message:
                                        'Please provide node and start visit',
                                    success: false,
                                  ),
                                );
                              }
                            : () async {
                                try {
                                  String codeSanner = await BarcodeScanner
                                      .scan(); //barcode scnner
                                  setState(() {
                                    _receiver = codeSanner;
                                    _isloading = true;
                                  });
                                  await Future.delayed(Duration(seconds: 1));
                                  setState(() {
                                    _isloading = false;
                                  });
                                  Navigator.of(context).pushNamed(
                                    'add_record',
                                    arguments: [_publicKey, _receiver],
                                  ).then(
                                    (value) => {
                                      setState(() {
                                        _isloading = true;
                                      }),
                                      fetch().then(
                                        (value) => {
                                          setState(() {
                                            _isloading = false;
                                          }),
                                        },
                                      ),
                                    },
                                  );
                                } on FormatException catch (e) {
                                  print(e);
                                } catch (e) {
                                  await showDialog(
                                    context: context,
                                    builder: (ctx) => CustomAlertDialog(
                                      message: e.toString(),
                                      success: false,
                                    ),
                                  );
                                }
                              },
                      )
                    : customFAB(
                        'Add Records',
                        Icons.add,
                        () async {
                          try {
                            Navigator.of(context).pushNamed(
                              'add_record',
                              arguments: [_publicKey, _receiver],
                            ).then(
                              (value) => {
                                setState(() {
                                  _isloading = true;
                                }),
                                fetch().then(
                                  (value) => {
                                    setState(() {
                                      _isloading = false;
                                    }),
                                  },
                                ),
                              },
                            );
                          } catch (e) {
                            await showDialog(
                              context: context,
                              builder: (ctx) => CustomAlertDialog(
                                message: e.toString(),
                                success: false,
                              ),
                            );
                          }
                        },
                      ),
                SizedBox(height: 20),
              ],
            ),
    );
  }

  FloatingActionButton customFAB(
      String labelText, IconData icondata, Function onpressed,
      {Color color}) {
    return FloatingActionButton.extended(
      label: Text(labelText),
      icon: Icon(icondata),
      heroTag: null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onpressed,
      backgroundColor: color == null ? Theme.of(context).primaryColor : color,
    );
  }
}
