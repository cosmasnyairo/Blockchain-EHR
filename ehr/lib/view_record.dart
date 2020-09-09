import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/custom_card.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text.dart';

class ViewRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final index = ModalRoute.of(context).settings.arguments;
    final String key =
        '30819f300d06092a864886f70d010101050003818d0030818902818100abfa47e43eaa9a6ce6fb5ea585d234ab517af6df8d9ed56c1387436cbfce6c25bfc6956b569a97a6f9f00deca5222d1d9f0201f3c8bfd19b129f507f1383ad4536e6f5847eeff8f9657850f79d09fc7bdc1e2ad0af1fd35d049fec9b5c8c6572e2f1f8387b8725358680163d1da86ff5d9a7b9e66c8791ecc0ed7a1cfb17bcb70203010001';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('EHR RECORD'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              'Dr. Xavier',
              fontweight: FontWeight.bold,
              fontsize: 20,
            ),
            CustomText(
              'Doctor\'s Key',
              fontsize: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: width * 0.6,
                  height: 40,
                  child: CustomText(
                    key,
                    alignment: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CustomButton(
                  'Copy',
                  () {
                    Clipboard.setData(
                      ClipboardData(text: key.toString()),
                    );
                    // to do : add snackbar
                    print('copied');
                  },
                  height: 40,
                )
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  CustomCard(
                    title: 'MEDICAL NOTES',
                    data: 'data',
                  ),
                  SizedBox(height: 10),
                  CustomCard(
                    title: 'LAB RESULTS',
                    data: 'data',
                  ),
                  SizedBox(height: 10),
                  CustomCard(
                    title: 'PRESCRIPTION',
                    data: 'data',
                  ),
                  SizedBox(height: 10),
                  CustomCard(
                    title: 'DIAGNOSIS',
                    data: 'data',
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
