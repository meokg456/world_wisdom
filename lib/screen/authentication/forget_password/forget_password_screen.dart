import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
              child: Column(
                children: [
                  Text(
                    "Enter your email address and we'll send you a link to reset your password",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {}, child: Text("Send email"))),
                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor)),
                          onPressed: () {},
                          child: Text("Cancel"))),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
