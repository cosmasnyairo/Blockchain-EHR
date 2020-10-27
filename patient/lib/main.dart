import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'add_visit.dart';
import 'providers/record_provider.dart';
import 'providers/node_provider.dart';
import 'widgets/view_transaction.dart';
import 'screen.dart';
import 'view_record.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff3FD5AE),
      systemNavigationBarColor: Color(0xff3FD5AE),
    ));
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
          'view_record': (ctx) => ViewRecord(),
          'view_transaction': (ctx) => ViewTransaction(),
          'add_visit': (ctx) => AddVisit(),
        },
      ),
    );
  }
}
