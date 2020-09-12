import 'package:ehr/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/custom_text.dart';

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final _formkey = GlobalKey<FormState>();
  var _doctorkeycontroller;
  List _medicalnotes = [];
  List _lab_results = [];
  List _diagnosis = [];
  List _prescription = [];
  List _prescriptionlist = [];
  List<Widget> _prescriptionwidgets = [];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('ADD EHR RECORD'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: height,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                SizedBox(height: 10),
                CustomText('Enter Doctor Key', fontsize: 16),
                SizedBox(height: 10),
                TextFormField(
                  controller: _doctorkeycontroller,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                  onSaved: (v) {},
                  validator: (value) {
                    if (value.isEmpty || value == '') {
                      return 'Enter Receiver key';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomText('Enter Medical Notes', fontsize: 16),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  textInputAction: TextInputAction.newline,
                  onSaved: (v) {},
                  validator: (value) {
                    if (value.isEmpty || value == '') {
                      return 'Enter Medical Notes';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomText('Enter Lab Results', fontsize: 16),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                  onSaved: (v) {},
                  validator: (value) {
                    if (value.isEmpty || value == '') {
                      return 'Enter Lab Results';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomText('Enter Diagnosis', fontsize: 16),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: null,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                  onSaved: (v) {},
                  validator: (value) {
                    if (value.isEmpty || value == '') {
                      return 'Enter Diagnosis';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                CustomText('Enter Prescription', fontsize: 16),
                SizedBox(height: 10),
                _prescriptionwidgets.length > 0
                    ? LimitedBox(
                        maxHeight: _prescriptionwidgets.length * 100.0 + 10,
                        child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            return LimitedBox(
                              maxHeight: 80,
                              child: _prescriptionwidgets[i],
                            );
                          },
                          itemCount: _prescriptionwidgets.length,
                        ),
                      )
                    : SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomButton(
                        'Add new drug',
                        () {
                          setState(() {
                            addDrug();
                          });
                        },
                        elevation: 0,
                        height: 40,
                      ),
                    ),
                    _prescriptionwidgets.length <= 0
                        ? SizedBox()
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: CustomButton(
                              'Remove drug',
                              () {
                                setState(() {
                                  removeDrug();
                                });
                              },
                              elevation: 0,
                              height: 40,
                            ),
                          ),
                  ],
                ),
                SizedBox(height: 10),
                Align(
                  child: CustomButton(
                    'Add Record',
                    () {},
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addDrug() {
    _prescriptionwidgets
      ..add(
        ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              width: 200,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Drug name',
                  labelStyle: GoogleFonts.montserrat(fontSize: 16),
                ),
                textInputAction: TextInputAction.next,
                onSaved: (v) {},
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Drug name';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 80,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Dose',
                  labelStyle: GoogleFonts.montserrat(fontSize: 16),
                ),
                textInputAction: TextInputAction.next,
                onSaved: (v) {},
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Prescription';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 10),
            Container(
              width: 80,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Interval',
                  labelStyle: GoogleFonts.montserrat(fontSize: 16),
                ),
                textInputAction: TextInputAction.next,
                onSaved: (v) {},
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Prescription';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      );
  }

  void removeDrug() {
    _prescriptionwidgets.removeLast();
  }
}
