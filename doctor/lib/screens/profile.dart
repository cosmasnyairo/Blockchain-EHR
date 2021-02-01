import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_tile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isloading = false;
  void showSnackBarMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: CustomText(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DoctorAuthProvider>(context, listen: false);

    final deviceheight = MediaQuery.of(context).size.height;
    return _isloading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(title: CustomText('Profile')),
            body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Doctors')
                  .doc(Provider.of<DoctorAuthProvider>(context).userid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: CustomText('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // provider.fetchdoctordetails(snapshot.data);
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
                      SizedBox(height: 5),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 8,
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(10),
                          physics: ClampingScrollPhysics(),
                          children: [
                            SizedBox(height: 5),
                            CustomText(
                              'Hello, ${snapshot.data['name'][0].toUpperCase()}${snapshot.data['name'].substring(1)}',
                              alignment: TextAlign.center,
                              fontsize: 20,
                              fontweight: FontWeight.bold,
                            ),
                            SizedBox(height: 10),
                            CustomTile(
                              leadingiconData: Icons.person,
                              title: 'Account',
                              subtitle: 'Update your profile',
                              iconData: Icons.navigate_next,
                              onpressed: () {
                                Navigator.of(context)
                                    .pushNamed('edit_account',
                                        arguments: snapshot.data)
                                    .then(
                                      (value) => {
                                        if (value != null)
                                          {showSnackBarMessage(value)}
                                      },
                                    );
                              },
                            ),
                            Divider(
                                color: Colors.grey, endIndent: 20, indent: 10),
                            CustomTile(
                              title: 'Ehr Information',
                              iconData: Icons.navigate_next,
                              leadingiconData: Icons.info,
                              onpressed: () {
                                Navigator.of(context)
                                    .pushNamed('ehr_information', arguments: {
                                  'publickey': snapshot.data['publickey'],
                                  'privatekey': snapshot.data['privatekey'],
                                  'peer_node': snapshot.data['peer_node'],
                                });
                              },
                            ),
                            Divider(
                                color: Colors.grey, endIndent: 20, indent: 10),
                            CustomTile(
                              title: 'Settings',
                              subtitle: 'Explore app settings',
                              leadingiconData: Icons.settings,
                              iconData: Icons.navigate_next,
                              onpressed: () {
                                Navigator.of(context)
                                    .pushNamed('settings_page');
                              },
                            ),
                            Divider(
                                color: Colors.grey, endIndent: 20, indent: 10),
                            CustomTile(
                              title: 'Logout',
                              subtitle: 'Logout from your account',
                              iconData: Icons.navigate_next,
                              leadingiconData: Icons.exit_to_app,
                              onpressed: () async {
                                setState(() {
                                  _isloading = true;
                                });
                                await provider.logout();
                                setState(() {
                                  _isloading = false;
                                });
                              },
                              iconcolor: Theme.of(context).accentColor,
                            ),
                          ],
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
