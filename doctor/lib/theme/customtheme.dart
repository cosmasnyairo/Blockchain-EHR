import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appcolor = Color(0xff3FD5AE);

ThemeData _lightmode = ThemeData(
  snackBarTheme: SnackBarThemeData(backgroundColor: appcolor),
  canvasColor: Colors.white,
  primaryColor: appcolor,
  accentColor: Colors.black,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  buttonTheme: ButtonThemeData(
    buttonColor: appcolor,
    disabledColor: Colors.grey,
    height: 50,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(7),
    ),
  ),
  backgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    brightness: Brightness.light,
    color: Colors.white,
    centerTitle: true,
    elevation: 0,
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelPadding: EdgeInsets.all(5),
    labelColor: appcolor,
    unselectedLabelColor: Colors.black,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    selectedItemColor: appcolor,
    unselectedItemColor: Colors.black,
  ),
  dividerTheme:
      DividerThemeData(color: Colors.black, endIndent: 20, indent: 10),
  buttonColor: appcolor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 3,
    backgroundColor: appcolor,
  ),
  primaryIconTheme: IconThemeData(size: 25, color: appcolor),
  iconTheme: IconThemeData(size: 25, color: appcolor),
  cardTheme: CardTheme(
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
      ),
    ),
    focusColor: Colors.black,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2.0,
      ),
    ),
    prefixStyle: TextStyle(color: appcolor),
    hintStyle: TextStyle(color: Colors.black),
    labelStyle: TextStyle(color: Colors.black),
    filled: true,
  ),
  textTheme: GoogleFonts.montserratTextTheme(
    TextTheme(
      headline1: TextStyle(color: Colors.black),
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
      button: TextStyle(color: Colors.black),
      subtitle1: TextStyle(color: Colors.black),
      headline2: TextStyle(color: Colors.black),
      subtitle2: TextStyle(color: Colors.black),
      headline3: TextStyle(color: Colors.black),
      headline4: TextStyle(color: Colors.black),
      headline5: TextStyle(color: Colors.black),
      headline6: TextStyle(color: Colors.black),
    ),
  ),
  primaryTextTheme: GoogleFonts.montserratTextTheme(
    TextTheme(
      headline1: TextStyle(color: Colors.black),
      bodyText1: TextStyle(color: Colors.black),
      bodyText2: TextStyle(color: Colors.black),
      button: TextStyle(color: Colors.black),
      subtitle1: TextStyle(color: Colors.black),
      headline2: TextStyle(color: Colors.black),
      subtitle2: TextStyle(color: Colors.black),
      headline3: TextStyle(color: Colors.black),
      headline4: TextStyle(color: Colors.black),
      headline5: TextStyle(color: Colors.black),
      headline6: TextStyle(color: Colors.black),
    ),
  ),
);
ThemeData _darkmode = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: appcolor,
  ),
  canvasColor: Colors.black,
  brightness: Brightness.dark,
  accentColor: appcolor,
  primaryColor: Colors.black,
  appBarTheme: AppBarTheme(
    brightness: Brightness.dark,
    centerTitle: true,
    elevation: 0,
    color: Colors.black,
  ),
  tabBarTheme: TabBarTheme(
    indicatorSize: TabBarIndicatorSize.tab,
    labelPadding: EdgeInsets.all(5),
    labelColor: appcolor,
    unselectedLabelColor: Colors.white,
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.black,
    selectedItemColor: appcolor,
    unselectedItemColor: Colors.grey,
  ),
  dividerTheme:
      DividerThemeData(color: Colors.white, endIndent: 20, indent: 10),
  buttonColor: appcolor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    elevation: 3,
    backgroundColor: appcolor,
  ),
  primaryIconTheme: IconThemeData(size: 25, color: appcolor),
  iconTheme: IconThemeData(size: 25, color: appcolor),
  buttonTheme: ButtonThemeData(
    buttonColor: appcolor,
    disabledColor: Colors.white,
    height: 60,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  applyElevationOverlayColor: true,
  cardColor: Colors.black,
  cardTheme: CardTheme(
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    focusColor: Colors.white,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
    ),
    prefixStyle: TextStyle(color: appcolor),
    hintStyle: TextStyle(color: Colors.white),
    labelStyle: TextStyle(color: Colors.white),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    filled: true,
  ),
  textTheme: GoogleFonts.montserratTextTheme(
    TextTheme(
      headline1: TextStyle(color: Colors.white),
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
      button: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
      headline2: TextStyle(color: Colors.white),
      subtitle2: TextStyle(color: Colors.white),
      headline3: TextStyle(color: Colors.white),
      headline4: TextStyle(color: Colors.white),
      headline5: TextStyle(color: Colors.white),
      headline6: TextStyle(color: Colors.white),
    ),
  ),
  primaryTextTheme: GoogleFonts.montserratTextTheme(
    TextTheme(
      headline1: TextStyle(color: Colors.white),
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
      button: TextStyle(color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
      headline2: TextStyle(color: Colors.white),
      subtitle2: TextStyle(color: Colors.white),
      headline3: TextStyle(color: Colors.white),
      headline4: TextStyle(color: Colors.white),
      headline5: TextStyle(color: Colors.white),
      headline6: TextStyle(color: Colors.white),
    ),
  ),
);

class CustomThemeProvider with ChangeNotifier {
  static bool _darkthemechosen = false;
  final appcolor = Color(0xff3FD5AE);

  ThemeMode currenttheme() {
    return _darkthemechosen ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeData get lighttheme {
    return _lightmode;
  }

  ThemeData get darktheme {
    return _darkmode;
  }

  bool get darkthemechosen {
    return _darkthemechosen;
  }

  Future<void> getChosenTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _darkthemechosen = prefs.getBool("darkthemechosen");
    _darkthemechosen == null ? await setTheme(false) : null;
    notifyListeners();
  }

  Future<void> setTheme(bool chosen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("darkthemechosen", chosen);
    await getChosenTheme();
    notifyListeners();
  }
}
