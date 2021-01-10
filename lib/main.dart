import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/course_model/course_model.dart';
import 'package:world_wisdom/screen/authentication/forget_password/forget_password_screen.dart';
import 'package:world_wisdom/screen/authentication/login_screen/login_screen.dart';
import 'package:world_wisdom/screen/authentication/register/register_screen.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_screen.dart';
import 'package:world_wisdom/screen/splash_screen/SlashScreen.dart';
import 'package:world_wisdom/screen_mode/screen_mode.dart';
import 'model/authentication_model/authentication_model.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Theme.of(context).textTheme.apply(
          fontFamily: GoogleFonts.roboto().fontFamily,
          bodyColor: Color(0xFF0084BD),
        );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationModel()),
        ChangeNotifierProvider(create: (context) => ScreenMode()),
        ChangeNotifierProvider(create: (context) => CourseModel(courses: []))
      ],
      child: MaterialApp(
        theme: Constants.themeData,
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
      ),
    );
  }
}
