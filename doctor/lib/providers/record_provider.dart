import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/block.dart';
import '../models/details.dart';
import '../models/transaction.dart' as EhrTransaction;
import '../providers/auth_provider.dart';
import '../secrets.dart' as secrets;

class RecordsProvider with ChangeNotifier {
  final String _apiurl = secrets.apiurl;

  String _publickey;
  String _privatekey;
  int _peernode;
  List<Block> _records = [];

  List<Block> _patientrecords = [];
  List<EhrTransaction.Transaction> _opentransactions = [];

  List<Block> get records {
    return [..._records];
  }

  List<Block> get patientrecords {
    return [..._patientrecords];
  }

  List<EhrTransaction.Transaction> get opentransactions {
    return [..._opentransactions];
  }

  String get publickey {
    return _publickey;
  }

  String get privatekey {
    return _privatekey;
  }

  int get peernode {
    return _peernode;
  }

  Future<void> getPortNumber(BuildContext context) async {
    final userid =
        Provider.of<DoctorAuthProvider>(context, listen: false).userid;
    final peernode = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(userid)
        .get()
        .then((f) {
      return f['peer_node'];
    });
    _peernode = peernode;
  }

  Future<void> getChain(int port, String doctorkey) async {
    try {
      final url = '$_apiurl:$port/doctorchain';
      Map<String, String> doctorrequest = {"sender": doctorkey};
      print(doctorrequest);
      print(url);
      final response = await http.post(
        url,
        body: json.encode(doctorrequest),
        headers: {
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
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
                    (e) => EhrTransaction.Transaction(
                      sender: e['sender'],
                      receiver: e['receiver'],
                      timestamp: DateTime.parse(e['timestamp']),
                      details: List<dynamic>.from([e['details']])
                          .map(
                            (f) => Details(
                              medicalnotes: f['medical_notes'],
                              labresults: f['lab_results'],
                              prescription: f['prescription'],
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
    int port,
    Details details,
    String sender,
    String receiver,
  ) async {
    final timestamp = DateTime.now();
    Map<String, dynamic> transaction = {
      "details": {
        "lab_results": details.labresults.toList(),
        "medical_notes": details.medicalnotes.toList(),
        "prescription": details.prescription.toList(),
      },
      "receiver": receiver,
      "timestamp": timestamp.toIso8601String(),
    };
    try {
      final url = '${secrets.apiurl}:$port/add_transaction';
      await http.post(
        url,
        body: json.encode(transaction),
        headers: {
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> getPatientChain(int port, String patientKey) async {
    try {
      final url = '$_apiurl:$port/patientchain';

      Map<String, String> patientrequest = {"receiver": patientKey};
      final response = await http.post(
        url,
        body: json.encode(patientrequest),
        headers: {
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
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
                    (e) => EhrTransaction.Transaction(
                      sender: e['sender'],
                      receiver: e['receiver'],
                      timestamp: DateTime.parse(e['timestamp']),
                      details: List<dynamic>.from([e['details']])
                          .map(
                            (f) => Details(
                              medicalnotes: f['medical_notes'],
                              labresults: f['lab_results'],
                              prescription: f['prescription'],
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
      _patientrecords = loadedblocks;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> mine(int port) async {
    try {
      final url = '$_apiurl:$port/mine';
      await http.post(url).timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> resolveConflicts(int port) async {
    try {
      final url = '$_apiurl:$port/resolve_conflicts';
      await http.post(url).timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
    } catch (e) {}
  }

  Future<void> getOpenTransactions(int port) async {
    try {
      final url = '$_apiurl:$port/get_opentransactions';
      final response = await http.get(url).timeout(const Duration(seconds: 30),
          onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });

      final extractedData = json.decode(response.body) as List;
      final List<EhrTransaction.Transaction> loadedtransactions = [];
      extractedData.forEach(
        (transaction) {
          loadedtransactions.add(
            EhrTransaction.Transaction(
              sender: transaction['sender'],
              receiver: transaction['receiver'],
              timestamp: DateTime.parse(transaction['timestamp']),
              details: List<dynamic>.from([transaction['details']])
                  .map(
                    (f) => Details(
                      medicalnotes: f['medical_notes'],
                      labresults: f['lab_results'],
                      prescription: f['prescription'],
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
  Future<void> createKeys(int port) async {
    try {
      final url = '$_apiurl:$port/create_keys';
      final response = await http.post(url).timeout(const Duration(seconds: 30),
          onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      var keys = json.decode(response.body);
      _publickey = keys["public_key"];
      _privatekey = keys["private_key"];
    } catch (e) {
      throw (e);
    }
  }

//onlogin
  Future<void> loadKeys(int port) async {
    try {
      final url = '$_apiurl:$port/load_keys';
      final response = await http.get(url).timeout(const Duration(seconds: 30),
          onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      var keys = json.decode(response.body);
      _publickey = keys["public_key"];
      _privatekey = keys["private_key"];
    } catch (e) {
      throw (e);
    }
  }
}
