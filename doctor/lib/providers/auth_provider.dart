import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:doctor/models/doctor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'record_provider.dart';

class DoctorAuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  EhrDoctor _doctor;

  EhrDoctor get doctor {
    return _doctor;
  }

  bool isLoggedIn() {
    if (_auth.currentUser == null) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    print('signout');
    await _auth.signOut();
    notifyListeners();
  }

  Future<void> login({
    String email,
    String password,
    BuildContext context,
  }) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    fetchdoctordata();
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

  Future<void> fetchdoctordata() async {
    DocumentSnapshot doctordatasnapshot = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(_auth.currentUser.uid)
        .get();
    Map<String, dynamic> doctordata = doctordatasnapshot.data();
    final loadeddoctor = EhrDoctor(
      name:
          ('${doctordata['name'][0].toUpperCase()}${doctordata['name'].substring(1)}'),
      email: doctordata['email'].toLowerCase(),
      privatekey: doctordata['privatekey'],
      publickey: doctordata['publickey'],
      imageurl: doctordata['imageurl'],
      joindate: DateTime.parse(doctordata['joindate']),
      doctorid: doctordata['doctorid'],
      hospital: doctordata['hospital'],
      location:
          ('${doctordata['location'][0].toUpperCase()}${doctordata['location'].substring(1)}'),
    );
    _doctor = loadeddoctor;
  }

  Future<void> createdoctordata({
    String name,
    String email,
    String doctorid,
    String hospital,
    String id,
    context,
  }) async {
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    await provider.createKeys();
    _doctor = EhrDoctor(
      name: name,
      email: email,
      publickey: provider.publickey,
      privatekey: provider.privatekey,
      joindate: DateTime.now(),
      location: 'Kenya',
      doctorid: doctorid,
      hospital: '',
      imageurl: '',
    );
    await FirebaseFirestore.instance.collection('Doctors').doc(id).set({
      'name': _doctor.name,
      'email': _doctor.email,
      'publickey': _doctor.publickey,
      'privatekey': _doctor.privatekey,
      'imageurl': _doctor.imageurl,
      'location': _doctor.location,
      'joindate': _doctor.joindate.toIso8601String(),
      'doctorid': _doctor.doctorid,
      'hospital': _doctor.hospital,
    });
    notifyListeners();
  }
}
