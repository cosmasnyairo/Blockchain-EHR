import 'dart:convert';

import 'package:ehr/models/details.dart';
import 'package:ehr/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/block.dart';

class RecordsProvider with ChangeNotifier {
  List<Block> _records = [];

  List<Block> get records {
    return [..._records];
  }

  Future getChain() async {
    try {
      final url = 'http://192.168.100.18:5000/chain';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List;

      final List<Block> loadedblocks = [];
      final List<Transaction> loadedtransaction = [];
      final List<Details> loadeddetails = [];

      extractedData.forEach(
        (element) {
          loadedblocks.add(
            Block(
              index: element['index'].toString(),
              timestamp: element['timestamp'].toString(),
              transaction: (element['transactions']).forEach(
                (transaction) {
                  loadedtransaction.add(
                    Transaction(
                      sender: transaction['sender'],
                      receiver: transaction['receiver'],
                      details: [transaction['details']].forEach(
                        (detail) {
                          loadeddetails.add(
                            Details(
                              medicalnotes: detail['medical_notes'],
                              labresults: detail['lab_results'],
                              prescription: detail['prescription'],
                              diagnosis: detail['diagnosis'],
                            ),
                          );
                        },
                      ) as List,
                    ),
                  );
                },
              ),
            ),
          );
        },
      );
      _records = loadedblocks;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
