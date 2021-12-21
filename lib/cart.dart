import 'dart:convert';

import 'package:ajstyle/config.dart';
import 'package:ajstyle/payment.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:move_to_background/move_to_background.dart';

class Cart extends StatefulWidget {
  Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int cusID;
var products ;
  @override
  Widget build(BuildContext context) {
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        {
          MoveToBackground.moveTaskToBack();
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Container(
          padding: EdgeInsets.only(top: 24),
          child: FutureBuilder(
              future: isLoging(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  cusID = int.parse(snapshot.data);
                  getTotal();
                  return Column(
                    children: [buildCart(hight), buildCheckout(hight, width)],
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/emptyCart.jpg",
                          fit: BoxFit.scaleDown,
                        ),
                        Text(
                          "Empty Cart !",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }

  FutureBuilder buildCheckout(double hight, double width) {
    return FutureBuilder(
        future: getTotal(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: hight * 0.38 - 108,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  buildPrice("Total", double.parse(snapshot.data)),
                  buildPrice("Delivery", 300.00),
                  buildNetTotal(double.parse(snapshot.data)),
                  buidCheckoutButton(width, double.parse(snapshot.data))
                ],
              ),
            );
          }
          return SizedBox();
        });
  }

  Padding buildNetTotal(double total) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 26),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Net Total",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            width: 130,
            child: Text(
              "LKR ${(total + 300).toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildPrice(String text, double price) {
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
                fontSize: 16),
          ),
          SizedBox(
            width: 130,
            child: Text(
              "LKR ${price.toStringAsFixed(2)}",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Container buidCheckoutButton(double width, double total) {
    return Container(
      height: 48,
      width: width * 0.40,
      decoration: BoxDecoration(
          color: Colors.orange, borderRadius: BorderRadius.circular(12)),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Payment(
                  total: total,
                  cusID: cusID,
                  products: products,
                ),
              ));
        },
        child: Text(
          "Checkout",
          style: TextStyle(color: kBackgroundColor, fontSize: 19),
        ),
      ),
    );
  }

  Widget buildCart(double height) {
    return Container(
      height: height * 0.62,
      padding:
          EdgeInsets.symmetric(horizontal: KPaddingHorizontal, vertical: 24),
      child: FutureBuilder(
          future: getCart(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != '0') {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = snapshot.data[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        height: 95,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 9)
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                            margin:
                                                const EdgeInsets.only(right: 8),
                                            height: 22,
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        18.0)),
                                            child: Center(
                                                child: Text(
                                              data['color'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                            ))),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 4, bottom: 8),
                                          width: 23.0,
                                          height: 23.0,
                                          child: Center(
                                              child: Text(
                                            data['size'],
                                          )),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey[500])),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "LKR ${double.parse(data['price']).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Text(data['qty'],
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 50,
                                ),
                                GestureDetector(
                                  onTap: () => removeItem(
                                      int.parse(data['productID']),
                                      data['size'],
                                      data['color']),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.red[400]),
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else if (snapshot.data == '0') {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/emptyCart.jpg",
                      fit: BoxFit.scaleDown,
                    ),
                    Text(
                      "Empty Cart !",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
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
                    height: 90,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 95,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 95,
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CardLoading(
                    height: 95,
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

  Future isLoging() async {
    final storage = new FlutterSecureStorage();
    return storage.read(key: "user");
  }

  Future getCart() async {
    try {
      String path = "$url/getCart.php";

      final response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "customerID": "$cusID",
      });
      products = jsonDecode(response.body);
      return products;
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

  Future getTotal() async {
    try {
      String path = "$url/getCartTotal.php";

      final response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "customerID": "$cusID",
      });
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

  void removeItem(int productID, String size, String color) async {
    try {
      String path = "$url/removeCartItem.php";

      final response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "customerID": "$cusID",
        "productID": "$productID",
        "color": "$color",
        "size": "$size"
      });
      var data = jsonDecode(response.body);

      if (data == '1') {
        setState(() {});
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
