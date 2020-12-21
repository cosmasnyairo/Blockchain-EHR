import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/providers/auth_provider.dart';
import 'package:doctor/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
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
    DocumentReference doctors = FirebaseFirestore.instance
        .collection('Doctors')
        .doc(Provider.of<DoctorAuthProvider>(context).userid);

    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: doctors.snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            height: deviceheight,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Container(
                  height: deviceheight * 0.33,
                  child: Image.asset(
                    'assets/doctor.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Hello, ${snapshot.data['name'][0].toUpperCase()}${snapshot.data['name'].substring(1)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                CustomTile(
                  title: 'Account',
                  subtitle: 'Update your profile',
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
                    Provider.of<DoctorAuthProvider>(context, listen: false)
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
