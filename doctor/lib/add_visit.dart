import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/transaction.dart';
import 'providers/node_provider.dart';
import 'providers/record_provider.dart';
import 'widgets/custom_button.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_text.dart';

class AddVisit extends StatefulWidget {
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _receiver;
  String _addednode;

  var _isInit = true;
  var _isloading = false;
  var scanned = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetch() async {
    await Provider.of<NodeProvider>(context, listen: false).getNodes();
    await Provider.of<RecordsProvider>(context, listen: false)
        .getOpenTransactions();
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
    String _publickey = ModalRoute.of(context).settings.arguments;
    List<Transaction> _opentransactions =
        Provider.of<RecordsProvider>(context, listen: false).opentransactions;

    final _nodes = Provider.of<NodeProvider>(context, listen: false).nodes;
    if (_receiver != null) {
      setState(() {
        scanned = true;
      });
    }
    return _isloading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: CustomText('Add Visit'),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: Container(
              height: deviceheight,
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  Center(
                    child: CustomButton(
                      'Scan Qr COde',
                      () async {
                        try {
                          String codeSanner =
                              await BarcodeScanner.scan(); //barcode scnner
                          setState(() {
                            _receiver = codeSanner;
                            scanned = true;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  scanned
                      ? Form(
                          key: _formKey,
                          child: LimitedBox(
                            maxHeight: deviceheight * 0.20,
                            child: ListView(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter patient node',
                                  ),
                                  keyboardType: TextInputType.text,
                                  style: GoogleFonts.montserrat(),
                                  onSaved: (String val) {
                                    _addednode = val;
                                  },
                                  enabled: _nodes.length > 0 ? false : true,
                                  validator: (String value) {
                                    if (value.trim() == null ||
                                        value.trim().isEmpty) {
                                      return 'Please enter a value';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: _nodes.length > 0
                                      ? CustomButton(
                                          'Ongoing visit',
                                          null,
                                          color: Theme.of(context).errorColor,
                                        )
                                      : CustomButton(
                                          'Add Visit',
                                          () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              try {
                                                setState(() {
                                                  _isloading = true;
                                                });
                                                await Provider.of<NodeProvider>(
                                                        context,
                                                        listen: false)
                                                    .addNodes(
                                                        _addednode.trim());
                                              } catch (e) {
                                                await showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    elevation: 2,
                                                    title:
                                                        CustomText('Message!'),
                                                    content: CustomText(
                                                        e.toString()),
                                                    actions: <Widget>[
                                                      Center(
                                                        child: CustomButton(
                                                          'Ok',
                                                          () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );

                                                fetch().then((value) => {
                                                      setState(() {
                                                        _isloading = false;
                                                      }),
                                                    });
                                              }
                                            } else {
                                              return false;
                                            }
                                          },
                                        ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  Center(
                    child: scanned
                        ? CustomText('Ongoing visits:')
                        : CustomText(
                            'Scan QR code first',
                            color: Theme.of(context).errorColor,
                          ),
                  ),
                  scanned
                      ? LimitedBox(
                          maxHeight: deviceheight * 0.15,
                          child: ListView.separated(
                            separatorBuilder: (context, index) => Divider(),
                            itemBuilder: (ctx, i) => ListTile(
                              title: CustomText(_nodes[i].node.toString()),
                              leading: Icon(Icons.person),
                              subtitle: CustomText(_nodes[i].node.toString()),
                              trailing: FloatingActionButton.extended(
                                heroTag: null,
                                label: CustomText('End Visit'),
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                icon: Icon(
                                  Icons.delete,
                                ),
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      _isloading = true;
                                    });
                                    await Provider.of<NodeProvider>(context,
                                            listen: false)
                                        .removeNode(_nodes[i].node);
                                  } catch (e) {
                                    await showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 2,
                                        title: CustomText('Message!'),
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
                                    );

                                    fetch().then((value) => {
                                          setState(() {
                                            scanned = false;
                                            _receiver = null;
                                            _isloading = false;
                                          }),
                                        });
                                  }
                                },
                              ),
                            ),
                            itemCount: _nodes.length,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: scanned
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.of(context).pushNamed('add_record',
                              arguments: [
                                _publickey,
                                _receiver
                              ]).then((value) => {
                                setState(() {
                                  _isloading = true;
                                }),
                                fetch().then((value) => {
                                      setState(() {
                                        _isloading = false;
                                      }),
                                    })
                              });
                        },
                        heroTag: null,
                        label: CustomText('Add records'),
                        icon: Icon(Icons.add),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 20),
                      FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(
                                'view_open_transaction',
                                arguments: _opentransactions,
                              )
                              .then((value) => {
                                    setState(() {
                                      _isloading = true;
                                    }),
                                    fetch().then((value) => {
                                          setState(() {
                                            _isloading = false;
                                          }),
                                        })
                                  });
                        },
                        heroTag: null,
                        label: CustomText(
                          'Pending records (${_opentransactions.length.toString()})',
                        ),
                        icon: Icon(Icons.library_books),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: _opentransactions.length > 0
                            ? Theme.of(context).errorColor
                            : Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 10),
                    ],
                  )
                : SizedBox(),
          );
  }
}
