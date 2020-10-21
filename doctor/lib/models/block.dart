import 'package:flutter/material.dart';
import 'transaction.dart';

class Block {
  final String index;
  final String userPort;
  final String timestamp;
  final List<Transaction> transaction;

  Block({
    @required this.index,
    @required this.timestamp,
    @required this.userPort,
    @required this.transaction,
  });
}
