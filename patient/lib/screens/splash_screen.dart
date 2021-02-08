import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/screen.dart';
import '../widgets/custom_image.dart';
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
                child: CustomImage('assets/background.png', BoxFit.contain),
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
