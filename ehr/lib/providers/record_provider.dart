import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/block.dart';
import '../models/details.dart';
import '../models/transaction.dart';

class RecordsProvider with ChangeNotifier {
  final String apiurl = 'http://192.168.100.18:5000';

  String _publickey;
  String _privatekey;
  List<Block> _records = [];
  List<Transaction> _opentransactions = [];

  List<Block> get records {
    return [..._records];
  }

  List<Transaction> get opentransactions {
    return [..._opentransactions];
  }

  String get publickey {
    return _publickey;
  }

  String get privatekey {
    return _privatekey;
  }

  Future<void> getChain() async {
    try {
      final url = '$apiurl/chain';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List;

      final List<Block> loadedblocks = [];
      // extractedData.forEach(
      //   (element) {
      //     loadedblocks.add(
      //       Block(
      //         index: element['index'].toString(),
      //         timestamp: element['timestamp'].toString(),
      //         transaction: (element['transactions']).forEach(
      //           (transaction) {
      //             loadedtransaction.add(
      //               Transaction(
      //                 sender: transaction['sender'],
      //                 receiver: transaction['receiver'],
      //                 details: [transaction['details']].forEach(
      //                   (detail) {
      //                     loadeddetails.add(
      //                       Details(
      //                         medicalnotes: detail['medical_notes'],
      //                         labresults: detail['lab_results'],
      //                         prescription: detail['prescription'],
      //                         diagnosis: detail['diagnosis'],
      //                       ),
      //                     );
      //                   },
      //                 ) as List,
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //     );
      //   },
      // );
      extractedData.forEach(
        (element) {
          loadedblocks.add(
            Block(
              index: element['index'].toString(),
              timestamp: element['timestamp'].toString(),
              transaction: (element['transactions'] as List<dynamic>)
                  .map(
                    (e) => Transaction(
                      sender: e['sender'],
                      receiver: e['receiver'],
                      details: List<dynamic>.from([e['details']])
                          .map(
                            (f) => Details(
                              medicalnotes: f['medical_notes'],
                              labresults: f['lab_results'],
                              prescription: f['prescription'],
                              diagnosis: f['diagnosis'],
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
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

  Future<void> addTransaction(List<Details> details, String receiver) async {
    Map<String, dynamic> transaction = {
      "details": {
        "diagnosis": details[0].diagnosis.toList(),
        "lab_results": details[0].labresults.toList(),
        "medical_notes": details[0].medicalnotes.toList(),
        "prescription": details[0].prescription.toList(),
      },
      "receiver": receiver
    };
    try {
      final url = '$apiurl/add_transaction';
      final response = await http.post(
        url,
        body: json.encode(transaction),
        headers: {
          "Content-Type": "application/json",
        },
      );
      final res = json.decode(response.body);
      throw res["message"];
    } catch (e) {
      throw e;
    }
  }

  Future<void> mine() async {
    try {
      final url = '$apiurl/mine';
      final response = await http.post(url);
      final res = json.decode(response.body);
      throw res["message"];
    } catch (e) {
      throw e;
    }
  }

  Future<void> getOpenTransactions() async {
    try {
      final url = '$apiurl/get_opentransactions';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List;
      final List<Transaction> loadedtransactions = [];

      extractedData.forEach(
        (transaction) {
          loadedtransactions.add(
            Transaction(
              sender: transaction['sender'],
              receiver: transaction['receiver'],
              details: List<dynamic>.from([transaction['details']])
                  .map(
                    (f) => Details(
                      medicalnotes: f['medical_notes'],
                      labresults: f['lab_results'],
                      prescription: f['prescription'],
                      diagnosis: f['diagnosis'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );
      _opentransactions = loadedtransactions;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

//signup
  Future<void> createKeys() async {
    try {
      final url = '$apiurl/create_keys';
      final response = await http.post(url);
      var keys = json.decode(response.body);
      _publickey = keys["public_key"];
      _privatekey = keys["private_key"];
    } catch (e) {}
  }

//onlogin
  Future<void> loadKeys() async {
    try {
      final url = '$apiurl/load_keys';
      final response = await http.get(url);
      var keys = json.decode(response.body);
      _publickey = keys["public_key"];
      _privatekey = keys["private_key"];
    } catch (e) {}
  }
}
