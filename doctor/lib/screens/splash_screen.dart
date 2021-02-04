import 'package:doctor/providers/auth_provider.dart';
import 'package:doctor/screens/pending_activation.dart';
import 'package:doctor/screens/screen.dart';
import 'package:doctor/widgets/custom_image.dart';
import 'package:doctor/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final provider = Provider.of<DoctorAuthProvider>(context, listen: false);
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
                height: deviceheight * 0.2,
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
