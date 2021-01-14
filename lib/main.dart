import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/model/course_model/downloaded_courses_model.dart';
import 'package:world_wisdom/model/course_model/favorite_courses/favorite_courses_model.dart';
import 'package:world_wisdom/model/course_model/my_courses/my_courses_model.dart';
import 'package:world_wisdom/screen/authentication/forget_password/forget_password_screen.dart';
import 'package:world_wisdom/screen/authentication/login_screen/login_screen.dart';
import 'package:world_wisdom/screen/authentication/register/register_screen.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_screen.dart';
import 'package:world_wisdom/screen/screen_mode/app_mode.dart';
import 'package:world_wisdom/screen/splash_screen/SlashScreen.dart';
import 'model/authentication_model/authentication_model.dart';

Future<void> main() async {
  runApp(WorldWisdom());
}

class WorldWisdom extends StatefulWidget {
  @override
  _WorldWisdomState createState() => _WorldWisdomState();
}

ThemeData darkTheme = ThemeData(
    primaryColor: Color(0xFF181C20),
    accentColor: Color(0xFF0084BD),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Color(0x550084BD)),
    scaffoldBackgroundColor: Color(0xFF0D0F12),
    cardColor: Color(0xFF181C20),
    dialogBackgroundColor: Color(0xFF1E2429),
    canvasColor: Color(0xFF181C20),
    focusColor: Color(0xFF0084BD),
    textTheme: TextTheme(),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF181C20),
        contentTextStyle: TextStyle(color: Colors.white)),
    //0081B9 //0084BD
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color(0x00000000)),
      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF0084BD)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFF0084BD)))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFF0084BD)),
      side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: Color(0xFF0084BD))),
    )));

ThemeData lightTheme = ThemeData(
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(selectedItemColor: Color(0xFFE65100)),
    primaryColor: Color(0xFFE65100),
    accentColor: Color(0xFFCDDC39),
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Color(0x55EEFF41)),
    scaffoldBackgroundColor: Color(0xFFEEEEEE),
    cardColor: Color(0xFFFAFAFA),
    dialogBackgroundColor: Color(0xFFBDBDBD),
    canvasColor: Color(0xFFE0E0E0),
    focusColor: Color(0xFFE65100),
    cursorColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.black),
    // primaryIconTheme: IconThemeData(color: Color(0xFFBDBDBD)),
    // accentIconTheme: IconThemeData(color: Color(0xFFBDBDBD)),
    textTheme: TextTheme(
        caption: TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFFEEEEEE),
        contentTextStyle: TextStyle(color: Colors.black)),
    //0081B9 //0084BD
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Color(0x00000000)),
      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFE65100)),
      shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xFFE65100)))),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Color(0xFFE65100)),
      side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: Color(0xFFE65100))),
    )));

class _WorldWisdomState extends State<WorldWisdom> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationModel()),
        ChangeNotifierProvider(create: (context) => AppMode()),
        ChangeNotifierProvider(create: (context) => FavoriteCoursesModel()),
        ChangeNotifierProvider(create: (context) => MyCoursesModel()),
        ChangeNotifierProvider(create: (context) => DownloadedCoursesModel()),
      ],
      child: WorldWisdomApp(),
    );
  }
}

class WorldWisdomApp extends StatelessWidget {
  const WorldWisdomApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppMode appMode = Provider.of<AppMode>(context);
    return MaterialApp(
      theme: appMode.isDark ? darkTheme : lightTheme,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('vi', ''),
      ],
      navigatorKey: Keys.appNavigationKey,
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
        '/authentication/login': (context) => LoginScreen(),
        '/authentication/forgot': (context) => ForgotPasswordScreen(),
        '/authentication/register': (context) => RegisterScreen(),
      },
    );
  }
}
