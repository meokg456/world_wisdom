import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:world_wisdom/model/authentication_model.dart';
import 'package:world_wisdom/model/user_model.dart';
import 'package:world_wisdom/screen/authentication/login_screen/login_data.dart';
import 'package:world_wisdom/screen/authentication/validator/validator.dart';
import 'package:world_wisdom/screen/constants/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _loginFormKey = new GlobalKey<FormState>();

  bool _isFailed = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
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
                    validator: Validator.validateEmail,
                    decoration: InputDecoration(
                      labelText: "Username (or Email)",
                    )),
                TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    onEditingComplete: logIn,
                    validator: Validator.validatePassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                        labelText: "Password",
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
                        "Invalid password or username",
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
                              "SIGN IN",
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    LoginData data = await Navigator.of(context)
                        .pushNamed("/authentication/forgot") as LoginData;
                    if (data != null) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("${data.message}")));
                      _usernameController.text = data.email;
                    }
                  },
                  child: Text(
                    "FORGOT PASSWORD?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "USE SINGLE SIGN-ON(SSO)",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  child: Text(
                    "SIGN UP FREE?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () async {
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

    UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      Provider.of<AuthenticationModel>(context, listen: false)
          .setAuthenticationModel(userModel);
      Navigator.pop(context);
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
