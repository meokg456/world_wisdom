import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user_model.dart';
import 'package:world_wisdom/screen/authentication/login_screen/login_data.dart';
import 'package:world_wisdom/screen/authentication/validator/validator.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:world_wisdom/screen/key/key.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final _usernameController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _loginFormKey = new GlobalKey<FormState>();

  bool _isFailed = false;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      print(googleSignInAccount.id);
      var response =
          await http.post("${Constants.apiUrl}/user/login-google-mobile",
              body: jsonEncode({
                "user": {
                  "email": googleSignInAccount.email,
                  "id": googleSignInAccount.id
                }
              }),
              headers: {"Content-Type": "application/json"});
      print(response.body);
      UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
      Provider.of<AuthenticationModel>(context, listen: false)
          .setAuthenticationModel(userModel);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("token", userModel.token);
      Keys.appNavigationKey.currentState.pop();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).signIn),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: [
                TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    validator: (text) {
                      return Validator.validateEmail(context, text);
                    },
                    decoration: InputDecoration(
                      labelText: S.of(context).usernameSignIn,
                    )),
                TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    onEditingComplete: logIn,
                    validator: (text) {
                      return Validator.validatePassword(context, text);
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        labelText: S.of(context).password,
                        suffixIcon: Icon(Icons.visibility_off))),
                _isFailed
                    ? SizedBox(
                        height: 20,
                      )
                    : SizedBox(
                        height: 0,
                      ),
                _isFailed
                    ? Text(
                        S.of(context).invalidPasswordOrUsername,
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(""),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: logIn,
                            child: Text(
                              S.of(context).signInUpperCase,
                              style: Theme.of(context).textTheme.button,
                            )),
                      ),
                TextButton(
                  onPressed: () async {
                    LoginData data = await Navigator.of(context)
                        .pushNamed("/authentication/forgot") as LoginData;
                    if (data != null) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("${data.message}")));
                      _usernameController.text = data.email;
                    }
                  },
                  child: Text(
                    "${S.of(context).forgotPasswordUpperCase}?",
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: signInWithGoogle,
                    child: ListTile(
                      leading: Image.asset("resources/images/google_logo.png"),
                      title: Text(
                        S.of(context).signInWithGoogleUpperCase,
                      ),
                      dense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    S.of(context).signUpUpperCase,
                  ),
                  onPressed: () async {
                    LoginData data = await Navigator.pushNamed(
                        context, '/authentication/register') as LoginData;
                    if (data != null) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("${data.message}")));
                      _usernameController.text = data.email;
                    }
                    // print(data);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logIn() async {
    if (!_loginFormKey.currentState.validate()) {
      setState(() {
        _isFailed = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.post("${Constants.apiUrl}/user/login",
        body: jsonEncode({
          "email": _usernameController.text,
          "password": _passwordController.text
        }),
        headers: {"Content-Type": "application/json"});
    print(response.body);
    if (response.statusCode == 200) {
      UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
      Provider.of<AuthenticationModel>(context, listen: false)
          .setAuthenticationModel(userModel);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString("token", userModel.token);
      Navigator.pop(context);
      return;
    }
    if (response.statusCode == 400) {
      setState(() {
        _isFailed = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}
