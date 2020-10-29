import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomCard extends StatelessWidget {
  final List details;
  final IconData icon;

  CustomCard(this.details, this.icon);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 7,
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (ctx, i) => ListTile(
            leading: Icon(icon, color: Theme.of(context).primaryColor),
            title: CustomText('${details[i]}'),
          ),
          itemCount: details.length,
        ),
      ),
    );
  }
}
