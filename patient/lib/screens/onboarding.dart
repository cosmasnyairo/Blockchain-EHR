import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../widgets/custom_floating_action_button.dart';
import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentindex;

  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;

    final List<Map<String, String>> _pages = [
      {
        "title": "Easy and secure health record access and sharing",
        "image": 'assets/medical_notes.png',
      },
      {
        "title": "Security enforced by trusted connected nodes",
        "image": 'assets/peers.png',
      },
      {
        "title": "Interoperability for access to up-to-date health records",
        "image": 'assets/pending.png',
      }
    ];
    return SafeArea(
      child: _isloading
          ? Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              body: PageView.builder(
                itemCount: _pages.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentindex = index;
                  });
                },
                itemBuilder: (_, index) {
                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(40),
                    children: [
                      SizedBox(height: deviceheight * 0.15),
                      Container(
                        height: deviceheight * 0.25,
                        child: CustomImage(
                          _pages[index]['image'],
                          BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: deviceheight * 0.15),
                      CustomText(
                        _pages[index]['title'],
                        alignment: TextAlign.center,
                        fontsize: 18,
                        fontweight: FontWeight.w500,
                      ),
                      SizedBox(height: deviceheight * 0.15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => buildDots(index, context),
                        ),
                      ),
                    ],
                  );
                },
              ),
              floatingActionButton:
                  CustomFAB('Skip', Icons.navigate_next, () async {
                setState(() {
                  _isloading = true;
                });
                await Provider.of<UserAuthProvider>(context, listen: false)
                    .showOnboarding(false)
                    .then((_) {
                  setState(() {
                    _isloading = false;
                  });
                });
              }),
            ),
    );
  }

  Container buildDots(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentindex == index ? 30 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
