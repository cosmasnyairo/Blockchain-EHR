import 'models/details.dart';
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

class MyData {
  List _medicalnotes = [];
  List _labresults = [];
  List _diagnosis = [];
  List _prescription = [];

  List drugname = [];
  List dose = [];
  List interval = [];
}

class _AddRecordState extends State<AddRecord> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> args = ModalRoute.of(context).settings.arguments;

    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText('Add Ehr Record'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: deviceheight,
        width: double.infinity,
        child: StepperBody(args[0], args[1]),
      ),
    );
  }
}

class StepperBody extends StatefulWidget {
  final _doctorkey;
  final _receiver;

  StepperBody(this._doctorkey, this._receiver);
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;
  final _formkey = GlobalKey<FormState>();
  static final data = MyData();

  List<Widget> _medicalwidgets = [];
  List<Widget> _labresultswidgets = [];
  List<Widget> _prescriptionwidgets = [];
  List<Widget> _diagnosiswidgets = [];

  Future<void> _saveForm() async {
    final isvalid = _formkey.currentState.validate();
    if (!isvalid) {
      showSnackBarMessage('Please correct errors before proceeding');
      return;
    }
    _formkey.currentState.save();
    joinprescription();
    List<Details> _enteredDetails = [];

    _enteredDetails.add(
      Details(
        medicalnotes: data._medicalnotes,
        labresults: data._labresults,
        prescription: data._prescription,
        diagnosis: data._diagnosis,
      ),
    );

    try {
      await Provider.of<RecordsProvider>(context, listen: false).addTransaction(
        _enteredDetails,
        widget._doctorkey,
        widget._receiver,
      );
    } catch (e) {
      data.drugname = [];
      data.dose = [];
      data.interval = [];
      data._medicalnotes = [];
      data._labresults = [];
      data._diagnosis = [];
      data._prescription = [];
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
    for (var i = 0; i < data.drugname.length; i++) {
      var enteredprescription = data.drugname[i] +
          ' ' +
          data.dose[i].toString() +
          ' dose ' +
          data.interval[i].toString() +
          ' times a day';
      data._prescription.add(enteredprescription);
    }
  }

  void removeDrug() {
    _prescriptionwidgets.removeLast();
    if ((data.dose.length & data.drugname.length & data.interval.length) > 0) {
      data.drugname.removeLast();
      data.dose.removeLast();
      data.interval.removeLast();
    }
  }

  void showSnackBarMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: CustomText(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      Step(
        title: CustomText('Medical Notes'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (String value) {
                data._medicalnotes.add(value);
              },
              validator: (value) {
                if (value.isEmpty || value == '') {
                  return 'Enter Medical Notes';
                }
                return null;
              },
              maxLines: null,
              minLines: 2,
              decoration: InputDecoration(
                labelText: 'Enter Medical Notes',
                icon: Icon(
                  Icons.assignment,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 10),
            _medicalwidgets.length > 0 ? Divider() : SizedBox(height: 10),
            for (var item in _medicalwidgets) (item),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: CustomText('Add Entry'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _medicalwidgets
                        ..add(
                          Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                onSaved: (String value) {
                                  data._medicalnotes.add(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty || value == '') {
                                    return 'Enter Medical Notes';
                                  }
                                  return null;
                                },
                                maxLines: null,
                                minLines: 2,
                                decoration: InputDecoration(
                                  labelText: 'Enter Medical Details',
                                  icon: Icon(
                                    Icons.assignment,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                    });
                  },
                ),
                SizedBox(width: 10),
                _medicalwidgets.length > 0
                    ? FlatButton(
                        child: CustomText('Remove Entry'),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          setState(() {
                            _medicalwidgets..removeLast();
                          });
                        },
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      Step(
        title: Text('Lab Results'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (String value) {
                data._labresults.add(value);
              },
              validator: (value) {
                if (value.isEmpty || value == '') {
                  return 'Enter Lab Results';
                }
                return null;
              },
              maxLines: null,
              minLines: 2,
              decoration: new InputDecoration(
                labelText: 'Enter Lab results',
                icon: Icon(
                  Icons.format_list_bulleted,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 10),
            _labresultswidgets.length > 0 ? Divider() : SizedBox(height: 10),
            for (var item in _labresultswidgets) (item),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: CustomText('Add Entry'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _labresultswidgets
                        ..add(
                          Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                onSaved: (String value) {
                                  data._labresults.add(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty || value == '') {
                                    return 'Enter Lab Results';
                                  }
                                  return null;
                                },
                                maxLines: null,
                                minLines: 2,
                                decoration: new InputDecoration(
                                  labelText: 'Enter Lab results',
                                  icon: Icon(
                                    Icons.format_list_bulleted,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                    });
                  },
                ),
                SizedBox(width: 10),
                _labresultswidgets.length > 0
                    ? FlatButton(
                        child: CustomText('Remove Entry'),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          setState(() {
                            _labresultswidgets.removeLast();
                          });
                        },
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      Step(
        title: Text('Prescription'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: [
            Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  onSaved: (String value) {
                    data.drugname.add(value);
                  },
                  validator: (value) {
                    if (value.isEmpty || value == '') {
                      return 'Enter Drug name';
                    }
                    return null;
                  },
                  maxLines: null,
                  minLines: 2,
                  decoration: new InputDecoration(
                    labelText: 'Enter Drug name',
                    icon: Icon(
                      Icons.gradient,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (String value) {
                    data.interval.add(value);
                  },
                  validator: (value) {
                    if (value.isEmpty || value == '') {
                      return 'Enter Interval';
                    }
                    return null;
                  },
                  maxLines: null,
                  minLines: 2,
                  decoration: new InputDecoration(
                    labelText: 'Enter Interval',
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  onSaved: (String value) {
                    data.dose.add(value);
                  },
                  validator: (value) {
                    if (value.isEmpty || value == '') {
                      return 'Enter Dosage';
                    }
                    return null;
                  },
                  maxLines: null,
                  minLines: 2,
                  decoration: new InputDecoration(
                    labelText: 'Enter Dosage',
                    icon: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _prescriptionwidgets.length > 0 ? Divider() : SizedBox(),
            for (var item in _prescriptionwidgets) (item),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: CustomText('Add Entry'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _prescriptionwidgets
                        ..add(
                          Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                onSaved: (String value) {
                                  data.drugname.add(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty || value == '') {
                                    return 'Enter Drug name';
                                  }
                                  return null;
                                },
                                maxLines: null,
                                minLines: 2,
                                decoration: new InputDecoration(
                                  labelText: 'Enter Drug name',
                                  icon: Icon(
                                    Icons.gradient,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                onSaved: (String value) {
                                  data.interval.add(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty || value == '') {
                                    return 'Enter Interval';
                                  }
                                  return null;
                                },
                                maxLines: null,
                                minLines: 2,
                                decoration: new InputDecoration(
                                  labelText: 'Enter Interval',
                                  icon: Icon(
                                    Icons.check_circle_outline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                onSaved: (String value) {
                                  data.dose.add(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty || value == '') {
                                    return 'Enter Dosage';
                                  }
                                  return null;
                                },
                                maxLines: null,
                                minLines: 2,
                                decoration: new InputDecoration(
                                  labelText: 'Enter Dosage',
                                  icon: Icon(
                                    Icons.calendar_today,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10),
                            ],
                          ),
                        );
                    });
                  },
                ),
                SizedBox(width: 10),
                _prescriptionwidgets.length > 0
                    ? FlatButton(
                        child: CustomText('Remove Entry'),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          setState(() {
                            _prescriptionwidgets.removeLast();
                          });
                        },
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      Step(
        title: Text('Diagnosis'),
        isActive: true,
        state: StepState.indexed,
        content: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              onSaved: (String value) {
                data._diagnosis.add(value);
              },
              validator: (value) {
                if (value.isEmpty || value == '') {
                  return 'Enter Diagnosis Notes';
                }
                return null;
              },
              maxLines: null,
              minLines: 2,
              decoration: new InputDecoration(
                labelText: 'Enter Diagnosis',
                icon: Icon(
                  Icons.format_align_center,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 10),
            _diagnosiswidgets.length > 0 ? Divider() : SizedBox(),
            for (var item in _diagnosiswidgets) (item),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: CustomText('Add Entry'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _diagnosiswidgets
                        ..add(
                          Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.text,
                                onSaved: (String value) {
                                  data._diagnosis.add(value);
                                },
                                validator: (value) {
                                  if (value.isEmpty || value == '') {
                                    return 'Enter Diagnosis Notes';
                                  }
                                  return null;
                                },
                                maxLines: null,
                                minLines: 2,
                                decoration: new InputDecoration(
                                  labelText: 'Enter Diagnosis',
                                  icon: Icon(
                                    Icons.format_align_center,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Divider(),
                              SizedBox(height: 10)
                            ],
                          ),
                        );
                    });
                  },
                ),
                SizedBox(width: 10),
                _diagnosiswidgets.length > 0
                    ? FlatButton(
                        child: CustomText('Remove Entry'),
                        color: Theme.of(context).errorColor,
                        onPressed: () {
                          setState(() {
                            _diagnosiswidgets.removeLast();
                          });
                        },
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ];
    return Form(
      key: _formkey,
      child: ListView(
        children: [
          Stepper(
            physics: ClampingScrollPhysics(),
            steps: steps,
            type: StepperType.vertical,
            currentStep: this.currStep,
            controlsBuilder: (context, {onStepCancel, onStepContinue}) {
              return Row(
                children: <Widget>[
                  currStep == steps.length - 1
                      ? SizedBox()
                      : FlatButton(
                          color: Theme.of(context).primaryColor,
                          child: CustomText('Continue'),
                          onPressed: onStepContinue,
                        ),
                  currStep == steps.length - 1
                      ? SizedBox()
                      : SizedBox(width: 20),
                  currStep > 0
                      ? FlatButton(
                          color: Theme.of(context).errorColor,
                          child: CustomText('Go back one step'),
                          onPressed: onStepCancel,
                        )
                      : SizedBox(),
                ],
              );
            },
            onStepContinue: () {
              setState(() {
                if (currStep < steps.length - 1) {
                  currStep = currStep + 1;
                } else {
                  currStep = 0;
                }
              });
            },
            onStepCancel: () {
              setState(() {
                if (currStep > 0) {
                  currStep = currStep - 1;
                } else {
                  currStep = 0;
                }
              });
            },
            onStepTapped: (step) {
              setState(() {
                currStep = step;
              });
            },
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
    );
  }
}
