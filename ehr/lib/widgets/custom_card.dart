import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final String data;

  CustomCard({this.data, this.title});

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: _expanded ? 300 : 100,
      child: Card(
        elevation: 7,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              title: CustomText(
                widget.title,
                fontweight: FontWeight.bold,
              ),
              trailing: _expanded
                  ? Container(
                      width: 100,
                      child: Row(
                        children: [
                          CustomText('Hide', fontweight: FontWeight.bold),
                          IconButton(
                            icon: Icon(Icons.expand_less),
                            color: Theme.of(context).primaryColor,
                            iconSize: 35,
                            onPressed: () {
                              setState(() {
                                _expanded = !_expanded;
                              });
                            },
                          )
                        ],
                      ),
                    )
                  : Container(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText('View', fontweight: FontWeight.bold),
                          IconButton(
                            icon: Icon(Icons.expand_more),
                            color: Theme.of(context).primaryColor,
                            iconSize: 35,
                            onPressed: () {
                              setState(() {
                                _expanded = !_expanded;
                              });
                            },
                          )
                        ],
                      ),
                    ),
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: _expanded ? 200 : 0,
              child: CustomText(widget.data),
            ),
          ],
        ),
      ),
    );
  }
}
