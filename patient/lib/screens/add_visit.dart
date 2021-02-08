import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/node.dart';
import '../providers/node_provider.dart';
import '../providers/record_provider.dart';
import '../theme/customtheme.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_floating_action_button.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_tile.dart';
import '../widgets/error_screen.dart';

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
      await recordprovider.getPortNumber(context);

      await recordprovider.loadKeys(recordprovider.peernode);
      await nodeprovider.getNodes(recordprovider.peernode);
      await recordprovider.resolveConflicts(recordprovider.peernode);
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
    final peer_node =
        Provider.of<RecordsProvider>(context, listen: false).peernode;

    return Scaffold(
        appBar: _erroroccurred || _isloading
            ? null
            : AppBar(title: Text('Ehr Visit')),
        body: _isloading
            ? Center(child: CircularProgressIndicator())
            : _erroroccurred
                ? ErrorPage()
                : _isloading
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          SizedBox(height: 5),
                          _nodes.length == 0
                              ? SizedBox()
                              : CustomText(
                                  'You have an ongoing visit',
                                  alignment: TextAlign.center,
                                ),
                          SizedBox(height: 5),
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
                                    Align(
                                      alignment: Alignment.centerRight,
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
                                                      peer_node,
                                                      texteditingcontroller
                                                          .text);
                                              setState(() {
                                                _isloading = false;
                                              });
                                            }
                                          } catch (e) {
                                            await showDialog(
                                              context: context,
                                              builder: (ctx) =>
                                                  CustomAlertDialog(
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
                                          await Provider.of<NodeProvider>(
                                                  context,
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
                                  ],
                          ),
                          SizedBox(height: 20),
                          _nodes.length == 0
                              ? Container(
                                  padding: EdgeInsets.all(20),
                                  height: deviceheight * 0.4,
                                  child: CustomImage(
                                      'assets/peers.png', BoxFit.contain),
                                )
                              : Container(
                                  constraints: BoxConstraints(
                                    maxHeight: deviceheight * 0.4,
                                  ),
                                  alignment: Alignment.center,
                                  child: Card(
                                    color: Provider.of<CustomThemeProvider>(
                                                context)
                                            .darkthemechosen
                                        ? Theme.of(context).accentColor
                                        : Colors.white,
                                    child: QrImage(
                                      padding: EdgeInsets.all(20),
                                      data: _publicKey,
                                      constrainErrorBounds: true,
                                      gapless: true,
                                    ),
                                  ),
                                ),
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
            : null);
  }
}
