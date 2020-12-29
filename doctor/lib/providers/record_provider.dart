import 'dart:convert';
import 'package:doctor/models/doctor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/block.dart';
import '../models/details.dart';
import '../models/transaction.dart';

import '../secrets.dart' as secrets;

class RecordsProvider with ChangeNotifier {
  final String _apiurl = secrets.apiurl;

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
              timestamp: element['timestamp'].toString(),
              transaction: (element['transactions'] as List<dynamic>)
                  .map(
                    (e) => Transaction(
                      sender: e['sender'],
                      receiver: e['receiver'],
                      timestamp: DateTime.parse(e['timestamp']),
                      details: List<dynamic>.from([e['details']])
                          .map(
                            (f) => Details(
                              medicalnotes: f['medical_notes'],
                              labresults: f['lab_results'],
                              prescription: f['prescription'],
                              diagnosis: f['diagnosis'],
                              doctordetails: EhrDoctor(
                                doctorid: f['doctordetails']['doctorid'],
                                email: f['doctordetails']['email'],
                                hospital: f['doctordetails']['hospital'],
                                location: f['doctordetails']['location'],
                                name: f['doctordetails']['name'],
                              ),
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
      throw (e);
    }
  }

  Future<void> addTransaction(
    Details details,
    String sender,
    String receiver,
  ) async {
    final timestamp = DateTime.now();
    Map<String, dynamic> transaction = {
      "details": {
        "diagnosis": details.diagnosis.toList(),
        "lab_results": details.labresults.toList(),
        "medical_notes": details.medicalnotes.toList(),
        "prescription": details.prescription.toList(),
        "doctordetails": details.doctordetails.toJson(),
      },
      "receiver": receiver,
      "timestamp": timestamp.toIso8601String(),
    };
    try {
      final url = '${secrets.apiurl}/add_transaction';
      await http.post(
        url,
        body: json.encode(transaction),
        headers: {
          "Content-Type": "application/json",
        },
      );
    } catch (e) {
      throw e;
    }
  }

  Future<void> mine() async {
    try {
      final url = '$_apiurl/mine';
      await http.post(url);
    } catch (e) {
      throw e;
    }
  }

  Future<void> resolveConflicts() async {
    try {
      final url = '$_apiurl/resolve_conflicts';
      await http.post(url);
    } catch (e) {}
  }

  Future<void> getOpenTransactions() async {
    try {
      final url = '$_apiurl/get_opentransactions';
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as List;
      final List<Transaction> loadedtransactions = [];

      extractedData.forEach(
        (transaction) {
          loadedtransactions.add(
            Transaction(
              sender: transaction['sender'],
              receiver: transaction['receiver'],
              timestamp: DateTime.parse(transaction['timestamp']),
              details: List<dynamic>.from([transaction['details']])
                  .map(
                    (f) => Details(
                      medicalnotes: f['medical_notes'],
                      labresults: f['lab_results'],
                      prescription: f['prescription'],
                      diagnosis: f['diagnosis'],
                      doctordetails: EhrDoctor(
                        doctorid: f['doctordetails']['doctorid'],
                        email: f['doctordetails']['email'],
                        hospital: f['doctordetails']['hospital'],
                        location: f['doctordetails']['location'],
                        name: f['doctordetails']['name'],
                      ),
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
      final url = '$_apiurl/create_keys';
      final response = await http.post(url);
      var keys = json.decode(response.body);
      _publickey = keys["public_key"];
      _privatekey = keys["private_key"];
    } catch (e) {
      throw (e);
    }
  }

//onlogin
  Future<void> loadKeys() async {
    try {
      final url = '$_apiurl/load_keys';
      final response = await http.get(url);
      var keys = json.decode(response.body);
      _publickey = keys["public_key"];
      _privatekey = keys["private_key"];
    } catch (e) {
      throw (e);
    }
  }
}
