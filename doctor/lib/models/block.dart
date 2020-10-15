import 'package:flutter/material.dart';
import 'transaction.dart';

class Block {
  final String index;
  final String userPublicKey;
  final String timestamp;
  final List<Transaction> transaction;

  Block({
    @required this.index,
    @required this.timestamp,
    @required this.userPublicKey,
    @required this.transaction,
  });
}
