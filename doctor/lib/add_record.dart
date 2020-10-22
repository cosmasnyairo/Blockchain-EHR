import 'models/details.dart';
import 'models/node.dart';
import 'providers/record_provider.dart';
import 'widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'widgets/custom_text.dart';

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final _formkey = GlobalKey<FormState>();
  String connectednodeport;
  String _doctorkey;
  String _receiver;
  List drugname = [];
  List dose = [];
  List interval = [];

  List _medicalnotes = [];
  List _labresults = [];
  List _diagnosis = [];
  List _prescription = [];
  List<Widget> _prescriptionwidgets = [];

  Future<void> _saveForm() async {
    print(_receiver);
    final isvalid = _formkey.currentState.validate();
    if (!isvalid) {
      return;
    }
    _formkey.currentState.save();
    joinprescription();
    List<Details> _enteredDetails = [];
    _enteredDetails.add(
      Details(
        medicalnotes: _medicalnotes,
        labresults: _labresults,
        prescription: _prescription,
        diagnosis: _diagnosis,
      ),
    );

    try {
      await Provider.of<RecordsProvider>(context, listen: false).addTransaction(
        _enteredDetails,
        _doctorkey,
        _receiver,
      );
    } catch (e) {
      drugname = [];
      dose = [];
      interval = [];
      _medicalnotes = [];
      _labresults = [];
      _diagnosis = [];
      _prescription = [];
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          title: CustomText('An Error Occurred!'),
          content: CustomText(e.toString()),
          actions: <Widget>[
            Center(
              child: CustomButton(
                'Ok',
                () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ).then((value) {
        Navigator.of(context).pop();
      });
    }
  }

  void joinprescription() {
    for (var i = 0; i < drugname.length; i++) {
      var enteredprescription = drugname[i] +
          ' ' +
          dose[i].toString() +
          ' dose ' +
          interval[i].toString() +
          ' times a day';
      _prescription.add(enteredprescription);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> args = ModalRoute.of(context).settings.arguments;
    _doctorkey = args[0];
    _receiver = args[1];
    print(_receiver);

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
                CustomText('Doctor Key', fontsize: 16),
                SizedBox(height: 10),
                TextFormField(
                  enabled: false,
                  initialValue: _doctorkey,
                  decoration: InputDecoration(border: OutlineInputBorder()),
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
                  onSaved: (v) {
                    _medicalnotes.add(v);
                  },
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
                  onSaved: (v) {
                    _labresults.add(v);
                  },
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
                  onSaved: (v) {
                    _diagnosis.add(v);
                  },
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
                LimitedBox(
                  maxHeight: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        width: 150,
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            labelText: 'Drug name',
                            labelStyle: GoogleFonts.montserrat(fontSize: 16),
                          ),
                          textInputAction: TextInputAction.next,
                          onSaved: (v) {
                            drugname.add(v);
                          },
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
                          onSaved: (v) {
                            int.parse(v);
                            dose.add(v);
                          },
                          validator: (value) {
                            if (value.isEmpty || value == '') {
                              return 'Enter Dose';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Enter valid dose';
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
                          onSaved: (v) {
                            int.parse(v);
                            interval.add(v);
                          },
                          validator: (value) {
                            if (value.isEmpty || value == '') {
                              return 'Enter Interval';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Enter valid interval';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                _prescriptionwidgets.length > 0
                    ? LimitedBox(
                        maxHeight: _prescriptionwidgets.length * 100.0 + 30,
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
                        'Add prescription',
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
                              'Remove prescription',
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
                    _saveForm,
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
              width: 150,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Drug name',
                  labelStyle: GoogleFonts.montserrat(fontSize: 16),
                ),
                textInputAction: TextInputAction.next,
                onSaved: (v) {
                  drugname.add(v);
                },
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
                onSaved: (v) {
                  int.parse(v);
                  dose.add(v);
                },
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Dose';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter valid dose';
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
                onSaved: (v) {
                  int.parse(v);
                  interval.add(v);
                },
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Interval';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Enter valid interval';
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
    if ((dose.length & drugname.length & interval.length) > 0) {
      drugname.removeLast();
      dose.removeLast();
      interval.removeLast();
    }
  }
}
