import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/block.dart';
import '../models/details.dart';
import '../models/transaction.dart' as EhrTransaction;
import '../secrets.dart' as secrets;
import 'auth_provider.dart';

class RecordsProvider with ChangeNotifier {
  final String _apiurl = secrets.url;

  String _publickey;
  String _privatekey;

  int _peernode;
  List<Block> _records = [];
  List<EhrTransaction.Transaction> _opentransactions = [];

  List<Block> get records {
    return [..._records];
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
    final userid = Provider.of<UserAuthProvider>(context, listen: false).userid;
    final peernode = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userid)
        .get()
        .then((f) {
      return f['peer_node'];
    });
    _peernode = peernode;
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
      ).timeout(const Duration(seconds: 10), onTimeout: () {
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

//signup
  Future<void> createKeys(
    int port,
  ) async {
    try {
      final url = '$_apiurl:$port/create_keys';
      final response = await http.post(url).timeout(const Duration(seconds: 10),
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

  Future<void> resolveConflicts(
    int port,
  ) async {
    try {
      final url = '$_apiurl:$port/resolve_conflicts';
      await http.post(url).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
    } catch (e) {}
  }

//onlogin
  Future<void> loadKeys(
    int port,
  ) async {
    try {
      final url = '$_apiurl:$port/load_keys';
      final response = await http.get(url).timeout(const Duration(seconds: 10),
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

  Future<void> mine(
    int port,
  ) async {
    try {
      final url = '$_apiurl:$port/mine';
      await http.post(url).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
    } catch (e) {
      throw e;
    }
  }
}
