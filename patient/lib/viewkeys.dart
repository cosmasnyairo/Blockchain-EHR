import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/custom_tile.dart';

class ViewKeysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final ehrkey = [args['publickey'], args['privatekey']];
    final list = ['Public key', 'Private key'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Ehr Keys'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, i) => EhrKeysWidget(ehrkey[i], list[i]),
        itemCount: ehrkey.length,
      ),
    );
  }
}

class EhrKeysWidget extends StatefulWidget {
  final String ehrkey;
  final String label;
  EhrKeysWidget(this.ehrkey, this.label);
  @override
  _EhrKeysWidgetState createState() => _EhrKeysWidgetState();
}

class _EhrKeysWidgetState extends State<EhrKeysWidget> {
  var _expanded = false;

  void showSnackBarMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.all(10),
      duration: Duration(milliseconds: 400),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: CustomTile(
              title: widget.label,
              subtitle: 'Toggle to view your ${widget.label}',
              iconData: Icons.remove_red_eye,
              onpressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          _expanded
              ? AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: CustomTile(
                      subtitle: widget.ehrkey,
                      iconData: Icons.copy,
                      onpressed: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.ehrkey),
                        ).then((value) => showSnackBarMessage(
                            '${widget.label} has been copied'));
                      },
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

// class EhrKeysPage extends StatefulWidget {
//   final String publickey;
//   final String privatekey;

//   EhrKeysPage({this.publickey, this.privatekey});

//   @override
//   _EhrKeysPageState createState() => _EhrKeysPageState();
// }

// class _EhrKeysPageState extends State<EhrKeysPage> {
//   void showSnackBarMessage(String message) {
//     Scaffold.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         content: Text(message),
//       ),
//     );
//   }

//   var _publicexpanded = false;

//   var _privateexpanded = false;
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: EdgeInsets.all(20),
//       shrinkWrap: true,
//       children: [

//       ],
//     );
//   }
// }
