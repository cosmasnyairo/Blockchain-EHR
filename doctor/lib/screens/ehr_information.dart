import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/custom_tile.dart';

class EhrInformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    final ehrkey = [args['peer_node'], args['publickey'], args['privatekey']];
    final list = ['Peer Node', 'Public key', 'Private key'];
    final iconslist = [Icons.nature, Icons.lock_open, Icons.lock];
    return Scaffold(
      appBar: AppBar(title: Text('Ehr Information')),
      body: ListView.separated(
        padding: EdgeInsets.all(20),
        separatorBuilder: (_, _$) => SizedBox(height: 20),
        itemBuilder: (ctx, i) =>
            EhrInformationWidget(ehrkey[i].toString(), list[i], iconslist[i]),
        itemCount: ehrkey.length,
      ),
    );
  }
}

class EhrInformationWidget extends StatefulWidget {
  final String ehrkey;
  final String label;
  final IconData iconData;
  EhrInformationWidget(this.ehrkey, this.label, this.iconData);
  @override
  _EhrInformationWidgetState createState() => _EhrInformationWidgetState();
}

class _EhrInformationWidgetState extends State<EhrInformationWidget> {
  void showSnackBarMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CustomTile(
        expansion: true,
        title: widget.label,
        isthreeline: true,
        leadingiconData: widget.iconData,
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
