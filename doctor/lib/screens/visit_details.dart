import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart' as UserTransaction;
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_tile.dart';

class VisitDetails extends StatefulWidget {
  final UserTransaction.Transaction transaction;
  final bool isavisit;
  VisitDetails(this.transaction, this.isavisit);
  @override
  _VisitDetailsState createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;
  String patientemail, patientname;
  String doctoremail, doctorname;
  List medicalNotes, labResults, prescription = [];

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
        Icon(Icons.science, size: 30),
        CustomText('Lab Results', fontsize: 11),
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
    if (widget.isavisit == true) {
      fetchdoctordetails();
    } else {
      fetchpatientdetails();
    }
    _controller = TabController(length: widgetlist.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
    super.initState();
  }

  Future<void> fetchdoctordetails() async {
    setState(() {
      _isloading = true;
    });
    Query query = FirebaseFirestore.instance
        .collection('Doctors')
        .where("publickey", isEqualTo: widget.transaction.sender);

    await query.get().then((f) {
      doctorname = f.docs[0]['name'];
      doctoremail = f.docs[0]['email'];
    });

    setState(() {
      _isloading = false;
    });
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
      prescription = item.prescription;
      labResults = item.labresults;
    }

    var formatted = [];
    prescription.forEach((f) {
      formatted.add('${f[0].trim()}  ${f[1]} x ${f[2]}');
    });
    prescription = formatted;

    return Scaffold(
      appBar: AppBar(title: CustomText('Health Record')),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: deviceheight,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: [
                          SizedBox(height: 10),
                          CustomTile(
                            leadingiconData: Icons.person,
                            title: widget.isavisit
                                ? 'Doctor Name'
                                : 'Patient Name',
                            subtitle: widget.isavisit
                                ? '$doctorname'
                                : '$patientname',
                          ),
                          CustomTile(
                            leadingiconData: Icons.email,
                            title: widget.isavisit
                                ? 'Doctor Email'
                                : 'Patient Email',
                            subtitle: widget.isavisit
                                ? '$doctoremail'
                                : '$patientemail',
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
                      onTap: (index) {},
                      controller: _controller,
                      tabs: widgetlist,
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: TabBarView(
                        physics: BouncingScrollPhysics(),
                        controller: _controller,
                        children: [
                          ehrDetails(
                            medicalNotes,
                            Icons.assignment,
                            'assets/medical_notes.png',
                            deviceheight,
                          ),
                          ehrDetails(
                            labResults,
                            Icons.science,
                            'assets/lab_results.png',
                            deviceheight,
                          ),
                          ehrDetails(
                            prescription,
                            Icons.healing,
                            'assets/prescription.png',
                            deviceheight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  ListView ehrDetails(
      List ehrdetailslist, IconData iconData, String image, double height) {
    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomText(
          'Swipe to navigate between health record details',
          fontsize: 12,
          fontStyle: FontStyle.italic,
          color: Colors.grey,
          alignment: TextAlign.center,
        ),
        SizedBox(height: height * 0.025),
        Container(
          height: height * 0.1,
          child: CustomImage(image, BoxFit.contain),
        ),
        SizedBox(height: height * 0.025),
        ListView.separated(
          separatorBuilder: (ctx, i) => Divider(color: Colors.black),
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
