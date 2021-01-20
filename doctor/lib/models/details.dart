import 'package:doctor/models/doctor.dart';
import 'package:flutter/cupertino.dart';

class Details {
  final List medicalnotes;
  final List labresults;
  final List prescription;
  final List diagnosis;

  Details({
    @required this.medicalnotes,
    @required this.labresults,
    @required this.prescription,
    @required this.diagnosis,
  });
}
