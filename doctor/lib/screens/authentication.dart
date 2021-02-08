import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import 'landingpage.dart';
import 'splash_screen.dart';

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

  final _genderfocusnode = FocusNode();
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
      final provider = Provider.of<DoctorAuthProvider>(context, listen: false);
      await provider.login(
        email: _authData['email'],
        password: _authData['password'],
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (route) => false,
      ).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
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
      final provider = Provider.of<DoctorAuthProvider>(context, listen: false);
      await provider.signup(
        name: _authData['username'],
        email: _authData['email'],
        password: _authData['password'],
        doctorid: _authData['doctorid'],
        gender: _authData['gender'],
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
        (route) => false,
      ).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      // Navigator.of(context).popAndPushNamed('activationscreen');
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

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        child: _isLoading
            ? Scaffold(body: Center(child: CircularProgressIndicator()))
            : Scaffold(
                appBar: AppBar(
                  title: CustomText(
                    widget.authAction == AuthAction.signup
                        ? "Create account"
                        : "Sign in",
                  ),
                ),
                body: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Container(
                      height: widget.authAction == AuthAction.signin
                          ? deviceheight * 0.33
                          : deviceheight * 0.2,
                      width: double.infinity,
                      child: CustomImage('assets/peers.png', BoxFit.contain),
                    ),
                    widget.authAction == AuthAction.signin
                        ? SizedBox(height: deviceheight * 0.05)
                        : SizedBox(height: deviceheight * 0.025),
                    Form(
                      key: _formkey,
                      child: ListView(
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.all(10),
                        shrinkWrap: true,
                        children: [
                          widget.authAction == AuthAction.signup
                              ? ListView(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  children: [
                                    CustomFormField(
                                      icondata: Icons.assignment_ind,
                                      labeltext: 'Doctor id',
                                      textInputAction: TextInputAction.next,
                                      keyboardtype: TextInputType.number,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Doctor id can\'t be empty!';
                                        }
                                        return null;
                                      },
                                      onfieldsubmitted: (_) {
                                        FocusScope.of(context)
                                            .requestFocus(_usernamenode);
                                      },
                                      onsaved: (value) {
                                        _authData['doctorid'] = value.trim();
                                      },
                                    ),
                                    SizedBox(height: deviceheight * 0.025),
                                    CustomFormField(
                                      focusNode: _usernamenode,
                                      icondata: Icons.person,
                                      labeltext: 'Username',
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
                                    SizedBox(height: deviceheight * 0.025),
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
                              FocusScope.of(context)
                                  .requestFocus(_passwordnode);
                            },
                            onsaved: (value) {
                              _authData['email'] = value.trim();
                            },
                          ),
                          SizedBox(height: deviceheight * 0.025),
                          CustomFormField(
                            focusNode: _passwordnode,
                            labeltext: 'Password',
                            maxlines: 1,
                            icondata: Icons.remove_red_eye,
                            obscuretext: true,
                            textInputAction: TextInputAction.go,
                            validator: (value) {
                              if (value.isEmpty || value.length < 8) {
                                return 'Password is too short!';
                              }
                              return null;
                            },
                            onfieldsubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_genderfocusnode);
                            },
                            onsaved: (value) {
                              _authData['password'] = value.trim();
                            },
                          ),
                          widget.authAction == AuthAction.signup
                              ? SizedBox(height: deviceheight * 0.025)
                              : SizedBox(),
                          widget.authAction == AuthAction.signup
                              ? CustomFormField(
                                  focusNode: _genderfocusnode,
                                  icondata: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please choose your gender';
                                    }
                                    return null;
                                  },
                                  dropdown: true,
                                  hinttext: "Enter Gender",
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
                                  onchanged: (value) {
                                    _authData['gender'] = value;
                                  },
                                )
                              : SizedBox(),
                          SizedBox(height: deviceheight * 0.025),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RaisedButton.icon(
                              label: CustomText(
                                widget.authAction == AuthAction.signup
                                    ? 'Create account'
                                    : 'Sign in',
                              ),
                              onPressed: _submit,
                              icon: Icon(
                                widget.authAction == AuthAction.signup
                                    ? Icons.add
                                    : Icons.home,
                              ),
                              color: widget.authAction == AuthAction.signup
                                  ? Theme.of(context).errorColor
                                  : null,
                            ),
                          ),
                          SizedBox(height: deviceheight * 0.025),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              child: CustomText(
                                widget.authAction == AuthAction.signup
                                    ? 'Already have an account? Sign in '
                                    : 'Don\'t have an account? Sign up',
                                alignment: TextAlign.left,
                              ),
                              onTap: widget.authAction == AuthAction.signup
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              Authentication(AuthAction.signin),
                                        ),
                                      );
                                    }
                                  : () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              Authentication(AuthAction.signup),
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
      ),
    );
  }
}
