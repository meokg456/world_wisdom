import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'file:///D:/AndroidStudioProjects/world_wisdom/lib/screen/authentication/validator/validator.dart';
import 'package:world_wisdom/screen/constants/constants.dart';
import 'package:world_wisdom/screen/model/authentication_model.dart';
import 'package:world_wisdom/screen/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _loginFormKey = new GlobalKey<FormState>();
  FocusNode _passwordFocusNode;
  bool _isWrong = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Form(
          key: _loginFormKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  validator: Validator.validateEmail,
                  onFieldSubmitted: (String value) {
                    _passwordFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    labelText: "Username (or Email)",
                  )),
              TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  focusNode: _passwordFocusNode,
                  onEditingComplete: logIn,
                  validator: Validator.validatePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: Icon(Icons.visibility_off))),
              _isWrong ? SizedBox(
                height: 20,
              ) : SizedBox(height: 0,),
              _isWrong ? Text("Invalid password or username",
                style: TextStyle(color: Colors.red),) : Text(""),
              SizedBox(
                height: 20,
              ),
              _isLoading ?
              CircularProgressIndicator()

                  : Container(
                width: double.infinity,
                child:
                ElevatedButton(
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
                onTap: () {
                  Navigator.of(context).pushNamed("/authentication/forgot");
                },
                child: Text(
                  "FORGOT PASSWORD?",
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme
                          .of(context)
                          .accentColor,
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
                      color: Theme
                          .of(context)
                          .accentColor,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/authentication/register');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logIn() async {
    if (!_loginFormKey.currentState.validate()) {
      setState(() {
        _isWrong = false;
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    http.Response response = await http.post(Constants.apiUrl + "user/login",
        body: jsonEncode({
          "email": _usernameController.value.text,
          "password": _passwordController.value.text
        }),
        headers: {"Content-Type": "application/json"});
    setState(() {
      _isLoading = false;
    });
    UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
    print(userModel.message);
    if (response.statusCode == 200) {
      Provider.of<AuthenticationModel>(context, listen: false)
          .setAuthenticationModel(userModel);
      Navigator.pop(context);
    }
    if (response.statusCode == 400) {
      setState(() {
        _isWrong = true;
      });
    }
  }
}