import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import 'landingpage.dart';

class PendingActivation extends StatefulWidget {
  @override
  _PendingActivationState createState() => _PendingActivationState();
}

class _PendingActivationState extends State<PendingActivation> {
  bool _isloading = false;

  var username, useremail;
  var authenticated;
  var peerassigned = false;
  var assignedpeer;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies

    final provider = Provider.of<UserAuthProvider>(context, listen: false);
    setState(() {
      _isloading = true;
    });

    final details = await provider.getUserDetails(provider.userid) as List;
    username = details[0];
    useremail = details[1];
    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;

    return _isloading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LandingPage()),
                      (route) => false,
                    ).then((_) {
                      setState(() {
                        _isloading = false;
                      });
                    });
                  },
                )
              ],
            ),
            body: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: deviceheight * 0.5,
                  child: CustomImage("assets/pending.png", BoxFit.contain),
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

                      await Provider.of<UserAuthProvider>(context,
                              listen: false)
                          .finishSignup(assignedpeer, context);

                      setState(() {
                        _isloading = false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )
                : FloatingActionButton.extended(
                    onPressed: () async {
                      setState(() {
                        _isloading = true;
                      });
                      try {
                        await Provider.of<UserAuthProvider>(context,
                                listen: false)
                            .checkStatus(useremail, username);
                        setState(() {
                          _isloading = false;
                        });
                      } catch (e) {
                        final message = e[0];
                        final statuscode = e[1];
                        await showDialog(
                          context: context,
                          builder: (ctx) => CustomAlertDialog(
                            message: statuscode == 200
                                ? 'You have been assigned port $message'
                                : message,
                            success: statuscode == 200 ? true : false,
                          ),
                        );
                        if (statuscode == 200) {
                          setState(() {
                            peerassigned = true;
                            assignedpeer = message;
                          });
                        }
                        setState(() {
                          _isloading = false;
                        });
                      }
                    },
                    label: Text('Check Status'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
          );
  }
}
