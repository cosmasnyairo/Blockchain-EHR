import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:patient/models/user.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final EhrUser ehruser = ModalRoute.of(context).settings.arguments;

    final format = DateFormat.yMd().add_jm();
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
      ),
      body: Container(
        height: deviceheight,
        child: ListView(
          padding: EdgeInsets.all(20),
          shrinkWrap: true,
          children: [
            EditAccountWidget(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
              title: 'Name',
              value: ehruser.name,
              onpressed: () {},
            ),
            EditAccountWidget(
              leading: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
              ),
              title: 'Email',
              value: ehruser.email,
              onpressed: () {},
            ),
            EditAccountWidget(
              leading: Icon(
                Icons.location_on,
                color: Theme.of(context).primaryColor,
              ),
              title: 'Location',
              value: ehruser.location,
              onpressed: () {},
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Theme.of(context).accentColor,
              ),
              title: Text('Below Details cannot be modified.'),
              subtitle: Text('Contact us to modify them for you'),
            ),
            SizedBox(height: 10),
            EditAccountWidget(
              title: 'Public Key',
              value: ehruser.publickey,
              onpressed: () {},
              nonmodify: true,
            ),
            EditAccountWidget(
              title: 'Private Key',
              value: ehruser.privatekey,
              onpressed: () {},
              nonmodify: true,
            ),
            SizedBox(height: 20),
            Text(
              'Join Date: ${format.format(ehruser.joindate)}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class EditAccountWidget extends StatelessWidget {
  final String title;
  final String value;
  final Function onpressed;
  final Icon leading;
  final bool nonmodify;

  const EditAccountWidget({
    this.title,
    this.value,
    this.onpressed,
    this.leading,
    this.nonmodify = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text(value, maxLines: 3, overflow: TextOverflow.ellipsis),
          leading: nonmodify ? null : leading,
          trailing: IconButton(
            icon: nonmodify ? Icon(Icons.content_copy) : Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: onpressed,
          ),
        ),
        nonmodify
            ? SizedBox(height: 10)
            : Divider(color: Colors.black, indent: 20, endIndent: 20),
      ],
    );
  }
}