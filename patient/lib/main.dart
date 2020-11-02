import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'add_visit.dart';
import 'providers/record_provider.dart';
import 'providers/node_provider.dart';
import 'records_detail.dart';
import 'visit_details.dart';
import 'screen.dart';

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
        title: 'EhrPatient',
        theme: ThemeData(
          primaryColor: Color(0xff3FD5AE),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        home: Screen(),
        routes: {
          'records_detail': (ctx) => RecordsDetail(),
          'visit_detail': (ctx) => VisitDetails(),
          'add_visit': (ctx) => AddVisit(),
        },
      ),
    );
  }
}
