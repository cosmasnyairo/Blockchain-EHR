import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onpressed;
  final bool isthreeline;
  final IconData iconData;
  final IconData leadingiconData;
  final Color iconcolor;

  const CustomTile({
    this.title,
    this.subtitle,
    this.onpressed,
    this.isthreeline,
    this.iconData,
    this.iconcolor,
    this.leadingiconData,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
          color: iconcolor == null ? Theme.of(context).primaryColor : iconcolor,
          size: 25,
        ),
        onPressed: onpressed,
      ),
    );
  }
}
