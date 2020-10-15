import 'package:flutter/material.dart';
import 'details.dart';

class Transaction {
  final String sender;
  final String receiver;
  final List<Details> details;

  Transaction({
    @required this.sender,
    @required this.receiver,
    @required this.details,
  });
}
