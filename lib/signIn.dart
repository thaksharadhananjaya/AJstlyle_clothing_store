import 'dart:convert';

import 'package:ajstyle/config.dart';
import 'package:ajstyle/main.dart';
import 'package:ajstyle/resetPasword.dart';
import 'package:ajstyle/signUp.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:move_to_background/move_to_background.dart';

class SignIn extends StatefulWidget {
  SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool checkValue = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textPhoneController = new TextEditingController();
  TextEditingController textPassController = new TextEditingController();
  String errorPhone = '', errorPass = '';
  bool passVisibility = true, isProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            {
              MoveToBackground.moveTaskToBack();
              return false;
            }
          },
          child: SafeArea(child: buildBody())),
    );
  }

  Container buildBody() {
    double height = MediaQuery.of(context).size.height;
    return Container(
        child: Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: KPaddingHorizontal,
              right: KPaddingHorizontal,
              bottom: KPaddingVertical + 10),
          child: Column(
            children: [
              SizedBox(
                height: height < 684 ? (height < 593 ? 30 : 55) : 60,
              ),
              Text('Sign in to your account',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
             SizedBox(
                height: height < 684 ? (height < 593 ? 32 : 58) : 65,
              ),
              buildTextField(
                  context,
                  Icon(
                    Icons.email,
                    color: kPrimaryColor,
                  ), (text) {
                RegExp regex = RegExp(
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                if (text.isEmpty) {
                  setState(() {
                    errorPhone = 'Enter your email';
                  });
                  return null;
                } else if (!regex.hasMatch(text)) {
                  setState(() {
                    errorPhone = 'Invalid email';
                  });
                  return null;
                }
                setState(() {
                  errorPhone = "";
                });
                return null;
              }),
              buildTextFieldPass(
                  context,
                  Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ), (text) {
                RegExp regex = new RegExp("[']");
                RegExp regex2 = new RegExp('["]');
                if (text.isEmpty) {
                  setState(() {
                    errorPass = "Enter your password";
                  });
                  return null;
                } else if (regex.hasMatch(text) || regex2.hasMatch(text)) {
                  setState(() {
                    errorPass = "Invalid Password !";
                  });
                  return null;
                }
                setState(() {
                  errorPass = "";
                });
                return null;
              }, textPassController),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Forget your password ? "),
                    GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResetPassword())),
                        child: Text(" Reset",
                            style: TextStyle(
                              color: Colors.black45,
                            )))
                  ],
                ),
              ),
              buildSignInButton(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Don't have an account ? ",
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUP()));
                    },
                    child: Text('  Sign Up    ',
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 16,
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  SizedBox buildSignInButton() {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: double.maxFinite,
     height: height < 600 ? 45 : 50,

      // ignore: deprecated_member_use
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: kPrimaryColor,
        onPressed: () {
          formKey.currentState.validate();
          if (errorPass == '' && errorPhone == '') {
            login(textPhoneController.text, textPassController.text);
          } else {
            return;
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 32),
            Text("SIGN IN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )),
            SizedBox(
              width: 16,
            ),
            SizedBox(
              width: 20,
              height: 20,
              child: isProgress
                  ? CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white))
                  : SizedBox(
                      width: 28,
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(BuildContext context, Icon icon, Function validator) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 8),
          child: Text(
            "Email",
            style: TextStyle(
              color: kPrimaryColor,
            ),
          ),
        ),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
            height: height < 600 ? 47 : 54,
            decoration: BoxDecoration(
                color: Colors.black12,
                //color : Colors.red,
                borderRadius: BorderRadius.circular(15.0)),
            child: TextFormField(
              controller: textPhoneController,
              validator: validator,
              maxLength: 150,
              inputFormatters: [
                // ignore: deprecated_member_use
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9-.@_]")),
              ],
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                counterText: '',
                hintStyle: TextStyle(
                  color: kPrimaryColor.withOpacity(0.5),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                border: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                icon: icon,
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12, top: 3),
          child: Text(
            errorPhone,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget buildTextFieldPass(BuildContext context, Icon icon, Function validator,
      TextEditingController textEditingController) {
        double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 8),
          child: Text(
            "Password",
            style: TextStyle(
              color: kPrimaryColor,
            ),
          ),
        ),
        Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
            height: height < 600 ? 47 : 54,
            decoration: BoxDecoration(
                color: Colors.black12,
                //color : Colors.red,
                borderRadius: BorderRadius.circular(15.0)),
            child: TextFormField(
              controller: textEditingController,
              obscureText: passVisibility ? true : false,
              validator: validator,
              maxLength: 8,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                counterText: '',
                hintStyle: TextStyle(
                  color: kPrimaryColor.withOpacity(0.5),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                border: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                suffixIcon: IconButton(
                    icon: Icon(
                      passVisibility ? Icons.visibility_off : Icons.visibility,
                      color: kPrimaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        if (passVisibility)
                          passVisibility = false;
                        else
                          passVisibility = true;
                      });
                    }),
                icon: icon,
              ),
            )),
        Visibility(
          visible: errorPass != "",
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 3),
            child: Text(
              errorPass,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> login(String user, String password) async {
    setState(() {
      isProgress = true;
    });
    try {
      String path = "$url/login.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "user": "$user", "pass": "$password"});

      var data = jsonDecode(response.body);

      if (data == '0') {
        setState(() {
          isProgress = false;
        });
        Flushbar(
          message: 'Wrong username or password !',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else {
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'user', value: data['customerID']);
        await storage.write(key: 'email', value: data['email']);
        await storage.write(key: 'pass', value: data['pass']);
        await storage.write(key: 'mobile', value: data['mobile']);
        await storage.write(key: 'name', value: data['name']);
        await storage.write(key: 'address', value: data['address']);
        await storage.write(key: 'city', value: data['city']);
        await storage.write(key: 'district', value: data['district']);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScren(index: 2)));
      }
    } catch (e) {
      print(e);
    }
  }
}
