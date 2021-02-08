import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/customtheme.dart';
import '../widgets/custom_text.dart';

class CustomTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onpressed;
  final bool isthreeline;
  final IconData iconData;
  final IconData leadingiconData;
  final bool expansion;
  final Widget expansionchildren;
  final Color color;

  final bool visit;
  final String label;
  final IconData visiticon;

  const CustomTile({
    this.title,
    this.subtitle,
    this.onpressed,
    this.isthreeline,
    this.iconData,
    this.leadingiconData,
    this.expansionchildren,
    this.expansion = false,
    this.visit = false,
    this.label,
    this.visiticon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeProvider>(context, listen: false);
    return expansion
        ? ExpansionTile(
            title: title == null ? null : Text(title),
            subtitle: subtitle == null ? null : Text(subtitle),
            children: [expansionchildren, SizedBox(height: 20)],
            leading: Icon(
              leadingiconData,
              color: theme.darkthemechosen
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor,
            ),
            trailing: Icon(
              iconData,
              color: theme.darkthemechosen
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor,
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
                    color: theme.darkthemechosen
                        ? Theme.of(context).accentColor
                        : Theme.of(context).primaryColor,
                  ),
            trailing: visit
                ? RaisedButton.icon(
                    label: CustomText(label),
                    icon: Icon(
                      visiticon,
                      color: theme.darkthemechosen
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).accentColor,
                    ),
                    onPressed: onpressed,
                  )
                : IconButton(
                    icon: Icon(
                      iconData,
                      color: color == null
                          ? theme.darkthemechosen
                              ? Theme.of(context).accentColor
                              : Theme.of(context).primaryColor
                          : color,
                    ),
                    onPressed: onpressed),
          );
  }
}
