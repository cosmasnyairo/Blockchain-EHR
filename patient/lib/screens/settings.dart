import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/customtheme.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_tile.dart';
import 'landingpage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isloading = false;

  void logout() async {
    setState(() {
      _isloading = true;
    });

    await Provider.of<UserAuthProvider>(context, listen: false).logout();
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
    final deviceheight = MediaQuery.of(context).size.height;
    final theme = Provider.of<CustomThemeProvider>(context, listen: false);

    return _isloading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(title: Text('Settings')),
            body: Container(
              height: deviceheight,
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    child: SwitchListTile(
                      title: Text('Theme'),
                      subtitle: Text('Change app view'),
                      isThreeLine: true,
                      value: theme.darkthemechosen,
                      activeTrackColor:
                          Theme.of(context).accentColor.withOpacity(0.5),
                      activeColor: Theme.of(context).accentColor,
                      inactiveThumbColor: Colors.white,
                      onChanged: (value) {
                        setState(() {
                          _isloading = true;
                        });

                        theme.setTheme(value);
                        setState(() {
                          _isloading = false;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: CustomTile(
                      title: 'Contact us',
                      subtitle: 'Have an issue?',
                      isthreeline: true,
                      iconData: Icons.people,
                      onpressed: () async {
                        await showDialog(
                          context: context,
                          builder: (ctx) => CustomAlertDialog(
                            message: 'Coming soon!',
                            success: true,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: CustomTile(
                      title: 'Open Source Libraries',
                      subtitle: 'View licences used in the app',
                      isthreeline: true,
                      iconData: Icons.code,
                      onpressed: () {
                        Navigator.of(context).pushNamed('libraries_used');
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Card(
                    child: CustomTile(
                      title: 'Sign out',
                      subtitle: 'Sign out from your account',
                      isthreeline: true,
                      iconData: Icons.exit_to_app,
                      onpressed: logout,
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                  Spacer(),
                  CustomText(
                    'Ehr Kenya: Version 1.0',
                    fontsize: 15,
                  ),
                ],
              ),
            ),
          );
  }
}
