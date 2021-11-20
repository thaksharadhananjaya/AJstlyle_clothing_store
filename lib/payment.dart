import 'dart:convert';

import 'package:ajstyle/config.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import 'package:http/http.dart' as http;

import 'order.dart';

class Payment extends StatefulWidget {
  final int cusID;
  final double total;
  Payment({Key key, this.total, this.cusID}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController textEditingControllerName = new TextEditingController();
  TextEditingController textEditingControllerMobile =
      new TextEditingController();
  TextEditingController textEditingControllerCity = new TextEditingController();
  TextEditingController textEditingControllerAddress =
      new TextEditingController();
  String dropdownDistrict;

  @override
  void initState() {
    super.initState();
    getShippingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
      bottomNavigationBar: buildPayButton(),
    );
  }

  Container buildPayButton() {
    return Container(
      color: kPrimaryColor,
      height: 55,
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            createOrder();
          }
          {
            return null;
          }
        },
        child: Text(
          'Process To Pay',
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  SafeArea buildBody() {
    return SafeArea(
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: KPaddingHorizontal, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Shipping",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    buildTextField("Name", Icon(Icons.person),
                        RegExp("[a-zA-Z ]"), textEditingControllerName, (text) {
                      if (text.isEmpty) {
                        return 'Enter you name';
                      }
                      return null;
                    }),
                    buildMobileTextField(),
                    buildTextField(
                        "Address",
                        Icon(Icons.local_post_office),
                        RegExp("[a-zA-Z-0-9-,/ ]"),
                        textEditingControllerAddress, (text) {
                      if (text.isEmpty) {
                        return 'Enter your address';
                      }
                      return null;
                    }),
                    buildTextField("City", Icon(Icons.location_city),
                        RegExp("[a-zA-Z]"), textEditingControllerCity, (text) {
                      if (text.isEmpty) {
                        return 'Enter you city';
                      }
                      return null;
                    }),
                    buildDistrict(context),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      "Payment Mothod",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.black54),
                          padding: EdgeInsets.all(8),
                          height: 50,
                          width: 150,
                          child: Text(
                            "Cash On Delivery",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {  startOneTimePayment(context);},
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black54),
                            padding: EdgeInsets.all(8),
                            height: 50,
                            width: 150,
                            child: Text(
                              "Card",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 28,
                    ),
                  ],
                ),
              ),
              buidPaymentSummery(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildDistrict(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
      height: 50,
      decoration: BoxDecoration(
          color: Colors.black12,
          //color : Colors.red,
          borderRadius: BorderRadius.circular(15.0)),
      child: DropdownButtonFormField(
          value: dropdownDistrict,
          validator: (text) {
            if (dropdownDistrict == null) {
              return 'Select District';
            }
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
              hintText: "District",
              hintStyle: TextStyle(
                color: kPrimaryColor.withOpacity(0.5),
              ),
              icon: Icon(Icons.location_city))),
    );
  }

  Column buidPaymentSummery() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildPrice("Total", widget.total.toStringAsFixed(2)),
        buildPrice("Shipping", "300.00"),
        buildNetTotal(),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget buildTextField(String name, Icon icon, RegExp regExp,
      TextEditingController textEditingController, Function validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.black12,
              //color : Colors.red,
              borderRadius: BorderRadius.circular(15.0)),
          child: TextFormField(
            controller: textEditingController,
            validator: validator,
            inputFormatters: [
              // ignore: deprecated_member_use
              new WhitelistingTextInputFormatter(regExp),
            ],
            decoration: InputDecoration(
                counterText: '',
                hintStyle: TextStyle(
                  color: kPrimaryColor.withOpacity(0.5),
                ),
                hintText: name,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                border: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                icon: icon),
          )),
    );
  }

  Widget buildMobileTextField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.black12,
              //color : Colors.red,
              borderRadius: BorderRadius.circular(15.0)),
          child: TextFormField(
            controller: textEditingControllerMobile,
            validator: (text) {
              if (text.isEmpty) {
                return "Enter Mobile No";
              }
              return null;
            },
            maxLength: 10,
            inputFormatters: [
              // ignore: deprecated_member_use
              new WhitelistingTextInputFormatter(RegExp("[0-9]")),
            ],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: kPrimaryColor.withOpacity(0.5),
                ),
                hintText: 'Mobile',
                counterText: '',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                border: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                icon: Icon(Icons.smartphone)),
          )),
    );
  }

  Padding buildPrice(String text, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          SizedBox(
            width: 130,
            child: Text(
              "LKR $price",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildNetTotal() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Net Total",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(
            width: 130,
            child: Text(
              "LKR ${(widget.total + 300).toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  void startOneTimePayment(BuildContext context) async {
    Map paymentObject = {
      "sandbox": true, // true if using Sandbox Merchant ID
      "merchant_id": "1219112", // Replace your Merchant ID
      "merchant_secret": "8cPAXnBsbyc4OUfQoKYxEX8bLPrGbnccG4Tsac2FFi7T",
      "notify_url": "https://ent13zfovoz7d.x.pipedream.net/",
      "order_id": "ItemNo12345",
      "items": "Hello from Flutter!",
      "amount": "50.00",
      "currency": "LKR",
      "first_name": "Saman",
      "last_name": "Perera",
      "email": "samanp@gmail.com",
      "phone": "0771234567",
      "address": "No.1, Galle Road",
      "city": "Colombo",
      "country": "Sri Lanka",
      "delivery_address": "No. 46, Galle road, Kalutara South",
      "delivery_city": "Kalutara",
      "delivery_country": "Sri Lanka",
      "custom_1": "",
      "custom_2": ""
    };

    PayHere.startPayment(paymentObject, (paymentId) {
      print("One Time Payment Success. Payment Id: $paymentId");
    }, (error) {
      print("One Time Payment Failed. Error: $error");
    }, () {
      print("One Time Payment Dismissed");
    });
  }

  void getShippingData() async {
    final storage = new FlutterSecureStorage();
    textEditingControllerName.text = await storage.read(key: "name");
    textEditingControllerAddress.text = await storage.read(key: "address");
    textEditingControllerMobile.text = await storage.read(key: "mobile");
    textEditingControllerCity.text = await storage.read(key: "city");
    dropdownDistrict = await storage.read(key: "district");
    setState(() {});
  }

  void createOrder() async {
    try {
      String path = "$url/createOrder.php";
      String date =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      final response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "customerID": "${widget.cusID}",
        "total": "${widget.total}",
        "name": "${textEditingControllerName.text}",
        "mobile": "${textEditingControllerMobile.text}",
        "city": "${textEditingControllerCity.text}",
        "address": "${textEditingControllerAddress.text}",
        "district": "$dropdownDistrict",
        "date": "$date",
      });
      var data = jsonDecode(response.body);

      if (data == '-1') {
        Flushbar(
          message: 'Your cart item empty !',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else if (data == '0') {
        Flushbar(
          message: 'Some item(s) out of stock ! Clear cart & try again',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Order(
                      customerID: widget.cusID,
                      isBack: false,
                    )));
        Flushbar(
          message: 'Your order has been submitted',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.info_rounded,
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
