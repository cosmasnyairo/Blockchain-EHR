import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'add_visit.dart';
import 'edit_account.dart';
import 'landingpage.dart';
import 'providers/record_provider.dart';
import 'providers/node_provider.dart';
import 'records_detail.dart';
import 'visit_details.dart';
import 'screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primarycolor = Color(0xff3FD5AE);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff3FD5AE),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => RecordsProvider()),
        ChangeNotifierProvider(create: (ctx) => NodeProvider()),
        ChangeNotifierProvider(create: (ctx) => UserAuthProvider())
      ],
      child: Consumer<UserAuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EhrPatient',
          theme: ThemeData(
            canvasColor: Colors.white,
            primaryColor: primarycolor,
            accentColor: Colors.redAccent,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            buttonTheme: ButtonThemeData(
              buttonColor: primarycolor,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            appBarTheme: AppBarTheme(
              color: Colors.white,
              centerTitle: true,
              elevation: 0,
            ),
            textTheme: GoogleFonts.montserratTextTheme(),
            primaryTextTheme: GoogleFonts.montserratTextTheme(),
          ),
          home: auth.isLoggedIn() ? Screen() : LandingPage(),
          routes: {
            'records_detail': (ctx) => RecordsDetail(),
            'add_visit': (ctx) => AddVisit(),
            'edit_account': (ctx) => EditAccount()
          },
        ),
      ),
    );
  }
}
