import 'package:ehr/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_button.dart';
import 'custom_card.dart';
import 'custom_text.dart';

class ViewTransaction extends StatefulWidget {
  @override
  _ViewTransactionState createState() => _ViewTransactionState();
}

class _ViewTransactionState extends State<ViewTransaction> {
  @override
  Widget build(BuildContext context) {
    Transaction transaction = ModalRoute.of(context).settings.arguments;
    final width = MediaQuery.of(context).size.width;
    List medicalNotes;
    List labResults;
    List prescription;
    List diagnosis;
    for (var item in transaction.details) {
      medicalNotes = item.medicalnotes;
      diagnosis = item.diagnosis;
      prescription = item.prescription;
      labResults = item.labresults;
    }
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
            SizedBox(height: 10),
            CustomText(
              'Doctor\'s Key:',
              fontsize: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(border: Border.all()),
                  padding: EdgeInsets.all(5),
                  width: width * 0.6,
                  height: 40,
                  child: CustomText(
                    transaction.receiver.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                CustomButton(
                  'Copy',
                  () {
                    Clipboard.setData(
                      ClipboardData(text: transaction.receiver.toString()),
                    );
                    // to do : add snackbar
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
                    details: medicalNotes,
                  ),
                  SizedBox(height: 10),
                  CustomCard(
                    title: 'LAB RESULTS',
                    details: labResults,
                  ),
                  SizedBox(height: 10),
                  CustomCard(
                    title: 'PRESCRIPTION',
                    details: prescription,
                  ),
                  SizedBox(height: 10),
                  CustomCard(
                    title: 'DIAGNOSIS',
                    details: diagnosis,
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
