import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class OrderItems extends StatelessWidget {
  final String orderID;
  final String name, city, address, mobile, district;
  final double total;
  const OrderItems(
      {Key key,
      this.orderID,
      this.name,
      this.city,
      this.address,
      this.mobile,
      this.district,
      this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text("#${orderID.toString()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: KPaddingVertical),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildItems(context, height),
            Container(
                height: height * 0.38 - 80,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(
                    vertical: 20, horizontal: KPaddingHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shipping",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(name),
                    Text("0$mobile"),
                    Text(
                      address,
                      maxLines: 1,
                    ),
                    Text(city),
                    Text(district),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Net Total",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("LKR ${(total + 300).toStringAsFixed(2)}"),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Container buildItems(BuildContext context, double height) {
    return Container(
      height: height * 0.54,
      padding: EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
      child: FutureBuilder(
          future: getOrderItems(context, int.parse(orderID)),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != '0') {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapshot.data[index];
                    return builtCard(index, data);
                  });
            } else if (snapshot.data == '0') {
              return Container();
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
              child: Column(
                children: [
                  CardLoading(
                    height: 80,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 80,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 80,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 80,
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

  Container builtCard(int index, data) {
    return Container(
      height: 95,
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 9)
          ],
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Set Product Image
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                data['image'],
                width: 40,
                height: 40,
                fit: BoxFit.scaleDown,
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['name'],
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 22,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(18.0)),
                          child: Center(
                              child: Text(
                            data['color'],
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ))),
                      Container(
                        margin: EdgeInsets.only(top: 4, bottom: 8),
                        width: 23.0,
                        height: 23.0,
                        child: Center(
                            child: Text(
                          data['size'],
                        )),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[500])),
                      ),
                    ],
                  ),
                  Text(
                    "LKR ${double.parse(data['price']).toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ],
              ),
            ],
          ),

          Row(
            children: [
              Text(data['qty'],
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                width: 24,
              ),
              Text(
                  "LKR ${(double.parse(data['price']) * int.parse(data['qty'])).toStringAsFixed(2)}",
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold))
            ],
          )
        ],
      ),
    );
  }

  Future getOrderItems(BuildContext context, int orderID) async {
    try {
      String path = "$url/getOrderItems.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "orderID": "$orderID"});
      var data = jsonDecode(response.body);

      return data;
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
