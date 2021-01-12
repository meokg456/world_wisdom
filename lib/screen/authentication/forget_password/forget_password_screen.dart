import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:world_wisdom/generated/l10n.dart';
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
          LoginData(S.of(context).recoveryEmailSent, _emailController.text);
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
        title: Text(S.of(context).forgotPassword),
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
              child: Image.asset(
                "resources/images/online-course.png",
                height: 100,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              S.of(context).forgotPassword,
              style: Theme.of(context).textTheme.headline4,
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
                      S.of(context).forgotPasswordHint,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    TextFormField(
                      controller: _emailController,
                      validator: Validator.validateEmail,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: Theme.of(context).textTheme.overline),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _isFailed
                        ? Text(
                            S.of(context).emailNotExisted,
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
                                child: Text(S.of(context).sendEmail))),
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
                            child: Text(S.of(context).cancel))),
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
