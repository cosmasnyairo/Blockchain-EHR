import 'package:barcode_scan/barcode_scan.dart';
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

class _AddVisitState extends State<AddVisit>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;

  List<Transaction> _opentransactions;
  String _publicKey;
  List<Node> _nodes;
  String _receiver;
  String _addednode;

  var _isloading = false;
  var _erroroccurred = false;

  List<Widget> widgetlist = [
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.timer),
        Text('Add Visit'),
        SizedBox(height: 5),
      ],
    ),
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.assignment),
        Text('Health records'),
        SizedBox(height: 5),
      ],
    ),
  ];

  @override
  void initState() {
    _controller = TabController(length: widgetlist.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
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
    super.didChangeDependencies();
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
      appBar: _erroroccurred
          ? null
          : AppBar(
              title: Text('Ehr Visit'),
              elevation: 7,
              bottom: TabBar(
                indicatorWeight: 4,
                onTap: (index) {},
                controller: _controller,
                tabs: widgetlist,
              ),
            ),
      body: _erroroccurred
          ? ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  height: deviceheight * 0.6,
                  child: Image.asset(
                    'assets/404.png',
                    fit: BoxFit.contain,
                  ),
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
                    child: CustomButton('Retry', () {
                  setState(() {
                    _erroroccurred = false;
                  });
                  setState(() {
                    _isloading = true;
                  });
                  fetch().then((value) => {
                        setState(() {
                          _isloading = false;
                        }),
                      });
                }))
              ],
            )
          : _isloading
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _controller,
                  children: [
                    ListView(
                      padding: EdgeInsets.all(20),
                      shrinkWrap: true,
                      children: [
                        _nodes.length == 0
                            ? Column(
                                children: [
                                  Text(
                                    'Choose patient node to add visit',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 20),
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
                                            await Provider.of<NodeProvider>(
                                                    context,
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
                                              success:
                                                  e == 'True' ? true : false,
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
                                ],
                              )
                            : Column(
                                children: [
                                  Text(
                                    'Ongoing visit:',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 10),
                                  ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        Divider(),
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (ctx, i) => ListTile(
                                      title: Text(_nodes[i].node.toString()),
                                      leading: Icon(Icons.person),
                                      subtitle: Text(_nodes[i].node.toString()),
                                      trailing: RaisedButton.icon(
                                        label: Text('End Visit'),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          try {
                                            setState(() {
                                              _isloading = true;
                                            });
                                            await Provider.of<NodeProvider>(
                                                    context,
                                                    listen: false)
                                                .removeNode(_nodes[i].node);
                                          } catch (e) {
                                            await showDialog(
                                              context: context,
                                              builder: (ctx) =>
                                                  CustomAlertDialog(
                                                message: e == 'True'
                                                    ? 'Visit removed'
                                                    : e.toString(),
                                                success:
                                                    e == 'True' ? true : false,
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
                                    ),
                                    itemCount: _nodes.length,
                                  ),
                                ],
                              ),
                      ],
                    ),
                    ListView(
                      padding: EdgeInsets.all(30),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton.icon(
                              label: Text('Add records'),
                              icon: Icon(Icons.note_add),
                              onPressed: () async {
                                _nodes.length == 0
                                    ? await showDialog(
                                        context: context,
                                        builder: (ctx) => CustomAlertDialog(
                                          message: 'Please provide node',
                                          success: false,
                                        ),
                                      )
                                    : _receiver == null
                                        ? await showDialog(
                                            context: context,
                                            builder: (ctx) => CustomAlertDialog(
                                              message:
                                                  'Please scan patient\'s node',
                                              success: false,
                                            ),
                                          )
                                        : Navigator.of(context).pushNamed(
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
                              },
                              color: Theme.of(context).primaryColor,
                            ),
                            RaisedButton.icon(
                              label: Text(
                                'Pending records (${_opentransactions.length})',
                              ),
                              icon: Icon(Icons.insert_drive_file),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(
                                      'view_open_transaction',
                                      arguments: _opentransactions,
                                    )
                                    .then(
                                      (value) => {
                                        value == null
                                            ? null
                                            : showSnackBarMessage(
                                                value.toString())
                                      },
                                    );
                              },
                              color: _opentransactions.length > 0
                                  ? Theme.of(context).errorColor
                                  : Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
      floatingActionButton: _erroroccurred
          ? null
          : _controller.index == 1
              ? FloatingActionButton.extended(
                  label: Text('Scan Qr Code'),
                  icon: Icon(Icons.center_focus_weak),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () async {
                    try {
                      String codeSanner =
                          await BarcodeScanner.scan(); //barcode scnner
                      setState(() {
                        _receiver = codeSanner;
                      });
                    } catch (e) {}
                  },
                  backgroundColor: Theme.of(context).primaryColor,
                )
              : SizedBox(),
    );
  }
}
