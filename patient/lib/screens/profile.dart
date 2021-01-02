import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient/providers/auth_provider.dart';
import 'package:patient/widgets/custom_tile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void showSnackBarMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(message),
      ),
    );
  }

  var _isloading = false;

  @override
  Widget build(BuildContext context) {
    DocumentReference users = FirebaseFirestore.instance
        .collection('Users')
        .doc(Provider.of<UserAuthProvider>(context).userid);

    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: StreamBuilder<DocumentSnapshot>(
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
                    'Hello, ${snapshot.data['name'][0].toUpperCase()}${snapshot.data['name'].substring(1)}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
                CustomTile(
                  title: 'Account',
                  subtitle: 'Update profile, public and private keys',
                  iconData: Icons.navigate_next,
                  onpressed: () {
                    Navigator.of(context)
                        .pushNamed('edit_account', arguments: snapshot.data)
                        .then(
                          (value) => {
                            if (value != null) {showSnackBarMessage(value)}
                          },
                        );
                  },
                ),
                Divider(color: Colors.black, endIndent: 20, indent: 10),
                CustomTile(
                  title: 'Ehr keys',
                  subtitle: 'View your public and private keys',
                  iconData: Icons.navigate_next,
                  onpressed: () {
                    Navigator.of(context).pushNamed('view_keys', arguments: {
                      'publickey': snapshot.data['publickey'],
                      'privatekey': snapshot.data['privatekey'],
                    });
                  },
                ),
                Divider(color: Colors.black, endIndent: 20, indent: 10),
                CustomTile(
                  title: 'Settings',
                  subtitle: 'Explore app settings',
                  iconData: Icons.navigate_next,
                  onpressed: () {
                    Navigator.of(context).pushNamed('settings_page');
                  },
                ),
                Divider(color: Colors.black, endIndent: 20, indent: 10),
                CustomTile(
                  title: 'Logout',
                  iconData: Icons.exit_to_app,
                  onpressed: () {
                    setState(() {
                      _isloading = true;
                    });
                    Provider.of<UserAuthProvider>(context, listen: false)
                        .logout();
                    setState(() {
                      _isloading = false;
                    });
                  },
                  iconcolor: Theme.of(context).accentColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
