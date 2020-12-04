import 'package:doctor/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 7,
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        shrinkWrap: true,
        children: [
          SwitchListTile(
            title: Text('Dark mode'),
            subtitle: Text('Change app view'),
            value: isSwitched,
            activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
            activeColor: Theme.of(context).primaryColor,
            inactiveThumbColor: Colors.black,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
            },
          ),
          Divider(color: Colors.black, endIndent: 20, indent: 10),
          CustomTile(title: 'FAQ', iconData: Icons.help),
          Divider(color: Colors.black, endIndent: 20, indent: 10),
          CustomTile(title: 'Contact us', iconData: Icons.people),
          Divider(color: Colors.black, endIndent: 20, indent: 10),
          CustomTile(title: 'Privacy policy', iconData: Icons.privacy_tip),
          Divider(color: Colors.black, endIndent: 20, indent: 10),
          CustomTile(title: 'App info', iconData: Icons.info)
        ],
      ),
    );
  }
}
