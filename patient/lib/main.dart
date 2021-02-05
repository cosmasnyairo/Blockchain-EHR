import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:patient/screens/onboarding.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/node_provider.dart';
import 'providers/record_provider.dart';
import 'screens/add_visit.dart';
import 'screens/edit_account.dart';
import 'screens/ehrinformation.dart';
import 'screens/landingpage.dart';
import 'screens/libraries_used.dart';
import 'screens/settings.dart';
import 'screens/screen.dart';
import 'screens/pending_activation.dart';
import 'screens/splash_screen.dart';
import 'theme/customtheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // precacheImage(AssetImage('assets/male_patient.png'), context);
    // precacheImage(AssetImage('assets/female_patient.png'), context);
    // precacheImage(AssetImage('assets/auth_background.png'), context);
    // precacheImage(AssetImage('assets/landing_background.png'), context);

    final primarycolor = Color(0xff3FD5AE);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Color(0xff3FD5AE),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CustomThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => RecordsProvider()),
        ChangeNotifierProvider(create: (ctx) => NodeProvider()),
        ChangeNotifierProvider(create: (ctx) => UserAuthProvider())
      ],
      child: Consumer<CustomThemeProvider>(
        builder: (ctx, theme, _) => Consumer<UserAuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EhrPatient',
            theme: theme.chosentheme,
            home: auth.isLoggedIn
                ? SplashScreen()
                : auth.shownboarding
                    ? OnboardingScreen()
                    : LandingPage(),
            routes: {
              'add_visit': (ctx) => AddVisit(),
              'edit_account': (ctx) => EditAccount(),
              'settings_page': (ctx) => SettingsPage(),
              'ehr_information': (ctx) => EhrInformationPage(),
              'libraries_used': (ctx) => LibrariesUsed(),
            },
          ),
        ),
      ),
    );
  }
}
