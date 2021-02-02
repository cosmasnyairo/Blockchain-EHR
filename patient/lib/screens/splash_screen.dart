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
    print(provider.authenticated);
    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserAuthProvider>(context);
    return _isloading
        ? Scaffold(
            body: Center(child: CustomText('SPLASH')),
          )
        : provider.authenticated
            ? Screen()
            : PendingActivation();
  }
}
