import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomCard extends StatelessWidget {
  final List details;
  final IconData icon;

  CustomCard(this.details, this.icon);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: ListView.separated(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (ctx, i) => ListTile(
          leading: Icon(icon, color: Theme.of(context).primaryColor),
          title: CustomText('${details[i]}'),
        ),
        padding: EdgeInsets.all(10),
        itemCount: details.length,
      ),
    );
  }
}
