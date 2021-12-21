import 'dart:convert';

import 'package:ajstyle/otp.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController textEmailController = new TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isProgress = false;
  String errorEmail = '';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                height: height < 684 ? (height < 593 ? 30 : 55) : 60,
              ),
                Text("Reset Password",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 40,
                ),
                Text(
                    "Enter the email associated with your account and we'll send an email with OTP to reset password"),
                buildEmailTextField(height),
                buildSendButton(height)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSendButton(double height) {
    return SizedBox(
      width: double.maxFinite,
      height: height < 600 ? 45 : 50,

      // ignore: deprecated_member_use
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: kPrimaryColor,
        onPressed: () {
          formKey.currentState.validate();
          if (errorEmail == '') {
            setState(() {
              isProgress = true;
            });
            sendVerification();
          } else {}
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
            ),
            Text("SEND VERIFICATION",
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

  Widget buildEmailTextField(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 8, top: 65),
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
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: textEmailController,
                inputFormatters: [
                  // ignore: deprecated_member_use
                  FilteringTextInputFormatter.allow(
                      RegExp("[a-zA-Z-0-9-.@_]")),
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
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 36, top: 3),
          child: Text(
            errorEmail,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  void sendVerification() async {
    try {
      String path = "$url/resetPass.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": "$accessKey", "email": "${textEmailController.text}"});
      var data = jsonDecode(response.body);
      setState(() {
        isProgress = false;
      });
      print("d:$data");
      if (data.toString() != "0") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OTP(
                    email: textEmailController.text, otp: data.toString())));
      } else {
        Flushbar(
          message: 'Sorry, no emails exists !',
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
