import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/providers/node_provider.dart';
import 'package:patient/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'providers/record_provider.dart';
import 'widgets/custom_text.dart';

class AddVisit extends StatefulWidget {
  @override
  _AddVisitState createState() => _AddVisitState();
}

class _AddVisitState extends State<AddVisit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _addednode;
  bool _isloading = false;

  @override
  void initState() {
    setState(() {
      _isloading = true;
    });
    Provider.of<NodeProvider>(context, listen: false).getNodes();
    setState(() {
      _isloading = false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _nodes = Provider.of<NodeProvider>(context, listen: false).nodes;
    final deviceheight = MediaQuery.of(context).size.height;
    final _publicKey = ModalRoute.of(context).settings.arguments;

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
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(width: 1.0)),
                      child: QrImage(
                        data: _publicKey,
                        size: deviceheight * 0.4,
                      ),
                    ),
                  ),
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
                              labelText: 'Enter doctor node',
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
                                          setState(() {
                                            _isloading = false;
                                          });
                                        } catch (e) {
                                          await showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              elevation: 2,
                                              title: CustomText('Message!'),
                                              content: CustomText(e.toString()),
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
                                          ).then((value) {
                                            setState(() {
                                              _isloading = false;
                                            });
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
                  CustomText('Ongoing visits:'),
                  LimitedBox(
                    maxHeight: deviceheight * 0.5,
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
                              await Provider.of<RecordsProvider>(context,
                                      listen: false)
                                  .resolveConflicts();
                              setState(() {
                                _isloading = false;
                              });
                            } catch (e) {
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
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
                              ).then((value) {
                                setState(() {
                                  _isloading = false;
                                });
                              });
                            }
                          },
                        ),
                      ),
                      itemCount: _nodes.length,
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
