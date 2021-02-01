import 'package:doctor/models/transaction.dart';
import 'package:doctor/providers/auth_provider.dart';
import 'package:doctor/providers/record_provider.dart';
import 'package:doctor/widgets/custom_text.dart';
import 'package:doctor/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'visit_details.dart';

class ViewPatientRecords extends StatefulWidget {
  final String patientkey;
  ViewPatientRecords(this.patientkey);
  @override
  _ViewPatientRecordsState createState() => _ViewPatientRecordsState();
}

class _ViewPatientRecordsState extends State<ViewPatientRecords> {
  bool _isloading = false;
  List<Transaction> patienttransaction = [];
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    setState(() {
      _isloading = true;
    });
    final provider = Provider.of<RecordsProvider>(context, listen: false);

    await provider.getPatientChain(provider.peernode, widget.patientkey);
    provider.patientrecords.forEach((e) {
      e.transaction.forEach((f) {
        patienttransaction.add(f);
      });
    });
    super.didChangeDependencies();
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(patienttransaction);

    return Scaffold(
      appBar: AppBar(title: Text('Patient Records')),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : patienttransaction.length == 0
              ? Center(
                  child: Text('Patient has no records.'),
                )
              : ListView.builder(
                  itemBuilder: (ctx, i) => Card(
                    margin: EdgeInsets.all(30),
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      physics: ClampingScrollPhysics(),
                      children: [
                        SizedBox(height: 10),
                        CustomText(
                          '${DateFormat().add_yMMMMEEEEd().format(patienttransaction[i].timestamp)}\n${patienttransaction.length} visits',
                          fontsize: 16,
                          alignment: TextAlign.center,
                          fontweight: FontWeight.bold,
                        ),
                        SizedBox(height: 10),
                        ListView.separated(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => Divider(
                            indent: 20,
                            endIndent: 20,
                          ),
                          itemBuilder: (context, index) => CustomTile(
                            leadingiconData: Icons.description_outlined,
                            title: 'Health record',
                            subtitle: 'View details',
                            isthreeline: true,
                            iconData: Icons.navigate_next,
                            onpressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VisitDetails(
                                    patienttransaction[index],
                                    true,
                                  ),
                                ),
                              );
                            },
                          ),
                          itemCount: patienttransaction.length,
                        ),
                      ],
                    ),
                  ),
                  itemCount: patienttransaction.length,
                ),
    );
  }
}
