// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:ajstyle/config.dart';

import 'package:another_flushbar/flushbar.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

class OtherPayment extends StatelessWidget {
  final int customerID;
  String name, city, mobile, district, address;
  TextEditingController textEditingControllerDescription =
      new TextEditingController();
  TextEditingController textEditingControllerAmount =
      new TextEditingController();
  OtherPayment({
    Key key,
    this.customerID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: KPaddingHorizontal, vertical: KPaddingVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Other Payments",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              SizedBox(
                height: 30,
              ),
              buildPayments(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => buildPaymentDialog(context),
        backgroundColor: kPrimaryColor,
        child: Icon(
          Icons.payment,
          color: Colors.white,
        ),
      ),
      /*
      bottomNavigationBar: FlatButton(
        color: Colors.red,
        height: 50,
        child: Text(
          "Clear All",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {},
      ),*/
    );
  }

  Expanded buildPayments(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
          future: getPayment(context),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != '0') {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapshot.data[index];
                    return builtCard(context, index, data);
                  });
            } else if (snapshot.data == '0') {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/noOrder.png",
                      width: 250,
                    ),
                    Text(
                      "No Payment Found !",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              );
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
              child: Column(
                children: [
                  CardLoading(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 60,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget builtCard(BuildContext context, int index, data) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 1)
          ],
          color: index % 2 == 0 ? Colors.white70 : Colors.white38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#${data['paymentID']}",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          Text("${data['date']}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black54)),
          Text("LKR ${(double.parse(data['amount'])).toStringAsFixed(2)}  ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black54)),
        ],
      ),
    );
  }

  Future buildPaymentDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width - 30;

          return WillPopScope(
            onWillPop: () async => null,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Text(
                "Payment Amount",
              ),
              titlePadding: EdgeInsets.only(left: 16, top: 4),
              content: SingleChildScrollView(
                child: TextFormField(
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                  ],
                  controller: textEditingControllerAmount,
                  decoration: InputDecoration(
                      labelText: "Amount (LKR)",
                      hintText: "0.00",
                      counterText: "",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black87)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8)),
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
                    color: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      if (textEditingControllerAmount.text.isNotEmpty) {
                        startOneTimePayment(context);
                      }
                    },
                    child: Text(
                      "Pay",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          );
        });
  }

  void startOneTimePayment(BuildContext context) async {
    Map paymentObject = {
      "sandbox": false,
      "merchant_id": "219370", // Replace your Merchant ID
      "merchant_secret": "4vTWsqjEgYW4UtyCIJI3Jl8m8Tlq3eE6A4vRzf2ARfta",
      "notify_url": "https://ent13zfovoz7d.x.pipedream.net/",
      "order_id": "",
      "items": "payment",
      "amount": "${textEditingControllerAmount.text}",
      "currency": "LKR",
      "first_name": "$name",
      "last_name": "",
      "email": "",
      "phone": "$mobile",
      "address": "$address",
      "city": "$city",
      "country": "Sri Lanka",
      "delivery_address": "$address",
      "delivery_city": "$city",
      "delivery_country": "Sri Lanka",
      "custom_1": "",
      "custom_2": ""
    };

    PayHere.startPayment(paymentObject, (paymentId) {
      createPayment(context);
      Navigator.of(context).pop();
    }, (error) {
      Flushbar(
        message: "Payment Failed !",
        messageColor: Colors.red,
        backgroundColor: kPrimaryColor,
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.warning_rounded,
          color: Colors.red,
        ),
      ).show(context);
    }, () {
      // print("One Time Payment Dismissed");
    });
  }

  void createPayment(BuildContext context) async {
    try {
      String path = "$url/createPayment.php";
      String date =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      final response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "customerID": "$customerID",
        "amount": "${textEditingControllerAmount.text}",
        //"description": "${textEditingControllerDescription.text}",
        "date": "$date",
      });
      var data = jsonDecode(response.body);

      if (data == '0') {
        Flushbar(
          message: 'Some thing went wrong !',
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else {
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

  Future getPayment(BuildContext context) async {
    try {
      String path = "$url/getPayment.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "customerID": "$customerID"});
      print("data: ${response.body}");
      var data = jsonDecode(response.body);
      //print("data: $data");
      return data;
    } catch (e) {
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
