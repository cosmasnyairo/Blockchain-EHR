import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:patient/models/block.dart';

import 'custom_text.dart';

class RecordDetailCard extends StatefulWidget {
  Block block;
  int index;
  RecordDetailCard(this.block, this.index);
  @override
  _RecordDetailCardState createState() => _RecordDetailCardState();
}

class _RecordDetailCardState extends State<RecordDetailCard> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final f = DateFormat.yMd().add_jm();
    var date = f.format(
      DateTime.fromMillisecondsSinceEpoch(
        double.parse(widget.block.timestamp).toInt() * 1000,
      ),
    );
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: _expanded ? deviceheight * 0.3 : deviceheight * 0.15,
      child: Card(
        margin: EdgeInsets.all(10),
        elevation: 7,
        child: Column(
          children: [
            ListTile(
              title: CustomText(
                'Record (${widget.index})',
                fontsize: 16,
              ),
              subtitle: CustomText('$date'),
              trailing: IconButton(
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              padding: EdgeInsets.all(15),
              height: _expanded ? deviceheight * 0.15 : 0,
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (ctx, i) => ListTile(
                  title: CustomText('View this transaction'),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.navigate_next,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        'view_transaction',
                        arguments: widget.block.transaction[i],
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      'view_transaction',
                      arguments: widget.block.transaction[i],
                    );
                  },
                ),
                itemCount: widget.block.transaction.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
