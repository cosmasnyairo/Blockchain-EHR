import 'package:flutter/material.dart';
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
  TabController _controller;
  int _selectedIndex = 0;

  List<Node> _nodes;
  String _addednode;
  String _publicKey;

  var _isloading = false;

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
        Icon(Icons.filter_center_focus),
        Text('Qr Code'),
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

    await recordprovider.loadKeys();
    await nodeprovider.getNodes();

    _publicKey = recordprovider.publickey;
    _nodes = nodeprovider.nodes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ehr Visit'),
        elevation: 7,
        bottom: TabBar(
          indicatorWeight: 4,
          onTap: (index) {},
          controller: _controller,
          tabs: widgetlist,
        ),
      ),
      body: _isloading
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
                                    child: Text("5000"),
                                    value: "5000",
                                  ),
                                  DropdownMenuItem(
                                    child: Text("5003"),
                                    value: "5003",
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
                                        throw 'Choose doctor node';
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
                  padding: EdgeInsets.all(20),
                  children: [
                    Text(
                      'Present Qr code to doctor during visit',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: QrImage(
                        data: _publicKey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
