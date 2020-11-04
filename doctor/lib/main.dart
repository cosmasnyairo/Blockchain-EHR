import 'package:doctor/landingpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'add_record.dart';
import 'providers/record_provider.dart';
import 'providers/node_provider.dart';
import 'records_detail.dart';
import 'screen.dart';
import 'add_visit.dart';
import 'view_open_transactions.dart';
import 'visit_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff3FD5AE),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => RecordsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NodeProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EhrDoctor',
        theme: ThemeData(
          primaryColor: Color(0xff3FD5AE),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LandingPage(),
        routes: {
          'records_detail': (ctx) => RecordsDetail(),
          'visit_detail': (ctx) => VisitDetails(),
          'add_record': (ctx) => AddRecord(),
          'view_open_transaction': (ctx) => ViewOpenTransactions(),
          'add_visit': (ctx) => AddVisit(),

          //to implement onboarding screen
          // 'landing_page': (ctx) => LandingPage()
        },
      ),
    );
  }
}
