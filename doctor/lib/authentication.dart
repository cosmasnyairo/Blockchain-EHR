import 'package:doctor/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'landingpage.dart';
import 'widgets/custom_text.dart';

class Authentication extends StatefulWidget {
  final AuthAction authAction;
  Authentication(this.authAction);
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;

    Future<bool> _onBackPressed() {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Container(
            height: deviceheight,
            child: ListView(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Container(
                      height: deviceheight * 0.3,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/auth_background.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                    FlatButton.icon(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: _onBackPressed,
                      label: CustomText(
                        'Back',
                        fontsize: 16,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: CustomText(
                    'Ehr Kenya',
                    color: Colors.black,
                    fontsize: 30,
                  ),
                ),
                SizedBox(height: 10),
                Form(
                  child: ListView(
                    padding: EdgeInsets.all(25),
                    shrinkWrap: true,
                    children: [
                      widget.authAction == AuthAction.signup
                          ? CustomText('UserName')
                          : SizedBox(),
                      widget.authAction == AuthAction.signup
                          ? SizedBox(height: 10)
                          : SizedBox(),
                      widget.authAction == AuthAction.signup
                          ? TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.black12,
                                filled: true,
                              ),
                              textInputAction: TextInputAction.next,
                            )
                          : SizedBox(),
                      SizedBox(height: 10),
                      CustomText('Email'),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Colors.black12,
                          filled: true,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      SizedBox(height: 10),
                      CustomText('Password'),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          fillColor: Colors.black12,
                          filled: true,
                        ),
                        textInputAction: TextInputAction.go,
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Container(
                          width: devicewidth * 0.4,
                          child: widget.authAction == AuthAction.signup
                              ? CustomButton(
                                  'Signup',
                                  () {},
                                  backgroundcolor: Colors.red,
                                )
                              : CustomButton(
                                  'Signin',
                                  () {},
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            child: Container(
              height: deviceheight * 0.05,
              child: Center(
                child: widget.authAction == AuthAction.signup
                    ? FlatButton(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.montserrat()
                                    .copyWith(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'Sign in',
                                style: GoogleFonts.montserrat().copyWith(
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => Authentication(AuthAction.signin),
                          ),
                        ),
                      )
                    : FlatButton(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Don\'t have an account? ',
                                style: GoogleFonts.montserrat()
                                    .copyWith(color: Colors.black),
                              ),
                              TextSpan(
                                text: ' Sign up',
                                style: GoogleFonts.montserrat().copyWith(
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => Authentication(AuthAction.signup),
                          ),
                        ),
                      ),
              ),
            ),
            elevation: 0,
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
