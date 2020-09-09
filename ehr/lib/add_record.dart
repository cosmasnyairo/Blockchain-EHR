import 'package:ehr/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import 'widgets/custom_text.dart';

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final _medicalnotesFocusNode = FocusNode();
  final _labresultsFocusNode = FocusNode();
  final _diagnosisFocusNode = FocusNode();
  final _prescriptionFocusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();
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
        child: Form(
          key: _formkey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: [
              CustomText('Enter Recipient Key', fontsize: 16),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_medicalnotesFocusNode);
                },
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
                maxLines: 3,
                maxLength: 700,
                keyboardType: TextInputType.multiline,
                focusNode: _medicalnotesFocusNode,
                decoration: InputDecoration(border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_labresultsFocusNode);
                },
                onSaved: (v) {},
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Medical Notes';
                  }
                  return null;
                },
              ),
              CustomText('Enter Lab Results', fontsize: 16),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 3,
                maxLength: 700,
                keyboardType: TextInputType.multiline,
                focusNode: _labresultsFocusNode,
                decoration: InputDecoration(border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_diagnosisFocusNode);
                },
                onSaved: (v) {},
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Lab Results';
                  }
                  return null;
                },
              ),
              CustomText('Enter Diagnosis', fontsize: 16),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 3,
                maxLength: 700,
                keyboardType: TextInputType.multiline,
                focusNode: _diagnosisFocusNode,
                decoration: InputDecoration(border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_prescriptionFocusNode);
                },
                onSaved: (v) {},
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Diagnosis';
                  }
                  return null;
                },
              ),
              CustomText('Enter Prescription', fontsize: 16),
              SizedBox(height: 10),
              TextFormField(
                maxLines: 3,
                maxLength: 700,
                keyboardType: TextInputType.multiline,
                focusNode: _prescriptionFocusNode,
                decoration: InputDecoration(border: OutlineInputBorder()),
                textInputAction: TextInputAction.next,
                onSaved: (v) {},
                validator: (value) {
                  if (value.isEmpty || value == '') {
                    return 'Enter Prescription';
                  }
                  return null;
                },
              ),
              Align(child: CustomButton('Add Record', () {}))
            ],
          ),
        ),
      ),
    );
  }
}
