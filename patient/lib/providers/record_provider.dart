import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/block.dart';
import '../models/details.dart';
import '../models/transaction.dart';

import '../secrets.dart' as secrets;

class RecordsProvider with ChangeNotifier {
  final String _apiurl = secrets.url;

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
      final url = '$_apiurl/chain';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List;

      final List<Block> loadedblocks = [];
      extractedData.forEach(
        (element) {
          loadedblocks.add(
            Block(
              index: element['index'].toString(),
              userPublicKey: element['user_public_key'].toString(),
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

//signup
  Future<void> createKeys() async {
    try {
      final url = '$_apiurl/create_keys';
      final response = await http.post(url);
      var keys = json.decode(response.body);
      _publickey = keys["public_key"];
      _privatekey = keys["private_key"];
    } catch (e) {}
  }

  Future<void> resolveConflicts() async {
    try {
      final url = '$_apiurl/resolve_conflicts';
      final response = await http.post(url);
      json.decode(response.body);
    } catch (e) {}
  }

//onlogin
  Future<void> loadKeys() async {
    try {
      final url = '$_apiurl/load_keys';
      final response = await http.get(url);
      var keys = json.decode(response.body);
      _publickey = keys["public_key"];
      _privatekey = keys["private_key"];
    } catch (e) {}
  }
}
