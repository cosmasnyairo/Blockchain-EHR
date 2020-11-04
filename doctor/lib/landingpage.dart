import 'package:doctor/authentication.dart';
import 'package:doctor/widgets/custom_button.dart';
import 'package:doctor/widgets/custom_text.dart';
import 'package:flutter/material.dart';

enum AuthAction { signin, signup }

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: deviceheight,
          child: Column(
            children: [
              Container(
                height: deviceheight * 0.5,
                width: double.infinity,
                child: Image.asset(
                  'assets/landing_background.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.centerRight,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
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
                    SizedBox(height: 20),
                    Container(
                      height: deviceheight * 0.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: devicewidth * 0.4,
                            child: CustomButton(
                              'Sign up',
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      Authentication(AuthAction.signup),
                                ),
                              ),
                              backgroundcolor: Colors.red,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: devicewidth * 0.4,
                            child: CustomButton(
                              'Sign in',
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) =>
                                      Authentication(AuthAction.signin),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Stack(
        //   children: [
        //     Container(
        //       width: double.infinity,
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage('assets/landing_background.png'),
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //     Positioned(
        //       top: deviceheight * 0.5,
        //       left: 20,
        //       right: 20,
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [

        //         ],
        //       ),
        //     ),
        //     Positioned(
        //       bottom: deviceheight * 0.15,
        //       width: devicewidth,
        //       child:
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
