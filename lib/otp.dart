import 'dart:convert';

import 'package:ajstyle/newPass.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class OTP extends StatefulWidget {
  final String email, otp;
  OTP({Key key, this.email, this.otp}) : super(key: key);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  TextEditingController textEditingControllerOTP = new TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                height: height < 684 ? (height < 593 ? 30 : 55) : 60,
              ),
                Text("OTP Verification",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 40,
                ),
                Text("Enter the OTP sent to "),
                Text(
                  widget.email,
                  maxLines: 2,
                  style: (TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 8, top: 65),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Enter OTP",
                      style: TextStyle(
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
                buildTextField(height),
                buildButton(height)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(double height) {
    return SizedBox(
      width: double.maxFinite,
      height: height < 600 ? 46 : 50,

      // ignore: deprecated_member_use
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        color: kPrimaryColor,
        onPressed: () {
          formKey.currentState.validate();
          if (error == '') {
            checkOTP();
          } else {}
        },
        child: Text("VERIFY",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            )),
      ),
    );
  }

  Widget buildTextField(double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                controller: textEditingControllerOTP,
                inputFormatters: [
                  // ignore: deprecated_member_use
                  new WhitelistingTextInputFormatter(RegExp("[0-9]")),
                ],
                maxLength: 4,
                validator: (text) {
                  if (text.isEmpty) {
                    setState(() {
                      error = 'Enter valied OTP';
                    });
                    return null;
                  }
                  setState(() {
                    error = "";
                  });
                  return null;
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(right: 6),
                  counterText: '',
                  hintStyle: TextStyle(
                    color: kPrimaryColor.withOpacity(0.5),
                  ),
                  hintText: "# # # #   ",
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
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 36, top: 3),
          child: Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  void checkOTP() async {
    if (textEditingControllerOTP.text == widget.otp) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewPassword(
                    email: widget.email,
                  )));
    } else {
      Flushbar(
        message: 'Invalid OTP !',
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
