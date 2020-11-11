import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'record_provider.dart';

class DoctorAuthProvider extends ChangeNotifier {
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

  Future<void> login({
    String email,
    String password,
    BuildContext context,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    notifyListeners();
  }

  Future<void> signup({
    String name,
    String email,
    String doctorid,
    String password,
    BuildContext context,
  }) async {
    UserCredential doctorCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    createdoctordata(
      id: doctorCredential.user.uid,
      name: name,
      email: email,
      doctorid: doctorid,
      context: context,
    );
    notifyListeners();
  }

  Future<void> createdoctordata({
    String name,
    String email,
    String doctorid,
    String id,
    context,
  }) async {
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    await provider.createKeys();
    await FirebaseFirestore.instance.collection('Doctors').doc(id).set({
      'name': name,
      'email': email,
      'publickey': provider.publickey,
      'privatekey': provider.privatekey,
      'location': '',
      'joindate': DateTime.now().toIso8601String(),
      'doctorid': doctorid,
      'hospital': '',
    });
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
        .collection('Doctors')
        .doc(_auth.currentUser.uid)
        .update({
      'name': name,
      'email': email,
      'doctorid': doctorid,
      'hospital': hospital,
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
