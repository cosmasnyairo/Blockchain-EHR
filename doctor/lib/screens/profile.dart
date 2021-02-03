import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/widgets/custom_floating_action_button.dart';
import 'package:doctor/widgets/custom_text.dart';
import 'package:doctor/widgets/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_tile.dart';
import 'landingpage.dart';

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

  void logout() async {
    setState(() {
      _isloading = true;
    });

    await Provider.of<DoctorAuthProvider>(context, listen: false).logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LandingPage()),
      (route) => false,
    ).then((_) {
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DoctorAuthProvider>(context, listen: false);

    final deviceheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: _isloading
          ? Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              appBar: AppBar(title: CustomText('Profile')),
              body: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Doctors')
                    .doc(provider.userid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorPage();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Container(
                    height: deviceheight,
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(20),
                      children: [
                        Container(
                          height: deviceheight * 0.15,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            image: DecorationImage(
                              image: AssetImage(
                                snapshot.data['gender'] == "Male"
                                    ? 'assets/male_avatar.png'
                                    : 'assets/female_avatar.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(height: deviceheight * 0.025),
                        CustomText(
                          snapshot.data['name'],
                          fontweight: FontWeight.bold,
                          fontsize: 18,
                          alignment: TextAlign.center,
                        ),
                        SizedBox(height: deviceheight * 0.0125),
                        CustomText(
                          'Joined on ${DateFormat.yMMMMd().format(DateTime.parse(snapshot.data['joindate']))}',
                          alignment: TextAlign.center,
                        ),
                        SizedBox(height: deviceheight * 0.025),
                        Card(
                          elevation: 8,
                          child: CustomTile(
                            leadingiconData: Icons.person,
                            title: 'Account',
                            subtitle: 'View acccount information ',
                            iconData: Icons.navigate_next,
                            isthreeline: true,
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
                        ),
                        SizedBox(height: deviceheight * 0.025),
                        Card(
                          elevation: 8,
                          child: CustomTile(
                            title: 'Ehr Information',
                            iconData: Icons.navigate_next,
                            subtitle: 'View your keys and peer node',
                            leadingiconData: Icons.info,
                            isthreeline: true,
                            onpressed: () {
                              Navigator.of(context)
                                  .pushNamed('ehr_information', arguments: {
                                'publickey': snapshot.data['publickey'],
                                'privatekey': snapshot.data['privatekey'],
                                'peer_node': snapshot.data['peer_node'],
                              });
                            },
                          ),
                        ),
                        SizedBox(height: deviceheight * 0.025),
                        Card(
                          elevation: 8,
                          child: CustomTile(
                            title: 'Settings',
                            subtitle: 'View app settings',
                            leadingiconData: Icons.settings,
                            isthreeline: true,
                            iconData: Icons.navigate_next,
                            onpressed: () {
                              Navigator.of(context).pushNamed('settings_page');
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              floatingActionButton: CustomFAB(
                'Logout',
                Icons.exit_to_app,
                logout,
                color: Theme.of(context).accentColor,
              ),
            ),
    );
  }
}
