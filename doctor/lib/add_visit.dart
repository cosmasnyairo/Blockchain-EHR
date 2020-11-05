import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/transaction.dart';
import 'providers/node_provider.dart';
import 'providers/record_provider.dart';
import 'widgets/custom_button.dart';
import 'package:provider/provider.dart';

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
  @override
  void initState() {
    super.initState();
  }

  Future<void> fetch() async {
    await Provider.of<RecordsProvider>(context, listen: false).loadKeys();
    await Provider.of<NodeProvider>(context, listen: false).getNodes();
    await Provider.of<RecordsProvider>(context, listen: false)
        .getOpenTransactions();
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
    List<Transaction> _opentransactions =
        Provider.of<RecordsProvider>(context, listen: false).opentransactions;
    String _publicKey =
        Provider.of<RecordsProvider>(context, listen: false).publickey;
    final _nodes = Provider.of<NodeProvider>(context, listen: false).nodes;

    return _isloading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                'Add Visit',
              ),
            ),
            body: Container(
              height: deviceheight,
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  Center(
                    child: Text('Please don\'t exit page until visit is over'),
                  ),
                  SizedBox(height: 20),
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
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 2,
                                    title: Text('Message!'),
                                    content: Text('Please provide node'),
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
                                )
                              : _receiver == null
                                  ? await showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        elevation: 2,
                                        title: Text('Message!'),
                                        content:
                                            Text('Please scan patient\'s node'),
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
                                    )
                                  : Navigator.of(context).pushNamed(
                                      'add_record',
                                      arguments: [_publicKey, _receiver],
                                    );
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                      RaisedButton.icon(
                        label: Text(
                          'Pending records (${_opentransactions.length.toString()})',
                        ),
                        icon: Icon(Icons.insert_drive_file),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            'view_open_transaction',
                            arguments: _opentransactions,
                          );
                        },
                        color: _opentransactions.length > 0
                            ? Theme.of(context).errorColor
                            : Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  Form(
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
                                    backgroundcolor:
                                        Theme.of(context).errorColor,
                                  )
                                : CustomButton(
                                    'Add Visit',
                                    () async {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        try {
                                          setState(() {
                                            _isloading = true;
                                          });
                                          await Provider.of<NodeProvider>(
                                                  context,
                                                  listen: false)
                                              .addNodes(_addednode.trim());
                                        } catch (e) {
                                          await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              elevation: 2,
                                              title: Text('Message!'),
                                              content: Text(e.toString()),
                                              actions: <Widget>[
                                                Center(
                                                  child: CustomButton(
                                                    'Ok',
                                                    () {
                                                      Navigator.of(context)
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
                  ),
                  Divider(),
                  Center(child: Text('Ongoing visits:')),
                  ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (ctx, i) => ListTile(
                      title: Text(_nodes[i].node.toString()),
                      leading: Icon(Icons.person),
                      subtitle: Text(_nodes[i].node.toString()),
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
                                .removeNode(_nodes[i].node);
                          } catch (e) {
                            await showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 2,
                                title: Text('Message!'),
                                content: Text(e.toString()),
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
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              label: Text('Scan Qr COde'),
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
            ),
          );
  }
}
