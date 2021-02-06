import 'package:doctor/screens/onboarding.dart';
import 'package:doctor/widgets/error_screen.dart';
import 'package:async/async.dart';
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
import 'screens/libraries_used.dart';
import 'screens/pending_activation.dart';
import 'screens/screen.dart';
import 'screens/settings.dart';
import 'screens/splash_screen.dart';
import 'screens/view_open_transactions.dart';
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
        ChangeNotifierProvider(create: (ctx) => DoctorAuthProvider())
      ],
      child: Consumer<CustomThemeProvider>(
        builder: (ctx, theme, _) => Consumer<DoctorAuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Ehr Doctor',
            theme: theme.chosentheme,
            home: auth.isLoggedIn
                ? SplashScreen()
                : auth.shownboarding
                    ? OnboardingScreen()
                    : LandingPage(),
            routes: {
              'add_record': (ctx) => AddRecord(),
              'view_open_transaction': (ctx) => ViewOpenTransactions(),
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
