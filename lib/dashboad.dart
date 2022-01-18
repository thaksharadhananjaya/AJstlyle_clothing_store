import 'dart:convert';

import 'package:ajstyle/about.dart';

import 'package:ajstyle/main.dart';
import 'package:ajstyle/order.dart';
import 'package:ajstyle/signUpAddress.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:move_to_background/move_to_background.dart';

import 'config.dart';
import 'otherPayment.dart';

// ignore: must_be_immutable
class Dashboad extends StatelessWidget {
  String pass, name, city, mobile, district, address, email;
  final int user;
  Dashboad(
      {Key key,
      this.user,
      this.email,
      this.pass,
      this.name,
      this.city,
      this.district,
      this.address,
      this.mobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        {
          MoveToBackground.moveTaskToBack();
          return false;
        }
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height - 50,
          padding: EdgeInsets.symmetric(vertical: KPaddingVertical),
          width: double.maxFinite,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 68,
                    backgroundColor: kPrimaryColor,
                    child: CircleAvatar(
                      radius: 63,
                      child: Text(
                        name.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                            fontSize: 68, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Text(
                      district,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                  builButton(
                      context,
                      'My Orders',
                      Icon(
                        Icons.shopping_bag,
                        color: kPrimaryColor,
                      ), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Order(
                                  customerID: user,
                                  isBack: true,
                                )));
                  }),
                  builButton(
                      context,
                      'Payments',
                      Icon(
                        Icons.payment,
                        color: kPrimaryColor,
                      ), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtherPayment(
                                  customerID: user,
                 
                                )));
                  }),
                  builButton(
                      context,
                      'Change Address',
                      Icon(
                        Icons.home_filled,
                        color: kPrimaryColor,
                      ), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpAddress(
                                  user: user,
                                  text: "Change Shipping Address",
                                  name: name,
                                  address: address,
                                  city: city,
                                  district: district,
                                )));
                  }),
                  builButton(
                      context,
                      'Change Email',
                      Icon(
                        Icons.email,
                        color: kPrimaryColor,
                      ),
                      () => buildChangeEmail(context)),
                  builButton(
                      context,
                      'Change Mobile Number',
                      Icon(
                        Icons.smartphone,
                        color: kPrimaryColor,
                      ),
                      () => buildChangeMobile(context)),
                  builButton(
                      context,
                      'Change Password',
                      Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                      () => buildChangePassword(context)),
                  builButton(
                      context,
                      'Sign Out',
                      Icon(
                        Icons.logout,
                        color: kPrimaryColor,
                      ),
                      () => signOut(context)),
                  builButton(
                      context,
                      'About Us',
                      Icon(
                        Icons.info,
                        color: kPrimaryColor,
                      ), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => About()));
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signOut(BuildContext context) {
    final storage = new FlutterSecureStorage();
    storage.deleteAll();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScren(
                  index: 2,
                )));
  }

  Padding builButton(
      BuildContext context, String text, Icon icon, Function func) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      // ignore: deprecated_member_use
      child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  icon,
                  SizedBox(
                    width: 6,
                  ),
                  Text(text,
                      style: TextStyle(
                          fontSize: 17,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.arrow_forward_ios)),
            ],
          ),
          onPressed: func),
    );
  }

  Future buildChangePassword(BuildContext context) {
    bool passwordVisible = false,
        passwordOldVisible = false,
        isProgress = false;
    String errorOldPass = "", errorNewPass = "", errorCPass = "";
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    double height = MediaQuery.of(context).size.height;
    //Pasword Decoration
    InputDecoration decPswd(
        BuildContext context, String label, StateSetter setState) {
      return InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        border: InputBorder.none,
        counterText: '',
        icon: Icon(
          Icons.lock,
          color: kPrimaryColor,
        ),
        focusedErrorBorder: InputBorder.none,
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: kPrimaryColor,
          ),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
      );
    }

    TextEditingController textEditingControllerOldPass =
        new TextEditingController();
    TextEditingController textEditingControllerNewPass =
        new TextEditingController();
    // Change Password Dailog Box
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => null,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  "Change Password",
                ),
                titlePadding: EdgeInsets.only(left: 16, top: 4),
                content: Form(
                  key: formKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 4,
                        ),
                        // Old Password
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 8),
                          child: Text(
                            "Old Password",
                            style: TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              //color : Colors.red,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: height < 600 ? 47 : 54,
                          child: TextFormField(
                            validator: (text) {
                              if (text.isEmpty) {
                                setState(() {
                                  errorOldPass = "Enter your old password";
                                });
                                return null;
                              } else if (text != pass) {
                                setState(() {
                                  errorOldPass = "Passowrd doesn't match";
                                });
                                return null;
                              }
                              setState(() {
                                errorOldPass = "";
                              });
                              return null;
                            },
                            controller: textEditingControllerOldPass,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: passwordOldVisible ? false : true,
                            decoration: InputDecoration(
                              counterText: '',
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              icon: Icon(
                                Icons.lock,
                                color: kPrimaryColor,
                              ),
                              border: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  passwordOldVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: kPrimaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    passwordOldVisible = !passwordOldVisible;
                                  });
                                },
                              ),
                            ),
                            maxLength: 8,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, bottom: 10, top: 3),
                          child: Text(
                            errorOldPass,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),

                        // New Password
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 8),
                          child: Text(
                            "New Password",
                            style: TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              //color : Colors.red,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: height < 600 ? 47 : 54,
                          child: TextFormField(
                            validator: (text) {
                              RegExp regex = new RegExp("[']");
                              RegExp regex2 = new RegExp('["]');
                              if (text.isEmpty) {
                                setState(() {
                                  errorNewPass = "Enter password";
                                });
                                return null;
                              } else if (text.length < 6) {
                                setState(() {
                                  errorNewPass =
                                      "Password must have at least 6 characters";
                                });
                                return null;
                              } else if (text == pass) {
                                setState(() {
                                  errorNewPass =
                                      "New password & old password is same";
                                });
                                return null;
                              } else if (regex.hasMatch(text) ||
                                  regex2.hasMatch(text)) {
                                setState(() {
                                  errorNewPass = "Invalid Password !";
                                });
                                return null;
                              }
                              setState(() {
                                errorNewPass = "";
                              });
                              return null;
                            },
                            controller: textEditingControllerNewPass,
                            obscureText: passwordVisible ? false : true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration:
                                decPswd(context, 'New Password', setState),
                            maxLength: 8,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, bottom: 10, top: 3),
                          child: Text(
                            errorNewPass,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 8),
                          child: Text(
                            "Comfirm Password",
                            style: TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),

                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              //color : Colors.red,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: 54,
                          child: TextFormField(
                            validator: (text) {
                              RegExp regex = new RegExp("[']");
                              RegExp regex2 = new RegExp('["]');
                              if (text.isEmpty) {
                                setState(() {
                                  errorCPass = "Retype your password";
                                });
                                return null;
                              } else if (text !=
                                  textEditingControllerNewPass.text) {
                                setState(() {
                                  errorCPass = "Passowrd doesn't match";
                                });
                                return null;
                              } else if (regex.hasMatch(text) ||
                                  regex2.hasMatch(text)) {
                                setState(() {
                                  errorCPass = "Invalid Password !";
                                });
                                return null;
                              }
                              setState(() {
                                errorCPass = "";
                              });
                              return null;
                            },
                            obscureText: passwordVisible ? false : true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration:
                                decPswd(context, 'Comfirm Password', setState),
                            maxLength: 8,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 3),
                          child: Text(
                            errorCPass,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  FlatButton(
                    height: 40,
                    color: kPrimaryColor.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  FlatButton(
                    height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: kPrimaryColor,
                      onPressed: () {
                        formKey.currentState.validate();
 
                        if (errorCPass == '' &&
                            errorNewPass == '' &&
                            errorOldPass == '') {
                          setState(() {
                            isProgress = true;
                          });
                          changePassword(
                              textEditingControllerNewPass.text, context);
                        } else {
                          return;
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                         mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            "Change",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                              width: 18,
                              height: 18,
                              child: isProgress
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white))
                                  : SizedBox(
                                      width: 22,
                                    ))
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  Future buildChangeEmail(BuildContext context) {
    bool isProgress = false;
    String errorEmail = "";
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    TextEditingController textEditingControllerEmail =
        new TextEditingController();
    double height = MediaQuery.of(context).size.height;
    // Change Password Dailog Box
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => null,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  "Change Email",
                ),
                titlePadding: EdgeInsets.only(left: 16, top: 4),
                content: Form(
                  key: formKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 8),
                          child: Text(
                            "New Email",
                            style: TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              //color : Colors.red,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: height < 600 ? 47 : 54,
                          child: TextFormField(
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
                                  errorEmail = "Enter your new email";
                                });
                                return null;
                              } else if (text == email) {
                                setState(() {
                                  errorEmail = "New & old email is same";
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
                            keyboardType: TextInputType.emailAddress,
                            controller: textEditingControllerEmail,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                border: InputBorder.none,
                                counterText: '',
                                icon: Icon(
                                  Icons.email,
                                  color: kPrimaryColor,
                                ),
                                focusedErrorBorder: InputBorder.none),
                            maxLength: 150,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 3),
                          child: Text(
                            errorEmail,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
 
                actions: [
                  FlatButton(
                    height: 40,
                    color: kPrimaryColor.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  FlatButton(
                    height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: kPrimaryColor,
                      onPressed: () {
                        formKey.currentState.validate();
                        if (errorEmail == '') {
                          setState(() {
                            isProgress = true;
                          });
                          changeEmail(
                              textEditingControllerEmail.text, context);
                        } else {
                          return;
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            "Change",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                              width: 18,
                              height: 18,
                              child: isProgress
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white))
                                  : SizedBox(
                                      width: 22,
                                    ))
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  Future buildChangeMobile(BuildContext context) {
    bool isProgress = false;
    String errorMobile = "";
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    TextEditingController textEditingControllerMobile =
        new TextEditingController();
    double height = MediaQuery.of(context).size.height;
    // Change Password Dailog Box
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => null,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  "Change Mobile",
                ),
                titlePadding: EdgeInsets.only(left: 16, top: 4),
                content: Form(
                  key: formKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 8),
                          child: Text(
                            "New Mobile Number",
                            style: TextStyle(
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              //color : Colors.red,
                              borderRadius: BorderRadius.circular(15.0)),
                          height: height < 600 ? 47 : 54,
                          child: TextFormField(
                            inputFormatters: [
                              // ignore: deprecated_member_use
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            onFieldSubmitted: (text) {
                              formKey.currentState.validate();
                              if (errorMobile == '') {
                                setState(() {
                                  isProgress = true;
                                });
                                changeMobile(text, context);
                              } else {
                                return;
                              }
                            },
                            validator: (text) {
                              if (text.isEmpty) {
                                setState(() {
                                  errorMobile = "Enter your new mobile number";
                                });
                                return null;
                              } else if (text == mobile) {
                                setState(() {
                                  errorMobile =
                                      "New & old moble number is same";
                                });
                                return null;
                              } else if (text.length < 10 ||
                                  text.toString().substring(0, 2) != '07') {
                                setState(() {
                                  errorMobile = "Invalid mobile number !";
                                });
                                return null;
                              }
                              setState(() {
                                errorMobile = "";
                              });
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            controller: textEditingControllerMobile,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                border: InputBorder.none,
                                counterText: '',
                                icon: Icon(
                                  Icons.smartphone,
                                  color: kPrimaryColor,
                                ),
                                focusedErrorBorder: InputBorder.none),
                            maxLength: 10,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 3),
                          child: Text(
                            errorMobile,
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actionsPadding: EdgeInsets.only(bottom: 4),
                actions: [
                  FlatButton(
                    height: 40,
                    color: kPrimaryColor.withOpacity(0.6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                  FlatButton(
                    height: 40,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      color: kPrimaryColor,
                      onPressed: () {
                        formKey.currentState.validate();
                        if (errorMobile == '') {
                          setState(() {
                            isProgress = true;
                          });
                          changeMobile(
                              textEditingControllerMobile.text, context);
                        } else {
                          return;
                        }
                      },
                      child: Row(
                         mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 22,
                          ),
                          Text(
                            "Change",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          SizedBox(
                              width: 18,
                              height: 18,
                              child: isProgress
                                  ? CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.white))
                                  : SizedBox(
                                      width: 22,
                                    ))
                        ],
                      ))
                ],
              ),
            ),
          );
        });
  }

  Future<void> changePassword(String password, BuildContext context) async {
    try {
      String path = "$url/updatePassword.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "pass": "$password", "user": "$user"});

      String data = jsonDecode(response.body).toString();
      print(data);
      if (data == '0') {
        Flushbar(
          message: 'Something went to wrong ! Try again later',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else {
        Navigator.pop(context);
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'pass', value: pass);
        this.pass = password;
        Flushbar(
          message: 'Password changed success !',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.info,
            color: Colors.green,
          ),
        ).show(context);
      }
    } catch (e) {
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

  Future<void> changeEmail(String email, BuildContext context) async {
    try {
      String path = "$url/updateEmail.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "newEmail": "$email", "user": "$user"});

      String data = jsonDecode(response.body).toString();

      if (data == '0') {
        Flushbar(
          message: 'Email already use',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else {
        Navigator.pop(context);
        final storage = new FlutterSecureStorage();

        await storage.write(key: 'email', value: email);
        this.email = email;
        Flushbar(
          message: 'Email changed success !',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.info,
            color: Colors.green,
          ),
        ).show(context);
      }
    } catch (e) {
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

  Future<void> changeMobile(String mobile, BuildContext context) async {
    print(user);
    try {
      String path = "$url/updateMobile.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "mobile": "$mobile", "user": "$user"});

      String data = jsonDecode(response.body).toString();

      if (data == '0') {
        Flushbar(
          message: 'Something went to wrong ! Try again later',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else {
        Navigator.pop(context);
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'mobile', value: mobile);
        await storage.write(key: 'user', value: "91");
        this.mobile = mobile;
        Flushbar(
          message: 'Mobile number changed success !',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.info,
            color: Colors.green,
          ),
        ).show(context);
      }
    } catch (e) {
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
}
