import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/node_provider.dart';
import 'providers/record_provider.dart';
import 'screens/add_visit.dart';
import 'screens/edit_account.dart';
import 'screens/ehrinformation.dart';
import 'screens/landingpage.dart';
import 'screens/libraries_used.dart';
import 'screens/onboarding.dart';
import 'screens/settings.dart';
import 'screens/splash_screen.dart';
import 'theme/customtheme.dart';

final customThemeProvider = CustomThemeProvider();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await customThemeProvider.getChosenTheme();
  await customThemeProvider.setTheme(customThemeProvider.darkthemechosen);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: customThemeProvider.appcolor));
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
            title: 'Ehr Patient',
            theme: theme.lighttheme,
            darkTheme: theme.darktheme,
            themeMode: theme.darkthemechosen ? ThemeMode.dark : ThemeMode.light,
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
