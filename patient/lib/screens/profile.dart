import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient/providers/auth_provider.dart';
import 'package:patient/screens/landingpage.dart';
import 'package:patient/widgets/custom_floating_action_button.dart';
import 'package:patient/widgets/custom_tile.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_text.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void showSnackBarMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: CustomText(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: CustomText('Profile')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(Provider.of<UserAuthProvider>(context, listen: false).userid)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: CustomText('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomText("Loading"));
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
                SizedBox(height: deviceheight * 0.05),
                Card(
                  child: CustomTile(
                    leadingiconData: Icons.person,
                    title: 'Account',
                    subtitle: 'View acccount information ',
                    iconData: Icons.navigate_next,
                    isthreeline: true,
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
                ),
                SizedBox(height: deviceheight * 0.025),
                Card(
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
    );
  }
}
