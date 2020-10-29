import 'package:flutter/material.dart';

import '../models/transaction.dart';

import 'custom_card.dart';
import 'custom_text.dart';

class VisitDetails extends StatefulWidget {
  @override
  _VisitDetailsState createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails> {
  @override
  Widget build(BuildContext context) {
    Transaction transaction = ModalRoute.of(context).settings.arguments;
    final deviceheight = MediaQuery.of(context).size.height;
    List medicalNotes = [];
    List labResults = [];
    List prescription = [];
    List diagnosis = [];
    for (var item in transaction.details) {
      medicalNotes = item.medicalnotes;
      diagnosis = item.diagnosis;
      prescription = item.prescription;
      labResults = item.labresults;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('Health Record'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: deviceheight,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: CustomText('Doctor: Doctor'),
              leading: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: CustomText('Patient: Patient'),
              leading: Icon(
                Icons.person_outline,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            CustomText('Medical Notes', fontweight: FontWeight.bold),
            SizedBox(height: 10),
            CustomCard(medicalNotes, Icons.assignment),
            SizedBox(height: 10),
            CustomText('Lab Results', fontweight: FontWeight.bold),
            SizedBox(height: 10),
            CustomCard(labResults, Icons.format_list_bulleted),
            SizedBox(height: 10),
            CustomText('Prescription', fontweight: FontWeight.bold),
            SizedBox(height: 10),
            CustomCard(prescription, Icons.grain),
            SizedBox(height: 10),
            CustomText('Diagnosis', fontweight: FontWeight.bold),
            SizedBox(height: 10),
            CustomCard(diagnosis, Icons.format_align_center),
          ],
        ),
      ),
    );
  }
}
