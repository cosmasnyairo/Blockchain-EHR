import 'package:doctor/models/user.dart';
import 'package:doctor/providers/userauth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_text.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _isloading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<UserAuthProvider>(context, listen: false)
          .fetchuserdata()
          .then((value) {
        setState(() {
          _isloading = false;
        });
      });
    }
    super.didChangeDependencies();
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    EhrUser ehruser = Provider.of<UserAuthProvider>(context).user;
    return _isloading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            body:
                Center(child: CustomText('${ehruser.name.toString()} profile')),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _isloading = true;
                });
                Provider.of<UserAuthProvider>(context, listen: false).logout();
                setState(() {
                  _isloading = false;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              label: Text('Logout'),
              icon: Icon(
                Icons.exit_to_app,
              ),
            ),
          );
  }
}
