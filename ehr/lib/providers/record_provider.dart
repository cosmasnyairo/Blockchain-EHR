import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/block.dart';
import '../models/details.dart';
import '../models/transaction.dart';

class RecordsProvider with ChangeNotifier {
  List<Block> _records = [];

  List<Block> get records {
    return [..._records];
  }

  Future<void> getChain() async {
    try {
      final url = 'http://192.168.137.1:5000/chain';
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
}
