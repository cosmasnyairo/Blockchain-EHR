import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/providers/record_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/doctor.dart';

import '../secrets.dart' as secrets;
import 'node_provider.dart';

class DoctorAuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  EhrDoctor _ehrDoctor;

  EhrDoctor get ehrDoctor {
    return _ehrDoctor;
  }

  String get userid {
    return _auth.currentUser.uid;
  }

  bool isLoggedIn() {
    if (_auth.currentUser == null) {
      return false;
    }
    return true;
  }

  Future<bool> isAuthenticated() async {
    final authenticated = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(userid)
        .get()
        .then((f) {
      return f['authenticated'];
    });
    if (authenticated == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> checkStatus(String email) async {
    final url = '${secrets.apiurl}:2/check_status';
    try {
      final response = await http.post(
        url,
        body: json.encode({"useremail": email}),
        headers: {
          "Content-Type": "application/json",
        },
      );
      throw [json.decode(response.body)['message'], response.statusCode];
    } catch (e) {
      throw e;
      // TODO
    }
  }

  Future<void> finishSignup(int port, BuildContext context) async {
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    await provider.createKeys(port);
    await FirebaseFirestore.instance.collection('Doctors').doc(userid).update({
      'authenticated': true,
      'privatekey': provider.privatekey,
      'publickey': provider.publickey,
      'peer_node': port
    });
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> login({String email, String password}) async {
    String errorMessage;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await isAuthenticated();
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "You entered an invalid email.";
          break;
        case "wrong-password":
          errorMessage = "You entered a wrong password.";
          break;
        case "user-not-found":
          errorMessage = "User doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User accountdisabled.";
          break;
        case "operation-not-allowed":
          errorMessage = "Too many requests please try again later.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      throw errorMessage;
    }

    notifyListeners();
  }

  Future<void> signup({
    String name,
    String email,
    String doctorid,
    String password,
    String publickey,
    String privatekey,
  }) async {
    String errorMessage;
    try {
      UserCredential doctorCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await FirebaseFirestore.instance
          .collection('Doctors')
          .doc(doctorCredential.user.uid)
          .set({
        'name': name,
        'email': email,
        'location': '',
        'joindate': DateTime.now().toIso8601String(),
        'doctorid': doctorid,
        'hospital': '',
        'authenticated': false
      });
      Map<String, dynamic> userdata = {"username": name, "useremail": email};
      final url = '${secrets.apiurl}:2/assign';
      await http.post(
        url,
        body: json.encode(userdata),
        headers: {
          "Content-Type": "application/json",
        },
      );
    } catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "You entered an invalid email.";
          break;
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          errorMessage = "Email is already in use.";
          break;
        case "user-disabled":
          errorMessage = "User accountdisabled.";
          break;
        case "operation-not-allowed":
          errorMessage = "Too many requests please try again later.";
          break;
        default:
          errorMessage = error;
      }
      throw errorMessage;
    }

    notifyListeners();
  }

  void fetchdoctordetails(DocumentSnapshot snapshot) {
    _ehrDoctor = EhrDoctor(
      name: snapshot['name'],
      doctorid: snapshot['doctorid'],
      email: snapshot['email'],
      hospital: snapshot['hospital'],
      location: snapshot['location'],
    );
  }

  Future<void> editdetails({
    String name,
    String email,
    String doctorid,
    String hospital,
    String location,
  }) async {
    await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(_auth.currentUser.uid)
        .update({
      'name': name,
      'email': email,
      'doctorid': doctorid,
      'hospital': hospital,
      'location': location,
    }).catchError((error) => throw error);
    _ehrDoctor = EhrDoctor(
      name: name,
      doctorid: doctorid,
      email: email,
      hospital: hospital,
      location: location,
    );
    notifyListeners();
  }

  // Future<void> getTransactiondetails(
  //     String doctorkey, String patientkey) async {
  //   final userdocument = await FirebaseFirestore.instance
  //       .collection('Users')
  //       .where('publickey', isEqualTo: patientkey)
  //       .get();

  //   final doctordocument = await FirebaseFirestore.instance
  //       .collection('Doctors')
  //       .where('publickey', isEqualTo: doctorkey)
  //       .get();

  //   _doctorname = doctordocument.docs[0].data()['name'];
  //   _patientname = userdocument.docs[0].data()['name'];
  //   _hospital = doctordocument.docs[0].data()['hospital'];

  //   notifyListeners();
  // }
}
