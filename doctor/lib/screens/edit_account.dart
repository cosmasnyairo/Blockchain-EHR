import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_tile.dart';

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
      return;
    }
    _formkey.currentState.save();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<DoctorAuthProvider>(context, listen: false).editdetails(
        name: _doctorData['name'],
        email: _doctorData['email'],
        doctorid: _doctorData['doctorid'],
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop('Profile Updated');
    } catch (e) {}
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DocumentSnapshot snapshot = ModalRoute.of(context).settings.arguments;
    _doctorData = {
      'name': snapshot['name'],
      'email': snapshot['email'],
      'doctorid': snapshot['doctorid'],
    };
    return _isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
              title: Text(editdetails ? 'Edit Details' : 'My Details'),
              actions: [
                IconButton(
                  icon: editdetails ? Icon(Icons.cancel) : Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      editdetails = !editdetails;
                    });
                  },
                )
              ],
            ),
            body: editdetails
                ? Form(
                    key: _formkey,
                    child: ListView(
                      padding: EdgeInsets.all(30),
                      shrinkWrap: true,
                      children: [
                        CustomFormField(
                          initialvalue:
                              '${_doctorData['name'][0].toUpperCase()}${_doctorData['name'].substring(1)}',
                          icondata: Icons.person,
                          labeltext: 'Name',
                          textInputAction: TextInputAction.go,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Name can\'t be empty!';
                            }
                            return null;
                          },
                          onsaved: (value) {
                            _doctorData['name'] = value.trim();
                          },
                        ),
                        SizedBox(height: 20),
                        CustomFormField(
                          initialvalue: _doctorData['email'].toLowerCase(),
                          icondata: Icons.email,
                          labeltext: 'Email',
                          textInputAction: TextInputAction.go,
                          validator: (value) {
                            if (value.trim().isEmpty ||
                                !value.trim().contains('@') ||
                                !value.trim().endsWith('com')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                          onsaved: (value) {
                            _doctorData['email'] = value.trim();
                          },
                        ),
                        SizedBox(height: 20),
                        CustomFormField(
                          initialvalue: _doctorData['doctorid'],
                          icondata: Icons.assignment_ind,
                          labeltext: 'Doctor id',
                          textInputAction: TextInputAction.go,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Doctor id can\'t be empty!';
                            }
                            return null;
                          },
                          onsaved: (value) {
                            _doctorData['doctorid'] = value.trim();
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(20),
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: [
                      CustomTile(
                        title: 'Name',
                        subtitle:
                            '${snapshot['name'][0].toUpperCase()}${snapshot['name'].substring(1)}',
                        leadingiconData: Icons.person,
                      ),
                      Divider(),
                      CustomTile(
                        title: 'Email',
                        subtitle: snapshot['email'].toLowerCase(),
                        leadingiconData: Icons.email,
                      ),
                      Divider(),
                      CustomTile(
                        title: 'Doctor id',
                        subtitle: snapshot['doctorid'],
                        leadingiconData: Icons.assignment_ind,
                      ),
                      Divider(),
                    ],
                  ),
            floatingActionButton: editdetails
                ? FloatingActionButton.extended(
                    label: Text('Save Changes'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: _submit,
                    icon: Icon(
                      Icons.save,
                    ),
                  )
                : null,
          );
  }
}
