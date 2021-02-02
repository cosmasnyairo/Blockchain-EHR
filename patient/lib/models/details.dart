import 'package:flutter/cupertino.dart';

class Details {
  final List medicalnotes;
  final List labresults;
  final List prescription;
  Details({
    @required this.medicalnotes,
    @required this.labresults,
    @required this.prescription,
  });
}
