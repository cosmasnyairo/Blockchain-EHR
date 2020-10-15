import 'package:flutter/material.dart';

import 'custom_button.dart';
import 'custom_text.dart';
import '../models/node.dart';

class DismissibleNode extends StatelessWidget {
  final String id;
  final Node node;

  const DismissibleNode({this.node, this.id});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        print('removed');
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      child: Card(
        elevation: 7,
        child: ListTile(
          title: CustomText(
            'Node ${node.node}',
            fontweight: FontWeight.bold,
            fontsize: 16,
          ),
          subtitle: CustomText('Node public key'),
          contentPadding: EdgeInsets.all(10),
          trailing: Container(
            width: 100,
            child: IconButton(
              icon: Icon(
                Icons.share,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              onPressed: () {},
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
