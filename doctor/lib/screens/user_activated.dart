import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/providers/auth_provider.dart';
import 'package:doctor/screens/profile.dart';
import 'package:doctor/widgets/alert_dialog.dart';
import 'package:doctor/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_visit.dart';
import 'homepage.dart';

class UserActivated extends StatefulWidget {
  @override
  _UserActivatedState createState() => _UserActivatedState();
}

class _UserActivatedState extends State<UserActivated> {
  bool _isloading = false;

  var username, useremail;
  var authenticated;
  var peerassigned = false;
  var assigned_peer;
  Future<void> getUserDetails(String userid) async {
    await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(userid)
        .get()
        .then((f) {
      username = f['name'];
      useremail = f['email'];
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    final provider = Provider.of<DoctorAuthProvider>(context, listen: false);
    setState(() {
      _isloading = true;
    });
    authenticated = await provider.isAuthenticated();
    await getUserDetails(provider.userid);
    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  int _currentindex = 0;

  List<Map<String, Object>> _pages;

  @override
  void initState() {
    _pages = [
      {
        'page': HomePage(),
      },
      {
        'page': AddVisit(),
      },
      {
        'page': ProfilePage(),
      },
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;

    return _isloading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : authenticated
            ? Scaffold(
                body: _pages[_currentindex]['page'],
                bottomNavigationBar: BottomNavigationBar(
                  onTap: (index) {
                    setState(() {});
                    _currentindex = index;
                  },
                  currentIndex: _currentindex,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Theme.of(context).primaryColor,
                  selectedItemColor: Colors.black,
                  unselectedItemColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      title: CustomText('Home'),
                      icon: Icon(Icons.home),
                    ),
                    BottomNavigationBarItem(
                      title: CustomText('Add visit'),
                      icon: Icon(Icons.people),
                    ),
                    BottomNavigationBarItem(
                      title: CustomText('Profile'),
                      icon: Icon(Icons.person),
                    )
                  ],
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  actions: [
                    IconButton(
                      padding: EdgeInsets.all(20),
                      icon: Icon(Icons.exit_to_app),
                      iconSize: 30,
                      color: Theme.of(context).errorColor,
                      onPressed: () async {
                        setState(() {
                          _isloading = true;
                        });
                        await Provider.of<DoctorAuthProvider>(context,
                                listen: false)
                            .logout();
                        setState(() {
                          _isloading = false;
                        });
                      },
                    )
                  ],
                ),
                body: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Container(
                      height: deviceheight * 0.5,
                      child: Image.asset(
                        "assets/base.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    CustomText(
                      'Hi. $username',
                      fontsize: 18,
                      fontweight: FontWeight.bold,
                      alignment: TextAlign.center,
                    ),
                    SizedBox(height: deviceheight * 0.025),
                    CustomText(
                      'Your information has been received!',
                      fontsize: 16,
                      alignment: TextAlign.center,
                    ),
                    SizedBox(height: deviceheight * 0.025),
                    CustomText(
                      'You will receive an email when your details have been activated',
                      alignment: TextAlign.center,
                    ),
                  ],
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: peerassigned
                    ? FloatingActionButton.extended(
                        label: Text('Continue'),
                        onPressed: () async {
                          setState(() {
                            _isloading = true;
                          });
                          
                          await Provider.of<DoctorAuthProvider>(context,
                                  listen: false)
                              .finishSignup(assigned_peer, context);

                          setState(() {
                            authenticated = true;
                            _isloading = false;
                          });
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      )
                    : FloatingActionButton.extended(
                        onPressed: () async {
                          setState(() {
                            _isloading = true;
                          });
                          try {
                            await Provider.of<DoctorAuthProvider>(context,
                                    listen: false)
                                .checkStatus(useremail);
                          } catch (e) {
                            await showDialog(
                              context: context,
                              builder: (ctx) => CustomAlertDialog(
                                message: e[1] == 200
                                    ? 'You have been assigned port ${e[0].toString()}'
                                    : e[0].toString(),
                                success: e[1] == 200 ? true : false,
                              ),
                            );
                            if (e[1] == 200) {
                              setState(() {
                                peerassigned = true;
                                assigned_peer = e[0];
                              });
                            }
                            // add user details to firestore and log them in
                          }
                          setState(() {
                            _isloading = false;
                          });
                        },
                        label: Text('Check Status'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
              );
  }
}
