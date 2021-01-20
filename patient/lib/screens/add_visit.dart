import 'package:flutter/material.dart';
import 'package:patient/widgets/custom_form_field.dart';
import 'package:patient/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/node.dart';
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
  List<Node> _nodes;
  String _publicKey;
  final texteditingcontroller = TextEditingController();

  var _isloading = false;
  var _erroroccurred = false;

  @override
  void dispose() {
    texteditingcontroller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _isloading = true;
    });
    fetch().then((value) => {
          setState(() {
            _isloading = false;
          }),
        });
    super.didChangeDependencies();
  }

  Future<void> fetch() async {
    final recordprovider = Provider.of<RecordsProvider>(context, listen: false);
    final nodeprovider = Provider.of<NodeProvider>(context, listen: false);

    try {
      await recordprovider.loadKeys();
      await nodeprovider.getNodes();
      await recordprovider.resolveConflicts();
      _publicKey = recordprovider.publickey;
      _nodes = nodeprovider.nodes;
    } catch (e) {
      setState(() {
        _erroroccurred = true;
        _isloading = false;
      });
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: _erroroccurred || _isloading
          ? null
          : AppBar(title: Text('Ehr Visit')),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : _erroroccurred
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
                              ? 'Choose doctor node to add visit.'
                              : 'You currently have an ongoing visit.\n\nPresent Qr code to doctor',
                          color:
                              _nodes.length == 0 ? Colors.grey : Colors.black,
                          alignment: TextAlign.center,
                        ),
                        ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(20),
                          physics: ClampingScrollPhysics(),
                          children: _nodes.length == 0
                              ? [
                                  CustomFormField(
                                    controller: texteditingcontroller,
                                    keyboardtype: TextInputType.number,
                                    textInputAction: TextInputAction.go,
                                    icondata: Icons.person_outline,
                                    labeltext: "Enter Doctor's node ",
                                  ),
                                  SizedBox(height: 20),
                                  Center(
                                    child: CustomButton(
                                      'Add Visit',
                                      () async {
                                        try {
                                          if (texteditingcontroller.text ==
                                                  null ||
                                              texteditingcontroller.text ==
                                                  "") {
                                            throw 'Node can\'t be empty';
                                          } else {
                                            setState(() {
                                              _isloading = true;
                                            });
                                            await Provider.of<NodeProvider>(
                                                    context,
                                                    listen: false)
                                                .addNodes(
                                                    texteditingcontroller.text);
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
                                                texteditingcontroller.clear();
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
                                                .removeNode(_nodes[0].node);
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
                                                setState(() {
                                                  _isloading = false;
                                                }),
                                              },
                                            );
                                          }
                                        }),
                                  )
                                ],
                        ),
                        _nodes.length == 0
                            ? SizedBox()
                            : Center(
                                child: QrImage(
                                  size: deviceheight * 0.5,
                                  data: _publicKey,
                                  constrainErrorBounds: true,
                                  gapless: true,
                                ),
                              ),
                      ],
                    ),
    );
  }
}
