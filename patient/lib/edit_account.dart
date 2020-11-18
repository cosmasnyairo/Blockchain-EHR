import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:patient/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'widgets/alert_dialog.dart';
import 'widgets/custom_button.dart';

class EditAccount extends StatefulWidget {
  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final _formkey = GlobalKey<FormState>();
  var editdetails = false;
  var _isLoading = false;
  Map<String, String> _doctorData;

  Future<void> _submit() async {
    if (!_formkey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formkey.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<UserAuthProvider>(context, listen: false).editdetails(
        name: _doctorData['name'],
        email: _doctorData['email'],
        doctorid: _doctorData['doctorid'],
        hospital: _doctorData['hospital'],
        location: _doctorData['location'],
      );
      throw 'True';
    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => CustomAlertDialog(
          message: e == 'True' ? 'Succesfully edited details' : e.toString(),
          success: e == 'True' ? true : false,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final DocumentSnapshot snapshot = ModalRoute.of(context).settings.arguments;

    _doctorData = {
      'name': snapshot['name'],
      'email': snapshot['email'],
      'location': snapshot['location'],
    };

    final format = DateFormat.yMd().add_jm();

    return Scaffold(
      appBar: AppBar(
        title: Text(editdetails ? 'Edit Details' : 'My Details'),
        actions: [
          IconButton(
              icon: editdetails ? Icon(Icons.cancel) : Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  editdetails = !editdetails;
                });
              })
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: deviceheight,
              child: ListView(
                padding: EdgeInsets.all(20),
                shrinkWrap: true,
                children: [
                  editdetails
                      ? Form(
                          key: _formkey,
                          child: ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              SizedBox(height: 20),
                              TextFormField(
                                initialValue:
                                    '${_doctorData['name'][0].toUpperCase()}${_doctorData['name'].substring(1)}',
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(
                                    Icons.person,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  labelText: 'Name',
                                ),
                                textInputAction: TextInputAction.go,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Name can\'t be empty!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _doctorData['name'] = value.trim();
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                initialValue:
                                    _doctorData['email'].toLowerCase(),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(
                                    Icons.email,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  labelText: 'Email',
                                ),
                                textInputAction: TextInputAction.go,
                                validator: (value) {
                                  if (value.trim().isEmpty ||
                                      !value.trim().contains('@') ||
                                      !value.trim().endsWith('com')) {
                                    return 'Invalid email!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _doctorData['email'] = value.trim();
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                initialValue: _doctorData['location'],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(
                                    Icons.location_on,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  labelText: 'Location',
                                ),
                                textInputAction: TextInputAction.go,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Location can\'t be empty!';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _doctorData['location'] = value.trim();
                                },
                              ),
                              SizedBox(height: 20),
                              Center(
                                child: CustomButton(
                                  'Save',
                                  _submit,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          children: [
                            AccountTile(
                              leading: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: 'Name',
                              value:
                                  '${snapshot['name'][0].toUpperCase()}${snapshot['name'].substring(1)}',
                            ),
                            AccountTile(
                              leading: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: 'Email',
                              value: snapshot['email'].toLowerCase(),
                            ),
                            AccountTile(
                              leading: Icon(
                                Icons.location_on,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: 'Location',
                              value: snapshot['location'],
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.info,
                                color: Theme.of(context).accentColor,
                              ),
                              title: Text('Below Details cannot be modified.'),
                              subtitle:
                                  Text('Contact us to modify them for you'),
                            ),
                            SizedBox(height: 10),
                            ListTile(
                              title: Text('Public Key'),
                              subtitle: Text(
                                snapshot['publickey'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.content_copy,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: snapshot['publickey'],
                                    ),
                                  );
                                },
                              ),
                            ),
                            ListTile(
                              title: Text('Private Key'),
                              subtitle: Text(
                                snapshot['privatekey'],
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.content_copy,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: snapshot['privatekey'],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: 20),
                  Text(
                    'Join Date: ${format.format(DateTime.parse(snapshot['joindate']))}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}

class AccountTile extends StatelessWidget {
  final String title;
  final String value;
  final Icon leading;

  const AccountTile({this.title, this.value, this.leading});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: Text(value),
          leading: leading,
        ),
        Divider(color: Colors.black, indent: 20, endIndent: 20),
      ],
    );
  }
}
