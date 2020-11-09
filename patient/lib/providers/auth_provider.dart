import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'record_provider.dart';

import 'package:patient/models/user.dart';

class UserAuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  EhrUser _user;

  EhrUser get user {
    return _user;
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
    fetchuserdata();
    notifyListeners();
  }

  Future<void> signup({
    String name,
    String email,
    String gender,
    String password,
    BuildContext context,
  }) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    createuserdata(
      id: userCredential.user.uid,
      name: name,
      email: email,
      gender: gender,
      context: context,
    );
    notifyListeners();
  }

  Future<void> fetchuserdata() async {
    DocumentSnapshot userdatasnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser.uid)
        .get();
    Map<String, dynamic> userdata = userdatasnapshot.data();
    final loadeduser = EhrUser(
      name:
          ('${userdata['name'][0].toUpperCase()}${userdata['name'].substring(1)}'),
      email: userdata['email'].toLowerCase(),
      privatekey: userdata['privatekey'],
      publickey: userdata['publickey'],
      imageurl: userdata['imageurl'],
      joindate: userdata['joindate'],
      gender: userdata['gender'],
      location:
          ('${userdata['location'][0].toUpperCase()}${userdata['location'].substring(1)}'),
    );
    _user = loadeduser;
  }

  Future<void> createuserdata({
    String name,
    String email,
    String gender,
    String id,
    context,
  }) async {
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    await provider.createKeys();
    _user = EhrUser(
      name: name,
      email: email,
      publickey: provider.publickey,
      privatekey: provider.privatekey,
      joindate: DateTime.now().toIso8601String(),
      location: 'Kenya',
      gender: gender,
      imageurl: '',
    );
    await FirebaseFirestore.instance.collection('Users').doc(id).set({
      'name': _user.name,
      'email': _user.email,
      'publickey': _user.publickey,
      'privatekey': _user.privatekey,
      'imageurl': _user.imageurl,
      'location': _user.location,
      'joindate': _user.joindate,
      'gender': _user.gender
    });
    notifyListeners();
  }
}
