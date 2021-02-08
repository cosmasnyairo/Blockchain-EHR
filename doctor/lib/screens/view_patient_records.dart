import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/block.dart';
import '../models/transaction.dart';
import '../providers/record_provider.dart';
import '../widgets/custom_tile.dart';
import 'visit_details.dart';

class ViewPatientRecords extends StatefulWidget {
  final String patientkey;
  ViewPatientRecords(this.patientkey);
  @override
  _ViewPatientRecordsState createState() => _ViewPatientRecordsState();
}

class _ViewPatientRecordsState extends State<ViewPatientRecords> {
  bool _isloading = false;
  List<Block> fetchedrecords = [];
  List<Transaction> patienttransaction = [];
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    setState(() {
      _isloading = true;
    });
    final provider = Provider.of<RecordsProvider>(context, listen: false);

    await provider.getPatientChain(provider.peernode, widget.patientkey);
    fetchedrecords = provider.patientrecords;

    fetchedrecords.forEach((e) {
      e.transaction.forEach((f) {
        patienttransaction.add(f);
      });
    });

    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Records')),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : fetchedrecords.length == 0
              ? Center(
                  child: Text('Patient has no records.'),
                )
              : ListView.separated(
                  separatorBuilder: (ctx, i) => SizedBox(height: 20),
                  padding: EdgeInsets.all(20),
                  itemBuilder: (ctx, i) => Card(
                    elevation: 8,
                    child: CustomTile(
                      title:
                          'Visit on ${convert(patienttransaction[i].timestamp)}',
                      subtitle: 'View records for this visit',
                      iconData: Icons.navigate_next,
                      leadingiconData: Icons.assessment,
                      isthreeline: true,
                      onpressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => VisitDetails(
                            patienttransaction[i],
                            true,
                          ),
                        ));
                      },
                    ),
                  ),
                  //  Card(
                  //   margin: EdgeInsets.all(30),
                  //   elevation: 7,
                  //   shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10)),
                  //   child: ListView(
                  //     shrinkWrap: true,
                  //     padding: EdgeInsets.all(10),
                  //     physics: ClampingScrollPhysics(),
                  //     children: [
                  //       SizedBox(height: 10),
                  //       CustomText(
                  //         '${DateFormat().add_yMMMMEEEEd().format(patienttransaction[i].timestamp)}',
                  //         fontsize: 16,
                  //         alignment: TextAlign.center,
                  //         fontweight: FontWeight.bold,
                  //       ),
                  //       SizedBox(height: 10),
                  //       CustomTile(
                  //         leadingiconData: Icons.description_outlined,
                  //         title: 'Health record',
                  //         subtitle: 'View details',
                  //         isthreeline: true,
                  //         iconData: Icons.navigate_next,
                  //         onpressed: () {
                  //           Navigator.of(context).push(
                  //             MaterialPageRoute(
                  //               builder: (context) => VisitDetails(
                  //                 patienttransaction[i],
                  //                 true,
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  itemCount: patienttransaction.length,
                ),
    );
  }

  convert(DateTime timestamp) {
    return DateFormat().add_yMMMd().add_jm().format(timestamp);
  }
}
