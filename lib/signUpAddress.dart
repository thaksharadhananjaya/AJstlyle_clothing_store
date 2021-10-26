import 'dart:convert';

import 'package:ajstyle/main.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'config.dart';

class SignUpAddress extends StatefulWidget {
  final String name, address, district, city, text;
  final int user;
  SignUpAddress(
      {Key key,
      @required this.user,
      this.name,
      this.address,
      this.district,
      this.city,
      @required this.text})
      : super(key: key);

  @override
  _SignUpAddressState createState() => _SignUpAddressState();
}

class _SignUpAddressState extends State<SignUpAddress> {
  String dropdownDistrict;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textnameController = new TextEditingController();
  TextEditingController textPAddressController = new TextEditingController();
  TextEditingController textCityController = new TextEditingController();
  String errorName = '', errorCity = '', errorAdds = '', errorDistrict = '';
  bool isProgress = false;

  @override
  void initState() {
    super.initState();

    if (widget.name != null) textnameController.text = widget.name;
    if (widget.address != null) textPAddressController.text = widget.address;
    if (widget.district != null) textCityController.text = widget.city;
    if (widget.district != null) dropdownDistrict = widget.district;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.text == "Change Shipping Address") {
          return Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScren(
                        index: 2,
                      )));
        }
        return null;
      },
      child: Scaffold(
        body: SafeArea(child: buildBody()),
      ),
    );
  }

  Container buildBody() {
    double height = MediaQuery.of(context).size.height;
    return Container(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: KPaddingHorizontal, right: KPaddingHorizontal, bottom: KPaddingVertical+10),
              child: Column(
                children: [
                  SizedBox(
                height: height < 684 ? (height < 593 ? 30 : 55) : 60,
              ),
                  Text(widget.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                height: height < 684 ? (height < 593 ? 32 : 58) : 65,
              ),
                  buildNameTextField(),
                  buildAddressTextField(),
                  buildCityTextField(),
                  buildDistrict(),
                  buildFinishButton(),
                ],
              ),
            ),
          ),
        ));
  }

  SizedBox buildFinishButton() {
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
          if (errorName == '' &&
              errorAdds == '' &&
              errorCity == '' &&
              errorDistrict == '') {
            setState(() {
              isProgress = true;
            });
            updateCustomer();
          } else {}
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 32,
            ),
            Text(widget.text == "Shipping Address" ? "Finish" : "Save",
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
                  : CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.transparent)),
            )
          ],
        ),
      ),
    );
  }

  Padding buildDistrict() {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 8),
            child: Text(
              "District",
              style: TextStyle(
                color: kPrimaryColor,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
            height: height < 600 ? 45 : 50,
            decoration: BoxDecoration(
                color: Colors.black12,
                //color : Colors.red,
                borderRadius: BorderRadius.circular(15.0)),
            child: DropdownButtonFormField(
                value: dropdownDistrict,
                validator: (text) {
                  if (dropdownDistrict == null) {
                    setState(() {
                      errorDistrict = 'Select District';
                    });
                    return null;
                  }
                  setState(() {
                    errorDistrict = "";
                  });
                  return null;
                },
                onChanged: (newValue) {
                  dropdownDistrict = newValue;
                  FocusScope.of(context).unfocus();
                },
                items: district.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  border: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  hintText: "Select District",
                  hintStyle: TextStyle(
                    color: kPrimaryColor.withOpacity(0.5),
                  ),
                  icon: Icon(
                    Icons.location_city,
                    color: kPrimaryColor,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 32, top: 3),
            child: Text(
              errorDistrict,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNameTextField() {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 8),
          child: Text(
            "Name",
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
              controller: textnameController,
              validator: (text) {
                if (text.isEmpty) {
                  setState(() {
                    errorName = 'Enter your name';
                  });
                  return null;
                }
                setState(() {
                  errorName = "";
                });
                return null;
              },
              inputFormatters: [
                // ignore: deprecated_member_use
                new WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),
              ],
              keyboardType: TextInputType.name,
              maxLength: 150,
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
                  Icons.person,
                  color: kPrimaryColor,
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12, top: 3),
          child: Text(
            errorName,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget buildCityTextField() {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 8),
          child: Text(
            "City",
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
              controller: textCityController,
              validator: (text) {
                if (text.isEmpty) {
                  setState(() {
                    errorCity = 'Enter your city';
                  });
                  return null;
                }
                setState(() {
                  errorCity = "";
                });
                return null;
              },
              inputFormatters: [
                // ignore: deprecated_member_use
                new WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")),
              ],
              keyboardType: TextInputType.name,
              maxLength: 100,
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
                  Icons.location_city,
                  color: kPrimaryColor,
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12, top: 3),
          child: Text(
            errorCity,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget buildAddressTextField() {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 8),
          child: Text(
            "Address",
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
              controller: textPAddressController,
              validator: (text) {
                if (text.isEmpty) {
                  setState(() {
                    errorAdds = 'Enter your address';
                  });
                  return null;
                }
                setState(() {
                  errorAdds = "";
                });
                return null;
              },
              inputFormatters: [
                // ignore: deprecated_member_use
                new WhitelistingTextInputFormatter(RegExp("[a-zA-Z-0-9-,/ ]")),
              ],
              maxLength: 200,
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
            errorAdds,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Future<void> updateCustomer() async {
    try {
      String path = "$url/setupAddress.php";

      final response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "user": "${widget.user}",
        "name": "${textnameController.text}",
        "city": "${textCityController.text}",
        "district": "$dropdownDistrict",
        "address": "${textPAddressController.text}",
      });
      String data = jsonDecode(response.body).toString();

      if (data == '0') {
        setState(() {
          isProgress = false;
        });
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
        final storage = new FlutterSecureStorage();
        await storage.write(key: 'name', value: textnameController.text);
        await storage.write(key: 'address', value: textPAddressController.text);
        await storage.write(key: 'city', value: textCityController.text);
        await storage.write(key: 'district', value: dropdownDistrict);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainScren(
                      index: 2,
                    )));
        if (widget.text == "Change Shipping Address") {
          Flushbar(
            message: 'Update success !',
            messageColor: Colors.green,
            backgroundColor: kPrimaryColor,
            duration: Duration(seconds: 3),
            icon: Icon(
              Icons.info,
              color: Colors.green,
            ),
          ).show(context);
        }
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
}
