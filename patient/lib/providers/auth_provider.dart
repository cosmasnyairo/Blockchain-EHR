import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'record_provider.dart';

class UserAuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _doctorname;
  String _hospital;
  String _patientname;

  String get userid {
    return _auth.currentUser.uid;
  }

  String get doctorname {
    return _doctorname;
  }

  String get patientname {
    return _patientname;
  }

  String get hospital {
    return _hospital;
  }

  bool isLoggedIn() {
    if (_auth.currentUser == null) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> login({String email, String password}) async {
    String errorMessage;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
    String gender,
    String password,
    String publickey,
    String privatekey,
  }) async {
    String errorMessage;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user.uid)
          .set({
        'name': name,
        'email': email,
        'publickey': publickey,
        'privatekey': privatekey,
        'location': '',
        'joindate': DateTime.now().toIso8601String(),
        'gender': gender
      });
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
          errorMessage = "An undefined Error happened.";
      }
      throw errorMessage;
    }

    notifyListeners();
  }

  Future<void> editdetails({
    String name,
    String email,
    String doctorid,
    String hospital,
    String location,
  }) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser.uid)
        .update({
      'name': name,
      'email': email,
      'location': location,
    }).catchError((error) => throw error);
  }

  Future<void> getTransactiondetails(
      String doctorkey, String patientkey) async {
    final userdocument = await FirebaseFirestore.instance
        .collection('Users')
        .where('publickey', isEqualTo: patientkey)
        .get();

    final doctordocument = await FirebaseFirestore.instance
        .collection('Doctors')
        .where('publickey', isEqualTo: doctorkey)
        .get();

    _doctorname = doctordocument.docs[0].data()['name'];
    _patientname = userdocument.docs[0].data()['name'];
    _hospital = doctordocument.docs[0].data()['hospital'];

    notifyListeners();
  }
}
