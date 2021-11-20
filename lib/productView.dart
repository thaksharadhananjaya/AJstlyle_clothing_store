// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:ajstyle/main.dart';
import 'package:ajstyle/util/customStepper.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:badges/badges.dart';
import 'package:card_loading/card_loading.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';
import 'util/imageViewer.dart';

class ProductView extends StatefulWidget {
  String name, price, salePrice, discription, image, cusID;
  final int productID;
  ProductView(
      {Key key,
      @required this.name,
      @required this.price,
      @required this.salePrice,
      @required this.image,
      @required this.productID,
      @required this.discription,
      @required this.cusID})
      : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  CarouselController carouselController = CarouselController();
  int qty = 1, selectQty = 1, numCart = 0;
  String color, image, size;
  double salePrice, price;
  List<String> images;
  @override
  void initState() {
    super.initState();
    getImgs();
    getNumCart();
    price = double.parse(widget.price);
    salePrice = double.parse(widget.salePrice);
    image = widget.image;
    images = [widget.image];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        bottomNavigationBar: buildBottomButtons(),
        body: buildBody(context));
  }

  CustomScrollView buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[buildSiliverAppbar(), buildSiliverBody()],
    );
  }

  SliverAppBar buildSiliverAppbar() {
    return SliverAppBar(
      backgroundColor: kBackgroundColor,
      expandedHeight: MediaQuery.of(context).size.height * 0.35,
      flexibleSpace: buildFlexibleSpace(),
      automaticallyImplyLeading: false,
    );
  }

  SafeArea buildFlexibleSpace() {
    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onTap: null,
            child: CarouselSlider.builder(
              itemCount: images.length,
              carouselController: carouselController,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return Container(
                  child: Image.network(images[itemIndex]),
                );
              },
              options: CarouselOptions(
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reseon) {

                    if (index != 0) {
                      var parts = images[index].split("_");

                      setState(() {
                        color = parts[1];
                        size = parts[2].substring(0, parts[2].length - 4);
                        getVarientData();
                      });
                    } else {
                      setState(() {
                        qty = 1;
                        color = null;
                        size = null;
                      });
                    }
                  }),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    numCart == 0
                        ? Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.black,
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScren(
                                            index: 1,
                                          )));
                            },
                            child: Badge(
                                badgeColor: Color.fromRGBO(233, 95, 95, 1),
                                padding: EdgeInsets.all(7.0),
                                position:
                                    BadgePosition.topStart(start: 17, top: -12),
                                badgeContent: Text(
                                  "$numCart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.black,
                                )),
                          ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  SliverList buildSiliverBody() {
    return SliverList(
      delegate: SliverChildListDelegate([
        Container(
          padding: EdgeInsets.symmetric(
              vertical: 20, horizontal: KPaddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              salePrice == price
                  ? Text(
                      "LKR ${salePrice.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LKR ${salePrice.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700]),
                        ),
                        Text(
                          "LKR ${price.toStringAsFixed(2)}",
                          style: TextStyle(
                              fontSize: 20.0,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ],
                    ),
              SizedBox(
                height: 24,
              ),
              Text(
                "Color",
                style: TextStyle(fontSize: 16.0),
              ),
              buildColor(),
              SizedBox(
                height: 16,
              ),
              Text(
                "Size",
                style: TextStyle(fontSize: 16.0),
              ),
              buildSize(),
              SizedBox(
                height: 16,
              ),
              Text(
                "Qty",
                style: TextStyle(fontSize: 16.0),
              ),
              qty != 0
                  ? CustomStepper(
                      value: 1,
                      maxValue: qty,
                      onChanged: (value) {
                        selectQty = value;
                      })
                  : Text(
                      "Out OF Stock !",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Description",
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                widget.discription,
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
              FutureBuilder(
                  future: getSizeChart(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      List<TableRow> rows = [];
                      for (int i = 0; i < data.length; ++i) {
                        var parts = data[i]['data'].toString().split('|');
                        if (i == 0) {
                          List<Text> cell = [];
                          cell.add(Text(" Size",
                              style: TextStyle(fontWeight: FontWeight.w700)));
                          for (int j = 0; j < parts.length; j++) {
                            cell.add(Text(" ${parts[j]} ",
                                style: TextStyle(fontWeight: FontWeight.w600)));
                          }
                          rows.add(TableRow(children: cell));
                        } else {
                          List<Text> cell = [];
                          for (int j = 0; j < parts.length; j++) {
                            j == 0
                                ? cell.add(Text(" ${parts[j]}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)))
                                : cell.add(Text(
                                    parts[j],
                                    textAlign: TextAlign.center,
                                  ));
                          }
                          rows.add(TableRow(children: cell));
                        }
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 10),
                            child: Text("Size Chart (inch)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 18)),
                          ),
                          Table(
                              border: TableBorder.all(),
                              columnWidths: {0: FlexColumnWidth(0.6)},
                              children: rows),
                          SizedBox(
                            height: 4,
                          )
                        ],
                      );
                    }
                    return SizedBox();
                  })
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildSize() {
    return FutureBuilder(
        future: getSize(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != '0') {
            return Container(
                height: 35,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];
                      if (size == data['size']) {
                        return Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 32.0,
                            height: 32.0,
                            child: Center(
                                child: Text(
                              data['size'],
                              style: TextStyle(color: Colors.white),
                            )),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(170, 179, 188, 1),
                              border: Border.all(
                                  color: Color.fromRGBO(207, 205, 217, 1),
                                  width: 3),
                            ));
                      } else {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              size = data['size'];
                            });
                            if (size != null && color != null) {
                              int index = images.indexOf("https://ajstyle.lk/uploads/${widget.productID}"+"_"+color+"_"+"$size.jpg");
                              carouselController.jumpToPage(index);
                              getVarientData();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 32.0,
                            height: 32.0,
                            child: Center(
                                child: Text(
                              data['size'],
                            )),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[500])),
                          ),
                        );
                      }
                    }));
          } else if (snapshot.data == '0') {
            return Text(
              "No sizes !",
              style: TextStyle(color: Colors.red),
            );
          }
          return Row(
            children: [
              CardLoading(
                height: 30,
                width: 30,
                padding: const EdgeInsets.only(bottom: 8),
                borderRadius: 50,
              ),
              SizedBox(
                width: 5,
              ),
              CardLoading(
                height: 30,
                width: 30,
                padding: const EdgeInsets.only(bottom: 8),
                borderRadius: 50,
              ),
              SizedBox(
                width: 5,
              ),
              CardLoading(
                height: 30,
                width: 30,
                padding: const EdgeInsets.only(bottom: 8),
                borderRadius: 50,
              ),
            ],
          );
        });
  }

  FutureBuilder buildColor() {
    return FutureBuilder(
        future: getColor(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != '0') {
            return Container(
                height: 35,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data[index];

                      if (color == data['color']) {
                        return Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 120,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(18.0)),
                            child: Center(
                                child: Text(
                              data['color'],
                              style: TextStyle(color: Colors.white),
                            )));
                      } else {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              color = data['color'];
                            });
                            if (size != null && color != null) {
                              int index = images.indexOf("https://ajstyle.lk/uploads/${widget.productID}"+"_"+color+"_"+"$size.jpg");
                              carouselController.jumpToPage(index);
                              getVarientData();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            width: 120,
                            height: 8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(18.0)),
                            child: Center(
                                child: Text(
                              data['color'],
                              style: TextStyle(color: Colors.black),
                            )),
                          ),
                        );
                      }
                    }));
          } else if (snapshot.data == '0') {
            return Text(
              "No colours !",
              style: TextStyle(color: Colors.red),
            );
          }
          return Row(
            children: [
              CardLoading(
                height: 30,
                width: 30,
                padding: const EdgeInsets.only(bottom: 8),
                borderRadius: 50,
              ),
              SizedBox(
                width: 5,
              ),
              CardLoading(
                height: 30,
                width: 30,
                padding: const EdgeInsets.only(bottom: 8),
                borderRadius: 50,
              ),
              SizedBox(
                width: 5,
              ),
              CardLoading(
                height: 30,
                width: 30,
                padding: const EdgeInsets.only(bottom: 8),
                borderRadius: 50,
              ),
            ],
          );
        });
  }

  Container buildBottomButtons() {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
              future: getWApp(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: width * 0.3,
                    height: 60,
                    color: Color.fromRGBO(228, 227, 233, 50),
                    child: IconButton(
                        onPressed: () async {
                          String msg = "*${widget.name}*\n";

                          if (color != null) {
                            msg += "*Colour: $color*\n";
                          }
                          if (size != null) {
                            msg += "*Size: $size*\n";
                          }

                          await launch(
                              'whatsapp://send?phone=+94${snapshot.data}&text=$msg',
                              forceSafariVC: false,
                              forceWebView: false);
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: kPrimaryColor,
                        )),
                  );
                }
                return Container(
                  width: width * 0.3,
                  height: 60,
                  color: Color.fromRGBO(228, 227, 233, 50),
                  child: IconButton(
                      onPressed: null,
                      icon: FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: kPrimaryColor,
                      )),
                );
              }),
          Container(
            width: width * 0.7,
            height: 60,
            color: kPrimaryColor,
            child: FlatButton.icon(
                onPressed: () {
                  if (size != null && color != null) {
                    if (widget.cusID != null) {
                      if (qty != 0) addToCart();
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScren(index: 2)));
                    }
                  } else {
                    Flushbar(
                      message: "Select colour & size !",
                      messageColor: Colors.orange,
                      backgroundColor: kPrimaryColor,
                      duration: Duration(seconds: 3),
                      icon: Icon(
                        Icons.warning_rounded,
                        color: Colors.orange,
                      ),
                    ).show(context);
                  }
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                label: Text(
                  "Add to cart",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
          )
        ],
      ),
    );
  }

  Future getColor() async {
    try {
      String path = "$url/getColor.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "productID": "${widget.productID}"});
      var data = jsonDecode(response.body);

      return data;
    } catch (e) {}
  }

  Future getSize() async {
    try {
      String path = "$url/getSize.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "productID": "${widget.productID}"});
      var data = jsonDecode(response.body);
      return data;
    } catch (e) {}
  }

  Future getSizeChart() async {
    try {
      String path = "$url/getSizeChart.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "productID": "${widget.productID}"});
      var data = jsonDecode(response.body);
      return data;
    } catch (e) {}
  }

  void getImgs() async {
    try {
      String path = "$url/getImgs.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "productID": "${widget.productID}"});
      var data = jsonDecode(response.body);
      for (var iamge in data) {
        images.add(iamge['image']);
      }
      setState(() {});
    } catch (e) {}
  }

  void getNumCart() async {
    try {
      String path = "$url/getNumCart.php";

      final response = await http.post(Uri.parse(path),
          body: {"key": accessKey, "customerID": "${widget.cusID}"});
      String data = jsonDecode(response.body).toString();

      if (data != 'null') {
        setState(() {
          numCart = int.parse(data);
        });
      }
    } catch (e) {}
  }

  Future getWApp() async {
    try {
      String path = "$url/getWApp.php";

      final response =
          await http.post(Uri.parse(path), body: {"key": accessKey});
      String data = jsonDecode(response.body).toString();

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

  void getVarientData() async {
    try {
      String path = "$url/getVarientData.php";

      final response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "productID": "${widget.productID}",
        "color": "$color",
        "size": "$size"
      });
      var data = jsonDecode(response.body);

      if (data != '0') {
        setState(() {
          price = double.parse(data[0]['price']);
          salePrice = double.parse(data[0]['salePrice']);
          image = data[0]['image'];
          qty = int.parse(data[0]['qty']);
        });
      } else {
        setState(() {
          color = null;
          size = null;

          price = double.parse(widget.price);
          salePrice = double.parse(widget.salePrice);
          image = widget.image;
          qty = 1;
        });
        Flushbar(
          message: "Selected item not found",
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

  void addToCart() async {
    try {
      String path = "$url/addtoCart.php";

      String date =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

      final response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "customerID": "${widget.cusID}",
        "productID": "${widget.productID}",
        "color": "$color",
        "size": "$size",
        "qty": "$selectQty",
        "price": "$salePrice",
        "date": "$date"
      });
      selectQty = 1;
      var data = jsonDecode(response.body);

      if (data != '0') {
        Flushbar(
          message: 'Added to cart !',
          messageColor: Colors.green,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.info_rounded,
            color: Colors.green,
          ),
        ).show(context);
        setState(() {
          numCart = int.parse(data);
        });
      } else if (data == '0') {
        Flushbar(
          message: "This product not available !",
          messageColor: Colors.red,
          backgroundColor: kPrimaryColor,
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.red,
          ),
        ).show(context);
      } else if (data == '-1') {
        Flushbar(
          message: "Something went to wrong !",
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
