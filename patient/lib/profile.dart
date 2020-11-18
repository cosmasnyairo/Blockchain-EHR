import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _isloading = false;
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    DocumentReference users = FirebaseFirestore.instance
        .collection('Users')
        .doc(Provider.of<UserAuthProvider>(context).userid);

    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: users.snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("Loading"));
                }
                return Container(
                  height: deviceheight,
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      Container(
                        height: deviceheight * 0.33,
                        child: Image.asset(
                          snapshot.data['gender'] == 'Male'
                              ? 'assets/male_patient.png'
                              : 'assets/female_patient.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Hello, ${snapshot.data['name']}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        title: Text('Account'),
                        subtitle:
                            Text('Update profile, public and private keys'),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.navigate_next,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushNamed('edit_account',
                                arguments: snapshot.data);
                          },
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed('edit_account',
                              arguments: snapshot.data);
                        },
                      ),
                      Divider(
                        color: Colors.black,
                        endIndent: 20,
                        indent: 10,
                      ),
                      ListTile(
                        title: Text('Help'),
                        subtitle:
                            Text('FAQ, Contact us, Privacy policy, Licenses'),
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
                            Provider.of<UserAuthProvider>(context,
                                    listen: false)
                                .logout();
                            setState(() {
                              _isloading = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
