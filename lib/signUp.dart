import 'dart:convert';

import 'package:ajstyle/config.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'signUpAddress.dart';

class SignUP extends StatefulWidget {
  SignUP({Key key}) : super(key: key);

  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController textPhoneController = new TextEditingController();
  TextEditingController textEmailController = new TextEditingController();
  TextEditingController textPassController = new TextEditingController();
  TextEditingController textComPassController = new TextEditingController();
  String errorPhone = '', errorEmail = '', errorPass = '', errorCPass = '';
  bool passVisibility = true, isProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: buildBody()),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height < 684 ? (height < 593 ? 30 : 55) : 60,
              ),
              Text('Create account',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: height < 684 ? (height < 593 ? 32 : 58) : 65,
              ),
              buildEmailTextField(),
              buildMobileTextField(),
              buildTextFieldPass(
                  "Password",
                  Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ), (text) {
                RegExp regex = new RegExp("[']");
                RegExp regex2 = new RegExp('["]');
                if (text.isEmpty) {
                  setState(() {
                    errorPass = "Enter password";
                  });
                  return null;
                } else if (text.length < 6) {
                  setState(() {
                    errorPass = "Password must have at least 6 characters";
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
              buildTextFieldPass(
                  "Comfirm Password",
                  Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ), (text) {
                RegExp regex = new RegExp("[']");
                RegExp regex2 = new RegExp('["]');
                if (text.isEmpty) {
                  setState(() {
                    errorCPass = "Retype your password";
                  });
                  return null;
                } else if (text != textPassController.text) {
                  setState(() {
                    errorCPass = "Passowrd doesn't match";
                  });
                  return null;
                } else if (regex.hasMatch(text) || regex2.hasMatch(text)) {
                  setState(() {
                    errorPass = "Invalid Password !";
                  });
                  return null;
                }
                setState(() {
                  errorCPass = "";
                });
                return null;
              }, textComPassController),
              SizedBox(
                height: 20,
              ),
              buildSignUpButton(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have a account ? ',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text('  Sign In    ',
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

  Widget buildSignUpButton() {
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
          if (errorCPass == '' &&
              errorEmail == '' &&
              errorPass == '' &&
              errorPhone == '') {
            setState(() {
              isProgress = true;
            });
            addCustomer(textEmailController.text, textPhoneController.text,
                textPassController.text);
          } else {}
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
            ),
            Text("SIGN UP",
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

  Widget buildEmailTextField() {
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
              controller: textEmailController,
              inputFormatters: [
                // ignore: deprecated_member_use
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9-.@_]")),
              ],
              validator: (text) {
                RegExp regex = RegExp(
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                if (text.isEmpty) {
                  setState(() {
                    errorEmail = 'Enter your email';
                  });
                  return null;
                } else if (!regex.hasMatch(text)) {
                  setState(() {
                    errorEmail = "Invalid email !";
                  });
                  return null;
                }
                setState(() {
                  errorEmail = "";
                });
                return null;
              },
              maxLength: 150,
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
                icon: Icon(
                  Icons.mail,
                  color: kPrimaryColor,
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12, top: 3),
          child: Text(
            errorEmail,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget buildMobileTextField() {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 8),
          child: Text(
            "Mobile",
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
              validator: (text) {
                if (text.isEmpty) {
                  setState(() {
                    errorPhone = 'Enter your mobile number';
                  });
                  return null;
                } else if (text.length < 10 ||
                    text.toString().substring(0, 2) != '07') {
                  setState(() {
                    errorPhone = 'Invalid phone number';
                  });
                  return null;
                }
                setState(() {
                  errorPhone = "";
                });
                return null;
              },
              maxLength: 10,
              inputFormatters: [
                // ignore: deprecated_member_use
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              keyboardType: TextInputType.number,
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
                icon: Icon(
                  Icons.smartphone,
                  color: kPrimaryColor,
                ),
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

  Widget buildTextFieldPass(String text, Icon icon, Function validator,
      TextEditingController textEditingController) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 8),
          child: Text(
            text,
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
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12, top: 3),
          child: Text(
            text == "Password" ? errorPass : errorCPass,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Future<void> addCustomer(String email, String mobile, String password) async {
    try {
      String path = "$url/addCustomer.php";

      final response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "email": "$email",
        "mobile": mobile,
        "pass": "$password"
      });

      String data = jsonDecode(response.body).toString();
      print("data: $data");
      if (data == '-1') {
        setState(() {
          isProgress = false;
        });

        Flushbar(
          message: 'Email already use !',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else {
        saveLoging(email, password, mobile, data);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SignUpAddress(
                      user: int.parse(data),
                      text: 'Shipping Address',
                    )));
      }
    } catch (e) {
      setState(() {
        isProgress = false;
      });
      Flushbar(
        message: 'No internet connection !',
        messageColor: Colors.red,
        backgroundColor: kPrimaryColor,
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.warning_rounded,
          color: Colors.red,
        ),
      ).show(context);
    }
  }

  void saveLoging(
      String email, String password, String mobile, String customerID) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'user', value: customerID);
    await storage.write(key: 'email', value: email);
    await storage.write(key: 'pass', value: password);
    await storage.write(key: 'mobile', value: mobile);
  }
}
