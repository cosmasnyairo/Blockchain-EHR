import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/node_provider.dart';
import 'providers/record_provider.dart';
import 'screens/add_record.dart';
import 'screens/add_visit.dart';
import 'screens/edit_account.dart';
import 'screens/ehr_information.dart';
import 'screens/landingpage.dart';
import 'screens/pending_activation.dart';
import 'screens/screen.dart';
import 'screens/settings.dart';
import 'screens/view_open_transactions.dart';

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
        ChangeNotifierProvider(create: (ctx) => DoctorAuthProvider())
      ],
      child: Consumer<DoctorAuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'EhrDoctor',
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
          home: auth.isLoggedIn()
              ? auth.authenticated
                  ? Screen()
                  : PendingActivation()
              : LandingPage(),
          // home: OnboardingScreen(),
          routes: {
            'add_record': (ctx) => AddRecord(),
            'view_open_transaction': (ctx) => ViewOpenTransactions(),
            'add_visit': (ctx) => AddVisit(),
            'edit_account': (ctx) => EditAccount(),
            'settings_page': (ctx) => SettingsPage(),
            'ehr_information': (ctx) => EhrInformationPage(),
            //to implement onboarding screen
            // 'landing_page': (ctx) => LandingPage()
          },
        ),
      ),
    );
  }
}
