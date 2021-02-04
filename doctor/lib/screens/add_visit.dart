import 'package:barcode_scan/barcode_scan.dart';
import 'package:doctor/screens/view_patient_records.dart';
import 'package:doctor/widgets/custom_floating_action_button.dart';
import 'package:doctor/widgets/custom_image.dart';
import 'package:doctor/widgets/custom_tile.dart';
import 'package:doctor/widgets/error_screen.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_text.dart';
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
  final TextEditingController texteditingcontroller = TextEditingController();
  List<Transaction> _opentransactions = [];
  String _publicKey;
  List<Node> _nodes = [];
  String _receiver;
  bool _isloading = false;
  bool _erroroccurred = false;

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

  @override
  void dispose() {
    texteditingcontroller.dispose();
    super.dispose();
  }

  Future<void> fetch() async {
    final recordprovider = Provider.of<RecordsProvider>(context, listen: false);
    final nodeprovider = Provider.of<NodeProvider>(context, listen: false);
    try {
      await recordprovider.getPortNumber(context);
      await recordprovider.loadKeys(recordprovider.peernode);
      await recordprovider.getOpenTransactions(recordprovider.peernode);
      await recordprovider.resolveConflicts(recordprovider.peernode);
      await nodeprovider.getNodes(recordprovider.peernode);
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
      SnackBar(duration: Duration(seconds: 2), content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final peer_node =
        Provider.of<RecordsProvider>(context, listen: false).peernode;

    final actionstitlelist = [
      'Patient\'s records',
      'View added records',
      'Add health records',
      'Scan QR code',
    ];
    final actionsiconslist = [
      Icons.assignment,
      Icons.description_outlined,
      Icons.add,
      Icons.center_focus_weak
    ];
    final actionsColor = [
      Colors.white,
      _opentransactions.length > 0
          ? Theme.of(context).errorColor
          : Colors.white,
      Colors.white,
      Colors.white
    ];
    final actionslist = [
      _receiver == null
          ? () async {
              await showDialog(
                context: context,
                builder: (ctx) => CustomAlertDialog(
                  message: 'Please scan Qr code first',
                  success: false,
                ),
              );
            }
          : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewPatientRecords(_receiver),
                ),
              );
            },
      () {
        Navigator.of(context)
            .pushNamed(
          'view_open_transaction',
          arguments: _opentransactions,
        )
            .then((value) {
          if (value != null) {
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
          }
        });
      },
      _receiver == null
          ? () async {
              await showDialog(
                context: context,
                builder: (ctx) => CustomAlertDialog(
                  message: 'Please scan Qr code first',
                  success: false,
                ),
              );
            }
          : () async {
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
      _nodes.length == 0
          ? () async {
              await showDialog(
                context: context,
                builder: (ctx) => CustomAlertDialog(
                  message: 'Please provide node and start visit',
                  success: false,
                ),
              );
            }
          : () async {
              try {
                String codeSanner =
                    await BarcodeScanner.scan(); //barcode scnner
                setState(() {
                  _receiver = codeSanner;
                  _isloading = true;
                });
                setState(() {
                  _isloading = false;
                });
              } on FormatException catch (e) {} catch (e) {
                await showDialog(
                  context: context,
                  builder: (ctx) => CustomAlertDialog(
                    message: e.toString(),
                    success: false,
                  ),
                );
              }
            },
    ];
    return Scaffold(
        appBar: _erroroccurred ? null : AppBar(title: Text('Ehr Visit')),
        body: _erroroccurred
            ? ErrorPage()
            : _isloading
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    shrinkWrap: true,
                    children: [
                      _nodes.length == 0
                          ? SizedBox()
                          : CustomText(
                              'You have an ongoing visit',
                              alignment: TextAlign.center,
                            ),
                      SizedBox(height: 5),
                      ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: _nodes.length == 0
                            ? [
                                CustomFormField(
                                  controller: texteditingcontroller,
                                  keyboardtype: TextInputType.number,
                                  textInputAction: TextInputAction.go,
                                  icondata: Icons.person_outline,
                                  labeltext: "Enter Patient's node ",
                                ),
                                SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: CustomButton(
                                    'Add Visit',
                                    () async {
                                      try {
                                        if (texteditingcontroller.text ==
                                                null ||
                                            texteditingcontroller.text == "") {
                                          throw 'Node can\'t be empty';
                                        } else {
                                          setState(() {
                                            _isloading = true;
                                          });
                                          await Provider.of<NodeProvider>(
                                                  context,
                                                  listen: false)
                                              .addNodes(peer_node,
                                                  texteditingcontroller.text);

                                          setState(() {
                                            _isloading = false;
                                          });
                                        }
                                      } catch (e) {
                                        print(e);
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
                                              texteditingcontroller.clear();
                                            }),
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ]
                            : [
                                CustomTile(
                                  title: _nodes[0].node.toString(),
                                  leadingiconData: Icons.person,
                                  subtitle: _nodes[0].node.toString(),
                                  label: 'End Visit',
                                  visit: true,
                                  visiticon: Icons.delete,
                                  onpressed: () async {
                                    try {
                                      setState(() {
                                        _isloading = true;
                                      });
                                      await Provider.of<NodeProvider>(context,
                                              listen: false)
                                          .removeNode(
                                              peer_node, _nodes[0].node);
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
                                )
                              ],
                      ),
                      SizedBox(height: 10),
                      _receiver != null
                          ? CustomText(
                              'You currently have an ongoing visit.',
                              color: Colors.black,
                            )
                          : SizedBox(),
                      SizedBox(height: 10),
                      CustomText("Choose from the options below",
                          alignment: TextAlign.center),
                      SizedBox(height: 10),
                      GridView.builder(
                        physics: ClampingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 7 / 4,
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        itemCount: actionstitlelist.length,
                        itemBuilder: (ctx, i) => Card(
                          child: InkWell(
                            onTap: actionslist[i],
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: GridTile(
                                child: Icon(actionsiconslist[i]),
                                header: CustomText(actionstitlelist[i],
                                    alignment: TextAlign.center),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: deviceheight * 0.25,
                        child: CustomImage('assets/peers2.png', BoxFit.contain),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
        floatingActionButton: _erroroccurred
            ? CustomFAB(
                'Try again',
                Icons.refresh,
                () {
                  setState(() {
                    _erroroccurred = false;
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
              )
            : null
        //  _isloading
        //     ? SizedBox()
        //     : Wrap(
        //         spacing: 10,
        //         runSpacing: 10,
        //         alignment: WrapAlignment.start,
        //         children: [
        //           CustomFAB(
        //             'View patient records',
        //             Icons.remove_red_eye_rounded,
        //             _receiver == null
        //                 ? () async {
        //                     await showDialog(
        //                       context: context,
        //                       builder: (ctx) => CustomAlertDialog(
        //                         message: 'Please scan Qr code first',
        //                         success: false,
        //                       ),
        //                     );
        //                   }
        //                 : () {
        //                     Navigator.of(context).push(
        //                       MaterialPageRoute(
        //                         builder: (context) =>
        //                             ViewPatientRecords(_receiver),
        //                       ),
        //                     );
        //                   },
        //           ),
        //           CustomFAB(
        //             'View added records',
        //             Icons.description_outlined,
        //             () {
        //               Navigator.of(context)
        //                   .pushNamed(
        //                 'view_open_transaction',
        //                 arguments: _opentransactions,
        //               )
        //                   .then((value) {
        //                 if (value != null) {
        //                   showSnackBarMessage(value.toString());
        //                   setState(() {
        //                     _isloading = true;
        //                   });
        //                   fetch().then(
        //                     (value) => {
        //                       setState(() {
        //                         _isloading = false;
        //                       }),
        //                     },
        //                   );
        //                 }
        //               });
        //             },
        //             color: _opentransactions.length > 0
        //                 ? Theme.of(context).errorColor
        //                 : Theme.of(context).primaryColor,
        //           ),
        //           CustomFAB(
        //             'Add health records',
        //             Icons.add,
        //             _receiver == null
        //                 ? () async {
        //                     await showDialog(
        //                       context: context,
        //                       builder: (ctx) => CustomAlertDialog(
        //                         message: 'Please scan Qr code first',
        //                         success: false,
        //                       ),
        //                     );
        //                   }
        //                 : () async {
        //                     try {
        //                       Navigator.of(context).pushNamed(
        //                         'add_record',
        //                         arguments: [_publicKey, _receiver],
        //                       ).then(
        //                         (value) => {
        //                           setState(() {
        //                             _isloading = true;
        //                           }),
        //                           fetch().then(
        //                             (value) => {
        //                               setState(() {
        //                                 _isloading = false;
        //                               }),
        //                             },
        //                           ),
        //                         },
        //                       );
        //                     } catch (e) {
        //                       await showDialog(
        //                         context: context,
        //                         builder: (ctx) => CustomAlertDialog(
        //                           message: e.toString(),
        //                           success: false,
        //                         ),
        //                       );
        //                     }
        //                   },
        //           ),
        //           CustomFAB(
        //             'Scan QR code',
        //             Icons.center_focus_weak,
        //             _nodes.length == 0
        //                 ? () async {
        //                     await showDialog(
        //                       context: context,
        //                       builder: (ctx) => CustomAlertDialog(
        //                         message:
        //                             'Please provide node and start visit',
        //                         success: false,
        //                       ),
        //                     );
        //                   }
        //                 : () async {
        //                     try {
        //                       String codeSanner = await BarcodeScanner
        //                           .scan(); //barcode scnner
        //                       setState(() {
        //                         _receiver = codeSanner;
        //                         _isloading = true;
        //                       });
        //                       setState(() {
        //                         _isloading = false;
        //                       });
        //                     } catch (e) {
        //                       await showDialog(
        //                         context: context,
        //                         builder: (ctx) => CustomAlertDialog(
        //                           message: e.toString(),
        //                           success: false,
        //                         ),
        //                       );
        //                     }
        //                   },
        //           ),
        //         ],
        //       ),
        );
  }
}
