import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _isloading = false;
  var _isInit = true;
  bool isSwitched = false;

  @override
  void didChangeDependencies() {
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
    final deviceheight = MediaQuery.of(context).size.height;
    return _isloading
        ? Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: Container(
              height: deviceheight,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Container(
                    height: deviceheight * 0.33,
                    child: Image.asset(
                      ehruser.gender == 'Male'
                          ? 'assets/male_patient.png'
                          : 'assets/female_patient.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Hello, ${ehruser.name}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text('Account'),
                    subtitle: Text('Update profile, public and private keys'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.navigate_next,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    endIndent: 20,
                    indent: 10,
                  ),
                  ListTile(
                    title: Text('Help'),
                    subtitle: Text('FAQ, Contact us, Privacy policy, Licenses'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.navigate_next,
                        color: Theme.of(context).primaryColor,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    endIndent: 20,
                    indent: 10,
                  ),
                  ListTile(
                    title: Text('Dark Mode'),
                    subtitle: Text('Change app view'),
                    trailing: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print(isSwitched);
                        });
                      },
                      activeTrackColor:
                          Theme.of(context).primaryColor.withOpacity(0.5),
                      activeColor: Theme.of(context).primaryColor,
                      inactiveThumbColor: Colors.black,
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    endIndent: 20,
                    indent: 10,
                  ),
                  ListTile(
                    title: Text('Logout'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.exit_to_app,
                        color: Theme.of(context).accentColor,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          _isloading = true;
                        });
                        Provider.of<UserAuthProvider>(context, listen: false)
                            .logout();
                        setState(() {
                          _isloading = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
