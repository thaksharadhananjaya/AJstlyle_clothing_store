import 'dart:convert';

import 'package:ajstyle/config.dart';
import 'package:ajstyle/main.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'orderItems.dart';

class Order extends StatelessWidget {
  final int customerID;
  final bool isBack;
  const Order({Key key, this.customerID, @required this.isBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (isBack) {
          Navigator.of(context).pop();
          return null;
        } else {
          return Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainScren(index: 0)));
        }
      },
      child: buildScaffold(context),
    );
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
              Text("My Orders",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
              SizedBox(
                height: 30,
              ),
              buildOrders(context),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildOrders(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
          future: getOrders(context),
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
                      "No Order Found !",
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

  Container builtCard(BuildContext context, int index, data) {
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 9)
          ],
          color: index % 2 == 0 ? Colors.white : Colors.white54),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderItems(
                        orderID: data['orderID'],
                        name: data['name'],
                        mobile: data['mobile'],
                        address: data['address'],
                        city: data['city'],
                        district: data['district'],
                        total: double.parse(
                          data['total'],
                        ),
                      )));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "#${data['orderID']}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black54),
                ),
                Text("${data['date']}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black54)),
                Text(
                    "LKR ${(double.parse(data['total']) + 300).toStringAsFixed(2)}  ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black54)),
              ],
            ),
            
            
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: data["status"] == "0"?  kPrimaryColor: (data["status"] == "1" ? Colors.green: Colors.red)
              ),
              child: Text(
                  data["status"] == "0"
                      ? "Processing"
                      : (data["status"] == "1" ? "Shipped" : "Contact Failed"),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: kBackgroundColor)),
            )
          ],
        ),
      ),
    );
  }

  Future getOrders(BuildContext context) async {
    try {
      String path = "$url/getOrders.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "customerID": "$customerID"});
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
