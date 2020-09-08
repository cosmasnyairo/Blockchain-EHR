import 'package:ehr/widgets/custom_button.dart';
import 'package:ehr/widgets/custom_text.dart';
import 'package:ehr/widgets/record.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              'Welcome,',
              color: Colors.black54,
              fontsize: 20,
            ),
            CustomText(
              'Kenneth Erickson',
              fontsize: 20,
              fontweight: FontWeight.bold,
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomButton('ADD RECORD', () {}),
                CustomButton('SHARE RECORDS', () {})
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.calendar_today),
                CustomText('Dates', fontweight: FontWeight.bold)
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 180,
                  child: Card(
                    elevation: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomText('17/07/2017'),
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: null,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 180,
                  child: Card(
                    elevation: 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomText('23/07/2017'),
                        IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: null,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomText('RECORDS', fontweight: FontWeight.bold),
            SizedBox(height: 10),
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemBuilder: (ctx, i) => RecordCard(),
                  itemCount: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
