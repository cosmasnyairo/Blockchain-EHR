import 'package:doctor/providers/record_provider.dart';
import 'package:doctor/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'landingpage.dart';

import 'providers/auth_provider.dart';

import 'widgets/alert_dialog.dart';
import 'widgets/custom_text.dart';

class Authentication extends StatefulWidget {
  final AuthAction authAction;
  Authentication(this.authAction);
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _formkey = GlobalKey<FormState>();
  final _usernamenode = FocusNode();
  final _emailnode = FocusNode();
  final _passwordnode = FocusNode();

  var _isLoading = false;

  Map<String, String> _authData = {
    'username': '',
    'email': '',
    'password': '',
    'doctorid': ''
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
      await Provider.of<DoctorAuthProvider>(context, listen: false).login(
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

      await Provider.of<DoctorAuthProvider>(context, listen: false).signup(
        name: _authData['username'],
        email: _authData['email'],
        password: _authData['password'],
        doctorid: _authData['doctorid'],
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
          body: ListView(
            children: [
              Container(
                height: deviceheight * 0.3,
                width: double.infinity,
                child: Image.asset(
                  'assets/background.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: deviceheight * 0.05),
              CustomText(
                'Ehr Kenya',
                color: Colors.black,
                fontsize: 30,
                alignment: TextAlign.center,
              ),
              SizedBox(height: 10),
              Form(
                key: _formkey,
                child: ListView(
                  padding: EdgeInsets.all(25),
                  shrinkWrap: true,
                  children: [
                    widget.authAction == AuthAction.signup
                        ? Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(
                                    Icons.assignment_ind,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  labelText: 'Doctor id',
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Doctor id can\'t be empty!';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_usernamenode);
                                },
                                onSaved: (value) {
                                  _authData['doctorid'] = value.trim();
                                },
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                focusNode: _usernamenode,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(
                                    Icons.person,
                                    size: 25,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  labelText: 'Username',
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Username can\'t be empty!';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_emailnode);
                                },
                                onSaved: (value) {
                                  _authData['username'] = value.trim();
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                          )
                        : SizedBox(),
                    TextFormField(
                      focusNode: _emailnode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        icon: Icon(
                          Icons.email,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.trim().isEmpty ||
                            !value.trim().contains('@') ||
                            !value.trim().endsWith('com')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordnode);
                      },
                      onSaved: (value) {
                        _authData['email'] = value.trim();
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      focusNode: _passwordnode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        icon: Icon(
                          Icons.remove_red_eye,
                          size: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.go,
                      validator: (value) {
                        if (value.isEmpty || value.length < 8) {
                          return 'Password is too short!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['password'] = value.trim();
                      },
                    ),
                    SizedBox(height: 20),
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
