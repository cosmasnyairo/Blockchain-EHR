import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'landingpage.dart';

import 'providers/auth_provider.dart';

import 'widgets/custom_button.dart';
import 'widgets/custom_text.dart';

enum usergender { male, female }

class Authentication extends StatefulWidget {
  final AuthAction authAction;
  Authentication(this.authAction);
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _formkey = GlobalKey<FormState>();

  final _gendernode = FocusNode();

  final _emailnode = FocusNode();
  final _passwordnode = FocusNode();

  var _isLoading = false;
  int _value = 1;

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
    if (widget.authAction == AuthAction.signup) {
      // signin
      try {
        await Provider.of<UserAuthProvider>(context, listen: false).signup(
          name: _authData['username'],
          email: _authData['email'],
          gender: _authData['gender'],
          password: _authData['password'],
          context: context,
        );
        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        print(e);
      }
    } else {
      //signup
      try {
        await Provider.of<UserAuthProvider>(context, listen: false).login(
          email: _authData['email'],
          password: _authData['password'],
          context: context,
        );
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        print(e);
      }

      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
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
                  key: _formkey,
                  child: ListView(
                    padding: EdgeInsets.all(25),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      widget.authAction == AuthAction.signup
                          ? Column(
                              children: [
                                TextFormField(
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
                                SizedBox(height: 20)
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
                      widget.authAction == AuthAction.signup
                          ? DropdownButtonFormField(
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
                widget.authAction == AuthAction.signup
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
