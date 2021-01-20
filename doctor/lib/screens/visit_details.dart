import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../models/transaction.dart' as UserTransaction;
import '../widgets/custom_text.dart';
import '../widgets/custom_tile.dart';

class VisitDetails extends StatefulWidget {
  final UserTransaction.Transaction transaction;
  VisitDetails(this.transaction);
  @override
  _VisitDetailsState createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;
  String patientemail, patientname;
  List medicalNotes, labResults, prescription, diagnosis = [];

  var _isloading = false;

  List<Widget> widgetlist = [
    Column(
      children: [
        Icon(Icons.assignment, size: 30),
        CustomText('Medical Notes', fontsize: 11),
        SizedBox(height: 5),
      ],
    ),
    Column(
      children: [
        Icon(Icons.search, size: 30),
        CustomText('Lab Results', fontsize: 11),
        SizedBox(height: 5),
      ],
    ),
    Column(
      children: [
        Icon(Icons.analytics, size: 30),
        CustomText('Diagnosis', fontsize: 11),
        SizedBox(height: 5),
      ],
    ),
    Column(
      children: [
        Icon(Icons.healing, size: 30),
        CustomText('Prescription', fontsize: 11),
        SizedBox(height: 5),
      ],
    ),
  ];

  @override
  void initState() {
    fetchpatientdetails();
    _controller = TabController(length: widgetlist.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
    super.initState();
  }

  Future<void> fetchpatientdetails() async {
    setState(() {
      _isloading = true;
    });
    Query query = FirebaseFirestore.instance
        .collection('Users')
        .where("publickey", isEqualTo: widget.transaction.receiver);

    await query.get().then((f) {
      patientname = f.docs[0]['name'];
      patientemail = f.docs[0]['email'];
    });

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;

    for (var item in widget.transaction.details) {
      medicalNotes = item.medicalnotes;
      diagnosis = item.diagnosis;
      prescription = item.prescription;
      labResults = item.labresults;
    }

    var formatted = [];
    prescription.forEach((f) {
      formatted.add('${f[0].trim()}  ${f[1]} x ${f[2]}');
    });
    prescription = formatted;

    return Scaffold(
      appBar: AppBar(
        title: CustomText('Health Record'),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: deviceheight,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Card(
                    elevation: 4,
                    child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        SizedBox(height: 10),
                        CustomTile(
                          leadingiconData: Icons.person,
                          title: 'Patient',
                          subtitle: '$patientname',
                        ),
                        CustomTile(
                          leadingiconData: Icons.email,
                          title: 'Email',
                          subtitle: '$patientemail',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomText(
                    'Tap the icons below to view health record details',
                    fontsize: 14,
                    color: Colors.grey,
                    alignment: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TabBar(
                    indicatorWeight: 3,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.all(5),
                    indicatorColor: Theme.of(context).accentColor,
                    onTap: (index) {},
                    controller: _controller,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: widgetlist,
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: deviceheight * 0.4,
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        ehrDetails(medicalNotes, Icons.assignment),
                        ehrDetails(labResults, Icons.search),
                        ehrDetails(diagnosis, Icons.analytics),
                        ehrDetails(prescription, Icons.healing),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  ListView ehrDetails(List ehrdetailslist, IconData iconData) {
    return ListView(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomText(
          'Swipe to navigate between health record details',
          fontsize: 12,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
          alignment: TextAlign.center,
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: ehrdetailslist.length,
          itemBuilder: (ctx, i) => CustomTile(
            leadingiconData: iconData,
            title: ehrdetailslist[i].toString(),
          ),
        ),
      ],
    );
  }
}
