import 'package:flutter/material.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'authentication.dart';

enum AuthAction { signin, signup }

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              height: deviceheight * 0.5,
              width: double.infinity,
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.contain,
              ),
            ),
            ListView(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                CustomText(
                  'EHR KENYA',
                  color: Colors.black,
                  fontsize: 30,
                ),
                SizedBox(height: 10),
                CustomText(
                  'Secure health records storage & sharing',
                  color: Theme.of(context).primaryColor,
                  fontsize: 18,
                ),
                Divider(endIndent: 20, thickness: 1, color: Colors.grey),
                SizedBox(height: deviceheight * 0.075),
                Center(
                  child: SizedBox(
                    width: devicewidth * 0.4,
                    child: CustomButton(
                      'Sign in',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => Authentication(AuthAction.signin),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: deviceheight * 0.025),
                Center(
                  child: SizedBox(
                    width: devicewidth * 0.4,
                    child: CustomButton(
                      'Sign up',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => Authentication(AuthAction.signup),
                        ),
                      ),
                      backgroundcolor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
