import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:world_wisdom/screen/authentication/login_screen/login_data.dart';
import 'package:world_wisdom/screen/authentication/validator/validator.dart';
import 'package:http/http.dart' as http;
import 'package:world_wisdom/screen/constants/constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _phoneController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _confirmPasswordController = new TextEditingController();
  final _registerFormKey = new GlobalKey<FormState>();

  bool _isFailed = false;
  bool _isLoading = false;

  void register() async {
    if (!_registerFormKey.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    var response = await http.post(Constants.apiUrl + "user/register",
        body: jsonEncode({
          "username": _usernameController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
          "password": _passwordController.text
        }),
        headers: {"Content-Type": "application/json"});
    Map body = jsonDecode(response.body);
    print(body['message']);
    if (response.statusCode == 200) {
      LoginData data =
          LoginData("Registered successfully", _emailController.text);
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
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Form(
          key: _registerFormKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
                  validator: Validator.validateUsername,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: "Username",
                  )),
              TextFormField(
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  validator: Validator.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                  )),
              TextFormField(
                  controller: _phoneController,
                  textInputAction: TextInputAction.next,
                  validator: Validator.validatePhone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone",
                  )),
              TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validator.validatePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: Icon(Icons.visibility_off))),
              TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (String confirmPassword) {
                    if (confirmPassword != _passwordController.value.text) {
                      return "Confirm password does not match";
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onEditingComplete: register,
                  decoration: InputDecoration(
                      labelText: "Confirm password",
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
                      "Email or phone number already existed",
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
                          onPressed: register,
                          child: Text(
                            "Confirm",
                            style: TextStyle(fontSize: 16),
                          )),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
