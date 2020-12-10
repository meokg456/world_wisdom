import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:world_wisdom/screen/authentication/login_screen/login_data.dart';
import 'package:world_wisdom/screen/authentication/validator/validator.dart';
import 'package:http/http.dart' as http;
import 'package:world_wisdom/screen/constants/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = new TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFailed = false;

  void sendEmail() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    var response = await http.post(
        "${Constants.apiUrl}/user/forget-pass/send-email",
        body: jsonEncode({"email": _emailController.text}),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      LoginData data =
          LoginData("Recovery email was sent", _emailController.text);
      Navigator.pop(context, data);
    } else {
      setState(() {
        _isFailed = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget password"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Container(
              child: Image.asset("resources/images/brand.jpg"),
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              "Forgot Password",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w200),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "Enter your email address and we'll send you a link to reset your password",
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: Validator.validateEmail,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 20)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _isFailed
                        ? Text(
                            "The email address has not been registered",
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(""),
                    _isFailed
                        ? SizedBox(
                            height: 10,
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: sendEmail,
                                child: Text("Send email"))),
                    Container(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Cancel"))),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
