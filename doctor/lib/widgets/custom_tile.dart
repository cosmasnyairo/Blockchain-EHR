import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onpressed;
  final bool isthreeline;
  final IconData iconData;
  final IconData leadingiconData;
  final Color iconcolor;
  final bool expansion;
  final Widget expansionchildren;
  const CustomTile({
    this.title,
    this.subtitle,
    this.onpressed,
    this.isthreeline,
    this.iconData,
    this.iconcolor,
    this.leadingiconData,
    this.expansionchildren,
    this.expansion = false,
  });
  @override
  Widget build(BuildContext context) {
    return expansion
        ? ExpansionTile(
            title: title == null ? null : Text(title),
            subtitle: subtitle == null ? null : Text(subtitle),
            children: [expansionchildren, SizedBox(height: 20)],
            leading: Icon(
              leadingiconData,
              color: Theme.of(context).primaryColor,
              size: 25,
            ),
            trailing: Icon(
              iconData,
              color: Theme.of(context).primaryColor,
              size: 25,
            ),
          )
        : ListTile(
            title: title == null ? null : Text(title),
            subtitle: subtitle == null ? null : Text(subtitle),
            onTap: onpressed,
            isThreeLine: isthreeline == null ? false : isthreeline,
            leading: leadingiconData == null
                ? null
                : Icon(
                    leadingiconData,
                    color: iconcolor == null
                        ? Theme.of(context).primaryColor
                        : iconcolor,
                    size: 25,
                  ),
            trailing: IconButton(
              icon: Icon(
                iconData,
                color: iconcolor == null
                    ? Theme.of(context).primaryColor
                    : iconcolor,
                size: 25,
              ),
              onPressed: onpressed,
            ),
          );
  }
}
