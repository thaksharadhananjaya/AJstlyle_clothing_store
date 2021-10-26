import 'dart:convert';

import 'package:ajstyle/main.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class NewPassword extends StatefulWidget {
  final String email;
  NewPassword({Key key, this.email}) : super(key: key);

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController textPassController = new TextEditingController();
  TextEditingController textCPassController = new TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool passVisibility = true, isProgress = false;
  String errorPass = '', errorCPass = '';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => null,
        child: SafeArea(
          child: Container(
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                height: height < 684 ? (height < 593 ? 30 : 55) : 60,
              ),
                    Text("Change Password",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 40,
                    ),
                    buildTextField(textPassController, "New Password", errorPass, height),
                    buildTextField(
                        textCPassController, "Comfirm Password", errorCPass, height),
                    SizedBox(
                      height: 36,
                    ),
                    buildButton(height)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(double height) {
    return SizedBox(
      width: double.maxFinite,
      height: height < 600 ? 45 : 50,

      // ignore: deprecated_member_use
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: kPrimaryColor,
        onPressed: () {
          formKey.currentState.validate();
          if (errorPass == '' && errorCPass == '') {
            setState(() {
              isProgress = true;
            });
            changePassword();
          } else {}
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
            ),
            Text("CHANGE PASSWORD",
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

  Widget buildTextField(
      TextEditingController textEditingController, String label, String error, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 8, top: 12),
          child: Text(
            label,
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
              inputFormatters: [
                // ignore: deprecated_member_use
                new WhitelistingTextInputFormatter(
                    RegExp("[a-zA-Z-0-9-.@_/\|#%^&(){}=+~]")),
              ],
              validator: (text) {
                RegExp regex = new RegExp("[']");
                RegExp regex2 = new RegExp('["]');
                if (regex.hasMatch(text) || regex2.hasMatch(text)) {
                  setState(() {
                    errorPass = "Invalid Password !";
                  });
                  return null;
                }
                if (label == "New Password") {
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
                  }
                  setState(() {
                    errorPass = "";
                  });
                  return null;
                } else {
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
                  }

                  setState(() {
                    errorCPass = "";
                  });
                  return null;
                }
              },
              maxLength: 150,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                counterText: '',
                hintStyle: TextStyle(
                  color: kPrimaryColor.withOpacity(0.5),
                ),
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
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                border: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                icon: Icon(
                  Icons.lock,
                  color: kPrimaryColor,
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 3),
          child: Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  void changePassword() async {
    try {
      String path = "$url/changePass.php";

      final response = await http.post(Uri.parse(path), body: {
        "key": "$accessKey",
        "email": "${widget.email}",
        "pass": "${textPassController.text}"
      });
      var data = jsonDecode(response.body);
      setState(() {
        isProgress = false;
      });
      print("d:$data");
      if (data.toString() != "0") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScren(index: 2)));
        Flushbar(
          message: 'Password Reseted !',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 4),
          icon: Icon(
            Icons.info_rounded,
            color: Colors.green,
          ),
        ).show(context);
      } else {
        Flushbar(
          message: 'Something went to wrong !',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      }
    } catch (e) {
      setState(() {
        isProgress = false;
      });
      Flushbar(
        message: e.toString(),
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
}
