import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PageData {
  final String title;
  final LottieBuilder lottieBuilder;
  final ImageProvider imageProvider;

  PageData({
    this.title,
    this.lottieBuilder,
    this.imageProvider,
  });
}

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;

    final List<PageData> pages = [
      PageData(
        title: "Choose your\ninterests",
        lottieBuilder: Lottie.asset('assets/doctor.json'),
      ),
      PageData(
        title: "Drag and\ndrop to move",
        lottieBuilder: Lottie.asset('assets/blockchain.json'),
      ),
      PageData(
          title: "Drag and\ndrop to move",
          imageProvider: AssetImage('assets/pending.png')),
    ];
    return Scaffold(
      body: ConcentricPageView(
        colors: [Theme.of(context).primaryColor, Colors.white],
        verticalPosition: 0.75,
        itemCount: 3,
        itemBuilder: (index, value) {
          PageData page = pages[index % pages.length];
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                child: page.lottieBuilder,
              ),
              Text(page.title)
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton.extended(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              label: Text('Back'),
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () {},
            ),
            FloatingActionButton.extended(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              label: Text('Next'),
              icon: Icon(Icons.arrow_forward_rounded),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
