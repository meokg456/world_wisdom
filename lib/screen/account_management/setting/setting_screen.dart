import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user_type.dart';
import 'package:world_wisdom/screen/key/key.dart';
import 'package:world_wisdom/screen/screen_mode/app_mode.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

enum Language { vietnamese, english }

class _SettingScreenState extends State<SettingScreen> {
  AppMode appMode;
  PackageInfo packageInfo;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        packageInfo = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = context.select((AuthenticationModel model) => model.user);
    appMode = context.select((AppMode appMode) => appMode);
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).setting)),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 35),
        child: ListView(
          children: [
            user != null
                ? ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                    title: Text(user.name != null ? user.name : ""),
                    subtitle: Text(typeValues.reverse[user.type]),
                    onTap: () {
                      Keys.mainNavigatorKey.currentState.pushNamed("/profile");
                    },
                  )
                : SizedBox(),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.nightlight_round,
                color: Colors.amber,
              ),
              title: Text(S.of(context).darkMode),
              trailing: Switch(
                value: appMode.isDark,
                onChanged: (bool value) {
                  appMode.setDarkMode(value);
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                color: Colors.blue,
              ),
              title: Text(S.of(context).language),
              subtitle: Text(S.of(context).currentLanguageSubtitle),
              trailing: PopupMenuButton<Language>(
                onSelected: (language) {
                  switch (language) {
                    case Language.english:
                      S.load(Locale("en")).whenComplete(() {
                        setState(() {});
                      });
                      break;

                    case Language.vietnamese:
                      S.load(Locale("vi")).whenComplete(() {
                        setState(() {});
                      });

                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<Language>>[
                  const PopupMenuItem<Language>(
                    value: Language.english,
                    child: Text("English"),
                  ),
                  const PopupMenuItem<Language>(
                    value: Language.vietnamese,
                    child: Text("Tiếng việt"),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.contact_phone_outlined,
                color: Colors.green,
              ),
              title: Text(S.of(context).contact),
              subtitle: Text(S.of(context).aboutUs),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          insetPadding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 10),
                          title: Text(S.of(context).aboutUs),
                          content: Text(S.of(context).contactInfo),
                          actions: <Widget>[
                            TextButton(
                              child: Text(S.of(context).gotIt),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.app_settings_alt,
              ),
              title: Text(S.of(context).appVersion),
              subtitle:
                  Text(packageInfo == null ? "1.0.0" : packageInfo.version),
            ),
            Divider(),
            user == null
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                      onPressed: () {
                        Keys.appNavigationKey.currentState
                            .pushNamed("/authentication/login");
                      },
                      child: Text(S.of(context).signInUpperCase),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 10),
                                  title: Text(S.of(context).signOut),
                                  content: Text(S.of(context).signOutConfirm),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(S.of(context).signOutCancel),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child:
                                          Text(S.of(context).signOutUpperCase),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        Provider.of<AuthenticationModel>(
                                                context,
                                                listen: false)
                                            .setAuthenticationModel(null);
                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();
                                        sharedPreferences.setString(
                                            "token", null);
                                      },
                                    ),
                                  ],
                                ));
                      },
                      child: Text(S.of(context).signOut),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
