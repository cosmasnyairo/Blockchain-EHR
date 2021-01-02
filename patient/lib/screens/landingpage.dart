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
              height: deviceheight * 0.4,
              width: double.infinity,
              child: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
              ),
            ),
            ListView(
              padding: EdgeInsets.all(20),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                CustomText(
                  'Ehr Kenya',
                  color: Colors.black,
                  fontsize: 40,
                ),
                SizedBox(height: 10),
                CustomText(
                  'Store your medical records securely',
                  color: Theme.of(context).primaryColor,
                  fontsize: 18,
                ),
                CustomText(
                  'Health record storage made easier',
                  color: Colors.red,
                  fontsize: 16,
                ),
                Divider(thickness: 1.5, color: Colors.black),
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
