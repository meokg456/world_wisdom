import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_wisdom/generated/l10n.dart';
import 'package:world_wisdom/handler/handler.dart';
import 'package:world_wisdom/model/authentication_model/authentication_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user_model.dart';
import 'package:world_wisdom/model/authentication_model/user_model/user_type.dart';
import 'package:world_wisdom/screen/authentication/validator/validator.dart';
import 'package:http/http.dart' as http;
import 'package:world_wisdom/screen/constants/constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  bool isLoading = false;
  AuthenticationModel authenticationModel;

  final updateProfileFormKey = new GlobalKey<FormState>();

  bool isFailed = false;

  final avatarUriController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  Future<bool> onPop() async {
    if (authenticationModel.user == null) return true;
    if (isEditing) {
      setState(() {
        isEditing = false;
      });
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  void updateProfile() async {
    if (!updateProfileFormKey.currentState.validate()) {
      return;
    }
    var response = await http.put("${Constants.apiUrl}/user/update-profile",
        body: jsonEncode({
          "name": nameController.text,
          "avatar": avatarUriController.text,
          "phone": phoneController.text
        }),
        headers: {
          "Authorization": "Bearer ${authenticationModel.token}",
          "Content-Type": "application/json"
        });
    print(response.body);
    if (response.statusCode == 200) {
      UserModel userModel = UserModel.fromJson(jsonDecode(response.body));
      authenticationModel.setAuthenticationModel(userModel);
      setState(() {
        isEditing = false;
      });
    }
    if (response.statusCode == 401) {
      Handler.unauthorizedHandler(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    authenticationModel = Provider.of<AuthenticationModel>(context);
    if (authenticationModel.user != null) {
      avatarUriController.text = authenticationModel.user.avatar;
      nameController.text = authenticationModel.user.name;
      phoneController.text = authenticationModel.user.phone;
    }
    return WillPopScope(
      onWillPop: onPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              isEditing = true;
            });
          },
          child: Icon(Icons.edit),
        ),
        appBar: AppBar(title: Text(S.of(context).profile)),
        body: authenticationModel.user == null
            ? null
            : isEditing
                ? Container(
                    margin: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Form(
                        key: updateProfileFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name,
                                controller: nameController,
                                validator: (name) {
                                  return name.length > 0
                                      ? null
                                      : S.of(context).invalidName;
                                },
                                decoration: InputDecoration(
                                  labelText: S.of(context).name,
                                )),
                            TextFormField(
                                controller: avatarUriController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.url,
                                validator: (text) {
                                  return Validator.validateUrl(context, text);
                                },
                                decoration: InputDecoration(
                                  labelText: S.of(context).avatarUrl,
                                )),
                            TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (text) {
                                  return Validator.validatePhone(context, text);
                                },
                                decoration: InputDecoration(
                                  labelText: S.of(context).phoneNumber,
                                )),
                            isFailed
                                ? SizedBox(
                                    height: 20,
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            isFailed
                                ? Text(
                                    S.of(context).serverError,
                                    style: TextStyle(color: Colors.red),
                                  )
                                : Text(""),
                            SizedBox(
                              height: 20,
                            ),
                            isLoading
                                ? CircularProgressIndicator()
                                : Container(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: updateProfile,
                                        child: Text(
                                          S.of(context).confirm,
                                        )),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(vertical: 35),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: ClipOval(
                              child: Image.network(
                                authenticationModel.user.avatar,
                                height: 200,
                                width: 200,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              authenticationModel.user.name != null
                                  ? authenticationModel.user.name
                                  : "",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            subtitle: Text(
                              typeValues.reverse[authenticationModel.user.type],
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Divider(),
                          Card(
                            child: ListTile(
                              title: Text(
                                  "Email: ${authenticationModel.user.email}"),
                              subtitle: Text(
                                  "${S.of(context).phoneNumber}: ${authenticationModel.user.phone}"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
