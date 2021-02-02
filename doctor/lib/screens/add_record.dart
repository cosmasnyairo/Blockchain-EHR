import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/details.dart';
import '../models/doctor.dart';
import '../providers/auth_provider.dart';
import '../providers/record_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_form_field.dart';

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

bool _isloading = false;

class _AddRecordState extends State<AddRecord> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> args = ModalRoute.of(context).settings.arguments;
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Add Ehr Record')),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: deviceheight,
              width: double.infinity,
              child: StepperBody(args[0], args[1], devicewidth, deviceheight),
            ),
    );
  }
}

class StepperBody extends StatefulWidget {
  final _doctorkey;
  final _receiver;
  final devicewidth;
  final deviceheight;
  StepperBody(
      this._doctorkey, this._receiver, this.devicewidth, this.deviceheight);
  @override
  _StepperBodyState createState() => _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;

  final _formkey = GlobalKey<FormState>();

  var _isloading = false;

  List _medicalnotes = [];
  List _labresults = [];

  List _prescription = [];
  List drugname = [];
  List dose = [];
  List interval = [];

  List<Widget> _medicalwidgets = [];
  List<Widget> _labresultswidgets = [];
  List<Widget> _prescriptionwidgets = [];

  Details _enteredDetails;

  Future<void> _saveForm() async {
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    final isvalid = _formkey.currentState.validate();
    if (!isvalid) {
      showSnackBarMessage('Please correct errors before proceeding');
      return;
    }

    _formkey.currentState.save();
    joinprescription();

    _enteredDetails = Details(
      medicalnotes: _medicalnotes,
      labresults: _labresults,
      prescription: _prescription,
    );
    try {
      setState(() {
        _isloading = true;
      });
      print(_enteredDetails);
      await provider.addTransaction(
        provider.peernode,
        _enteredDetails,
        widget._doctorkey,
        widget._receiver,
      );
      setState(() {
        _isloading = false;
      });
      drugname = [];
      dose = [];
      interval = [];
      _medicalnotes = [];
      _labresults = [];
      _prescription = [];
      _enteredDetails = null;
      Navigator.of(context).pop();
    } catch (e) {
      drugname = [];
      dose = [];
      interval = [];
      _medicalnotes = [];
      _labresults = [];
      _prescription = [];
      _enteredDetails = null;
      await showDialog(
        context: context,
        builder: (ctx) => CustomAlertDialog(
          message: e.toString(),
          success: false,
        ),
      ).then((value) {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  void joinprescription() {
    for (var i = 0; i < drugname.length; i++) {
      _prescription.add([drugname[i], dose[i], interval[i]]);
    }
  }

  void removeDrug() {
    _prescriptionwidgets.removeLast();
    if ((dose.length & drugname.length & interval.length) > 0) {
      drugname.removeLast();
      dose.removeLast();
      interval.removeLast();
    }
  }

  void showSnackBarMessage(String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      customStepper(
        title: 'Medical Notes',
        formfields: customformfieldslist(
          dynamiclist: _medicalnotes,
          message: 'Enter Medical Notes',
          iconData: Icons.assignment,
        ),
        widgetlist: _medicalwidgets,
      ),
      customStepper(
        title: 'Lab Results',
        widgetlist: _labresultswidgets,
        formfields: customformfieldslist(
          dynamiclist: _labresults,
          message: 'Enter Lab Results',
          iconData: Icons.format_list_bulleted,
        ),
      ),
      customStepper(
        title: 'Prescription',
        formfields: prescriptionformfields(),
        widgetlist: _prescriptionwidgets,
      ),
    ];
    return _isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: _formkey,
            child: ListView(
              children: [
                Stepper(
                  physics: ClampingScrollPhysics(),
                  steps: steps,
                  type: StepperType.vertical,
                  currentStep: this.currStep,
                  controlsBuilder: (context, {onStepCancel, onStepContinue}) =>
                      SizedBox(),
                  onStepTapped: (step) {
                    setState(() {
                      currStep = step;
                    });
                  },
                ),
                SizedBox(height: 10),
                Align(
                  child: FloatingActionButton.extended(
                    icon: Icon(Icons.save),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text('Add Record'),
                    onPressed: _saveForm,
                  ),
                )
              ],
            ),
          );
  }

  Step customStepper({
    String title,
    List<Widget> widgetlist,
    ListView formfields,
  }) {
    return Step(
      title: Text(title),
      isActive: true,
      state: StepState.indexed,
      content: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          formfields,
          for (var item in widgetlist) (item),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widgetlist.length > 0
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).errorColor,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete, semanticLabel: 'Remove Entry'),
                        onPressed: () {
                          setState(() {
                            widgetlist..removeLast();
                          });
                        },
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: IconButton(
                  icon: Icon(Icons.add, semanticLabel: 'Add Entry'),
                  onPressed: () {
                    setState(() {
                      widgetlist..add(formfields);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ListView customformfieldslist({
    List dynamiclist,
    String message,
    IconData iconData,
  }) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        CustomFormField(
          keyboardtype: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          onsaved: (String value) {
            dynamiclist.add(value);
          },
          validator: (value) {
            if (value.isEmpty || value == '') {
              return message;
            }
            return null;
          },
          maxlines: 5,
          labeltext: message,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  ListView prescriptionformfields() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        CustomFormField(
          keyboardtype: TextInputType.text,
          textInputAction: TextInputAction.go,
          onsaved: (String value) {
            drugname.add(value);
          },
          validator: (value) {
            if (value.isEmpty || value == '') {
              return 'Enter Drug name';
            }
            return null;
          },
          labeltext: 'Drug name',
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: widget.devicewidth * 0.25,
              child: CustomFormField(
                keyboardtype: TextInputType.number,
                textInputAction: TextInputAction.go,
                onsaved: (String value) {
                  dose.add(value);
                },
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Dosage';
                  }
                  return null;
                },
                labeltext: 'Dosage',
              ),
            ),
            SizedBox(width: 10),
            CustomText('X'),
            SizedBox(width: 10),
            Container(
              width: widget.devicewidth * 0.25,
              child: CustomFormField(
                keyboardtype: TextInputType.number,
                textInputAction: TextInputAction.go,
                onsaved: (String value) {
                  interval.add(value);
                },
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Interval';
                  }
                  return null;
                },
                labeltext: 'Interval',
              ),
            ),
          ],
        ),
        SizedBox(height: 20)
      ],
    );
  }
}
