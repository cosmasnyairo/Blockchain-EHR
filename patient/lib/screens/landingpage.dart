import 'package:flutter/material.dart';

import '../widgets/custom_image.dart';
import '../widgets/custom_text.dart';
import 'authentication.dart';

enum AuthAction { signin, signup }

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;
    final actionsiconslist = [Icons.add, Icons.home];
    final actionstitlelist = ['Create account', 'Sign in'];
    final actionslist = [
      () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => Authentication(AuthAction.signup),
            ),
          ),
      () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => Authentication(AuthAction.signin),
            ),
          ),
    ];
    final actionscolorlist = [
      Theme.of(context).errorColor,
      Theme.of(context).primaryColor
    ];
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Container(
              height: deviceheight * 0.5,
              width: double.infinity,
              child: CustomImage('assets/peers.png', BoxFit.contain),
            ),
            SizedBox(height: deviceheight * 0.025),
            CustomText(
              'EHR KENYA',
              fontsize: 30,
            ),
            SizedBox(height: deviceheight * 0.025),
            CustomText(
              'Secure health records storage & sharing',
              fontsize: 18,
            ),
            Divider(thickness: 2, color: Colors.grey),
            SizedBox(height: deviceheight * 0.05),
            GridView.builder(
              physics: ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1.5,
                crossAxisCount: 2,
                crossAxisSpacing: 20,
              ),
              shrinkWrap: true,
              itemCount: actionstitlelist.length,
              itemBuilder: (ctx, i) => Card(
                color: actionscolorlist[i],
                child: InkWell(
                  onTap: actionslist[i],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridTile(
                      child: Icon(actionsiconslist[i], color: Colors.black),
                      footer: CustomText(actionstitlelist[i],
                          alignment: TextAlign.center),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
