import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:doctor/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'record_provider.dart';

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
    String username,
    String email,
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
      username: username,
      email: email,
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
      name: userdata['name'],
      email: userdata['email'],
      privatekey: userdata['privatekey'],
      publickey: userdata['publickey'],
      imageurl: userdata['imageurl'],
      joindate: userdata['joindate'],
      location: userdata['location'],
    );
    _user = loadeduser;
  }

  Future<void> createuserdata({
    String username,
    String email,
    String id,
    context,
  }) async {
    final provider = Provider.of<RecordsProvider>(context, listen: false);
    await provider.createKeys();
    _user = EhrUser(
      name: username,
      email: email,
      publickey: provider.publickey,
      privatekey: provider.privatekey,
      joindate: DateTime.now().toIso8601String(),
      location: 'Kenya',
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
    });
    notifyListeners();
  }
}
