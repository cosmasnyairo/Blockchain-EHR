import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_tile.dart';

class ViewKeysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final ehrkey = [args['publickey'], args['privatekey']];
    final list = ['Public key', 'Private key'];
    return Scaffold(
      appBar: AppBar(title: Text('Ehr Keys')),
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
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(20),
      child: CustomTile(
        expansion: true,
        title: widget.label,
        subtitle: 'Toggle to view your ${widget.label}',
        iconData: Icons.remove_red_eye,
        expansionchildren: CustomTile(
          subtitle: widget.ehrkey,
          iconData: Icons.copy,
          onpressed: () {
            Clipboard.setData(
              ClipboardData(text: widget.ehrkey),
            ).then((value) =>
                showSnackBarMessage('${widget.label} has been copied'));
          },
        ),
      ),
    );
  }
}
