import 'models/details.dart';
import 'providers/record_provider.dart';
import 'widgets/alert_dialog.dart';
import 'widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      appBar: AppBar(title: Text('Add Ehr Record')),
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

  var _isloading = false;

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
      setState(() {
        _isloading = true;
      });
      await Provider.of<RecordsProvider>(context, listen: false).addTransaction(
        _enteredDetails,
        widget._doctorkey,
        widget._receiver,
      );

      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
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
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Step> steps = [
      customStepper(
        title: 'Medical Notes',
        formfields: customformfields(
          dynamiclist: data._medicalnotes,
          message: 'Enter Medical Notes',
          iconData: Icons.assignment,
        ),
        widgetlist: _medicalwidgets,
      ),
      customStepper(
        title: 'Lab Results',
        widgetlist: _labresultswidgets,
        formfields: customformfields(
          dynamiclist: data._labresults,
          message: 'Enter Lab Results',
          iconData: Icons.format_list_bulleted,
        ),
      ),
      customStepper(
        title: 'Prescription',
        formfields: prescriptionformfields(),
        widgetlist: _prescriptionwidgets,
      ),
      customStepper(
        title: 'Diagnosis',
        widgetlist: _diagnosiswidgets,
        formfields: customformfields(
          dynamiclist: data._diagnosis,
          message: 'Enter Diagnosis',
          iconData: Icons.format_align_center,
        ),
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
          SizedBox(height: 10),
          widgetlist.length > 0 ? Divider() : SizedBox(height: 10),
          for (var item in widgetlist) (item),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                'Add new entry',
                () {
                  setState(() {
                    widgetlist..add(formfields);
                  });
                },
              ),
              SizedBox(width: 10),
              widgetlist.length > 0
                  ? CustomButton(
                      'Remove Entry',
                      () {
                        setState(() {
                          widgetlist..removeLast();
                        });
                      },
                      backgroundcolor: Theme.of(context).errorColor,
                    )
                  : SizedBox(),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  ListView customformfields({
    List dynamiclist,
    String message,
    IconData iconData,
  }) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.go,
          onSaved: (String value) {
            dynamiclist.add(value);
          },
          validator: (value) {
            if (value.isEmpty || value == '') {
              return message;
            }
            return null;
          },
          maxLines: null,
          minLines: 2,
          decoration: InputDecoration(
            labelText: message,
            icon: Icon(
              iconData,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        SizedBox(height: 10)
      ],
    );
  }

  ListView prescriptionformfields() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        TextFormField(
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.go,
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
          textInputAction: TextInputAction.go,
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
          textInputAction: TextInputAction.go,
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
      ],
    );
  }
}
