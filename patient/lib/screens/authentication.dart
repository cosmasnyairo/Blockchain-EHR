import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/record_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_text.dart';
import 'landingpage.dart';

enum usergender { male, female }

class Authentication extends StatefulWidget {
  final AuthAction authAction;
  Authentication(this.authAction);
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _formkey = GlobalKey<FormState>();
  final _emailnode = FocusNode();
  final _passwordnode = FocusNode();
  final _genderfocusnode = FocusNode();

  var _isLoading = false;

  Map<String, String> _authData = {
    'username': '',
    'email': '',
    'password': '',
    'gender': '',
  };

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submit() async {
    if (!_formkey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formkey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    widget.authAction == AuthAction.signup ? signupuser() : loginuser();
  }

  Future<void> loginuser() async {
    try {
      await Provider.of<UserAuthProvider>(context, listen: false).login(
        email: _authData['email'],
        password: _authData['password'],
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) => CustomAlertDialog(
          message: e.toString(),
          success: false,
        ),
      );
    }
  }

  Future<void> signupuser() async {
    try {
      final provider = Provider.of<RecordsProvider>(context, listen: false);
      await provider.createKeys();

      await Provider.of<UserAuthProvider>(context, listen: false).signup(
        name: _authData['username'],
        email: _authData['email'],
        gender: _authData['gender'],
        password: _authData['password'],
        publickey: provider.publickey,
        privatekey: provider.privatekey,
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (ctx) => CustomAlertDialog(
          message: e.toString(),
          success: false,
        ),
      );
    }
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: WillPopScope(
        onWillPop: _onBackPressed,
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
              CustomText(
                'Ehr Kenya',
                color: Colors.black,
                fontsize: 30,
                alignment: TextAlign.center,
              ),
              Form(
                key: _formkey,
                child: ListView(
                  padding: EdgeInsets.all(25),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    widget.authAction == AuthAction.signup
                        ? ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              CustomFormField(
                                labeltext: 'Username',
                                icondata: Icons.person,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Username can\'t be empty!';
                                  }
                                  return null;
                                },
                                onfieldsubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailnode);
                                },
                                onsaved: (value) {
                                  _authData['username'] = value.trim();
                                },
                              ),
                              SizedBox(height: 20)
                            ],
                          )
                        : SizedBox(),
                    CustomFormField(
                      focusNode: _emailnode,
                      labeltext: 'Email',
                      icondata: Icons.email,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.trim().isEmpty ||
                            !value.trim().contains('@') ||
                            !value.trim().endsWith('com')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onfieldsubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordnode);
                      },
                      onsaved: (value) {
                        _authData['email'] = value.trim();
                      },
                    ),
                    SizedBox(height: 20),
                    CustomFormField(
                      focusNode: _passwordnode,
                      labeltext: 'Password',
                      icondata: Icons.remove_red_eye,
                      obscuretext: true,
                      textInputAction: TextInputAction.go,
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onsaved: (value) {
                        _authData['password'] = value.trim();
                      },
                      onfieldsubmitted: (_) {
                        FocusScope.of(context).requestFocus(_genderfocusnode);
                      },
                    ),
                    SizedBox(height: 20),
                    widget.authAction == AuthAction.signup
                        ? DropdownButtonFormField(
                            focusNode: _genderfocusnode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              icon: Icon(
                                Icons.person_outline,
                                size: 25,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            hint: Text("Enter Gender"),
                            items: [
                              DropdownMenuItem(
                                child: Text("Male"),
                                value: "Male",
                              ),
                              DropdownMenuItem(
                                child: Text("Female"),
                                value: "Female",
                              ),
                            ],
                            onChanged: (value) {
                              _authData['gender'] = value;
                            },
                          )
                        : SizedBox(),
                    SizedBox(height: 30),
                    Center(
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Container(
                              width: devicewidth * 0.4,
                              child: CustomButton(
                                widget.authAction == AuthAction.signup
                                    ? 'Signup'
                                    : 'Signin',
                                _submit,
                                backgroundcolor:
                                    widget.authAction == AuthAction.signup
                                        ? Colors.red
                                        : null,
                              ),
                            ),
                    )
                  ],
                ),
              ),
              FlatButton(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.authAction == AuthAction.signup
                            ? 'Already have an account? '
                            : 'Don\'t have an account? ',
                        style: GoogleFonts.montserrat()
                            .copyWith(color: Colors.black),
                      ),
                      TextSpan(
                        text: widget.authAction == AuthAction.signup
                            ? 'Sign in'
                            : 'Sign up',
                        style: GoogleFonts.montserrat()
                            .copyWith(color: Theme.of(context).primaryColor),
                      )
                    ],
                  ),
                ),
                onPressed: widget.authAction == AuthAction.signup
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => Authentication(AuthAction.signin),
                          ),
                        )
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => Authentication(AuthAction.signup),
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
