import 'package:ehr/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class RecordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      height: h * 0.3,
      width: w,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 7,
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.apps),
                CustomText(
                  'EHR Record',
                  fontsize: 20,
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    'Summary of your visit:',
                    fontweight: FontWeight.bold,
                    fontsize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            'Location: Nairobi',
                            fontsize: 16,
                          ),
                          CustomText(
                            'Doctor: Dr Xavier',
                            fontsize: 16,
                          ),
                          CustomText(
                            'Date: Dr Xavier',
                            fontsize: 16,
                          ),
                        ],
                      ),
                      CustomButton(
                        'VIEW RECORD',
                        () {},
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
