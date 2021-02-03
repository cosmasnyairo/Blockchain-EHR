import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient/providers/auth_provider.dart';
import 'package:patient/screens/screen.dart';
import 'package:patient/widgets/custom_text.dart';
import 'package:provider/provider.dart';

import 'pending_activation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isloading;
  @override
  void didChangeDependencies() async {
    setState(() {
      _isloading = true;
    });
    final provider = Provider.of<UserAuthProvider>(context, listen: false);
    await provider.isAuthenticated();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) =>
            provider.authenticated ? Screen() : PendingActivation(),
      ),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
          alignment: Alignment.center,
          height: deviceheight,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                height: deviceheight * 0.33,
                child: Image.asset(
                  'assets/background.png',
                  fit: BoxFit.contain,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: deviceheight * 0.025),
              Center(child: CircularProgressIndicator())
            ],
          ),
        ),
      ),
    );
  }
}
