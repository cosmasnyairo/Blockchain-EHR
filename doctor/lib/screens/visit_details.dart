import 'package:flutter/material.dart';

import '../models/doctor.dart';
import '../models/transaction.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_tile.dart';

class VisitDetails extends StatefulWidget {
  final Transaction transaction;
  VisitDetails(this.transaction);
  @override
  _VisitDetailsState createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;

  List<Widget> widgetlist = [
    Icon(Icons.assignment, size: 30),
    Icon(Icons.search, size: 30),
    Icon(Icons.analytics, size: 30),
    Icon(Icons.science, size: 30),
  ];

  @override
  void initState() {
    _controller = TabController(length: widgetlist.length, vsync: this);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    List medicalNotes = [];
    List labResults = [];
    List prescription = [];
    List diagnosis = [];

    EhrDoctor doctordetails;
    for (var item in widget.transaction.details) {
      doctordetails = item.doctordetails;
      medicalNotes = item.medicalnotes;
      diagnosis = item.diagnosis;
      prescription = item.prescription;
      labResults = item.labresults;
    }

    return Scaffold(
      appBar: AppBar(
        title: CustomText('Health Record'),
      ),
      body: Container(
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
                  CustomText(
                    'Doctor details',
                    alignment: TextAlign.center,
                    fontsize: 16,
                    fontweight: FontWeight.bold,
                  ),
                  CustomTile(
                    leadingiconData: Icons.person,
                    title: 'Doctor',
                    subtitle: '${doctordetails.name}',
                  ),
                  CustomTile(
                    leadingiconData: Icons.email,
                    title: 'Email',
                    subtitle: '${doctordetails.email}',
                  ),
                  CustomTile(
                    leadingiconData: Icons.local_hospital,
                    title: 'Hospital',
                    subtitle: '${doctordetails.hospital}',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomText(
              'Tap the icons below to view health record details',
              alignment: TextAlign.center,
            ),
            SizedBox(height: 20),
            TabBar(
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.all(5),
              indicatorColor: Theme.of(context).primaryColor,
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
                  ListView(
                    children: [
                      CustomText(
                        'Medical Notes:',
                        fontsize: 16,
                        fontweight: FontWeight.bold,
                        alignment: TextAlign.center,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: medicalNotes.length,
                        itemBuilder: (ctx, i) => CustomTile(
                          leadingiconData: Icons.assignment,
                          title: medicalNotes[i],
                        ),
                      )
                    ],
                  ),
                  ListView(
                    children: [
                      CustomText(
                        'Lab Results for your visit:',
                        fontsize: 16,
                        fontweight: FontWeight.bold,
                        alignment: TextAlign.center,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: labResults.length,
                        itemBuilder: (ctx, i) => CustomTile(
                          leadingiconData: Icons.search,
                          title: medicalNotes[i],
                        ),
                      )
                    ],
                  ),
                  ListView(
                    children: [
                      CustomText(
                        'Diagnosis for your visit:',
                        fontsize: 16,
                        fontweight: FontWeight.bold,
                        alignment: TextAlign.center,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: diagnosis.length,
                        itemBuilder: (ctx, i) => CustomTile(
                          leadingiconData: Icons.analytics,
                          title: medicalNotes[i],
                        ),
                      )
                    ],
                  ),
                  ListView(
                    children: [
                      CustomText(
                        'Prescription for your visit:',
                        fontsize: 16,
                        fontweight: FontWeight.bold,
                        alignment: TextAlign.center,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: prescription.length,
                        itemBuilder: (ctx, i) => CustomTile(
                          leadingiconData: Icons.science,
                          title: medicalNotes[i],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
