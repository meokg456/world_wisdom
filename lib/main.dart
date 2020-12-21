import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_wisdom/screen/SlashScreen.dart';
import 'package:world_wisdom/screen/account-management/setting/setting_screen.dart';
import 'package:world_wisdom/screen/authentication/forget_password/forget_password_screen.dart';
import 'package:world_wisdom/screen/authentication/login_screen/login_screen.dart';
import 'package:world_wisdom/screen/authentication/register/register_screen.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/main_screen/main_screen.dart';
import 'model/authentication_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
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
        ChangeNotifierProvider(create: (context) => AuthenticationModel())
      ],
      child: MaterialApp(
        theme: Constants.themeData,
        localizationsDelegates: [
          AppLocalizations.delegate,
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
