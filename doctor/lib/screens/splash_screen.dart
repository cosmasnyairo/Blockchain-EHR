import 'package:doctor/providers/auth_provider.dart';
import 'package:doctor/screens/pending_activation.dart';
import 'package:doctor/screens/screen.dart';
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
    print(provider.authenticated);
    setState(() {
      _isloading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DoctorAuthProvider>(context);
    return _isloading
        ? Scaffold(
            body: Center(child: CustomText('SPLASH')),
          )
        : provider.authenticated
            ? Screen()
            : PendingActivation();
  }
}
