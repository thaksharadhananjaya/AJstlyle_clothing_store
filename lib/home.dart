import 'dart:convert';

import 'package:ajstyle/productView.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:http/http.dart' as http;
import 'package:move_to_background/move_to_background.dart';
import 'package:card_loading/card_loading.dart';
import 'bloc/product_bloc.dart';
import 'config.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textEditingControllerSearch =
      new TextEditingController();
  ProductBloc productBloc, saleProductBloc;
  int indexCategory = 0;
  String cusID;
  @override
  void initState() {
    super.initState();

    productBloc = ProductBloc(false, null, 0);
    productBloc.add(FetchProduct());

    saleProductBloc = ProductBloc(true, null, 0);
    saleProductBloc.add(FetchProduct());
    getCusID();
  }

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
        backgroundColor: kBackgroundColor,
        appBar: buidAppBar(),
        body: buidBody(),
      ),
    );
  }

  Widget buidBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          SizedBox(
            height: KPaddingVertical,
          ),
          buildCategory(),
          textEditingControllerSearch.text.isEmpty
              ? (indexCategory == 0 ? buidSaleProductList() : SizedBox())
              : SizedBox(),
          Padding(
            padding: const EdgeInsets.only(
                left: KPaddingHorizontal, right: KPaddingVertical, top: 20),
            child: textEditingControllerSearch.text.isEmpty
                ? (indexCategory == 0
                    ? Text(
                        "For you",
                        style: TextStyle(fontSize: 20.0),
                      )
                    : Text(''))
                : Text(
                    "Result",
                    style: TextStyle(fontSize: 17.0),
                  ),
          ),
          buidProductList(),
        ],
      ),
    );
  }

  Widget buidSaleProductList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
      child: BlocBuilder(
          bloc: saleProductBloc,
          builder: (context, state) {
            if (state is LoadedProduct) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Sale",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Container(
                    height: 210,
                    color: kBackgroundColor,
                    child: LazyLoadScrollView(
                      onEndOfPage: () => productBloc.add(FetchProduct()),
                      scrollDirection: Axis.horizontal,
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 10.0),
                        shrinkWrap: true,
                        itemCount: state.productList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          double price =
                              double.parse(state.productList[index].price);
                          double salePrice =
                              double.parse(state.productList[index].salePrice);
                          double discount = (price - salePrice) / price * 100;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductView(
                                            cusID: cusID,
                                            productID: state
                                                .productList[index].productID,
                                            name: state.productList[index].name,
                                            price:
                                                state.productList[index].price,
                                            salePrice: state
                                                .productList[index].salePrice,
                                            discription: state
                                                .productList[index].discription,
                                            image:
                                                state.productList[index].image,
                                          )));
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, right: 22),
                                  child: Container(
                                    width: 180,
                                    height: 250,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            state.productList[index].image,
                                          ),
                                        ),
                                        color: kBackgroundColor),
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                          KPaddingHorizontal / 2),
                                      height: 50,
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.75),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text:
                                                    "${state.productList[index].name}\n"
                                                        .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .button),
                                            TextSpan(
                                              text:
                                                  "LKR ${double.parse(state.productList[index].salePrice).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange[700],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 190,
                                  height: 40,
                                  alignment: Alignment.topRight,
                                  child: Chip(
                                    padding: EdgeInsets.all(0),
                                    backgroundColor: Colors.red,
                                    label: Text('${discount.round()}% OFF',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              if (!(state is ProductErrorState)) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CardLoading(
                      height: 20,
                      width: 120,
                      padding: const EdgeInsets.only(bottom: 10),
                      borderRadius: 15,
                    ),
                    Row(
                      children: [
                        CardLoading(
                          height: 190,
                          width: 170,
                          padding: const EdgeInsets.only(bottom: 8),
                          borderRadius: 15,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        CardLoading(
                          height: 200,
                          width: 180,
                          padding: const EdgeInsets.only(bottom: 8),
                          borderRadius: 15,
                        ),
                      ],
                    ),
                  ],
                );
              }
              return SizedBox();
            }
          }),
    );
  }

  Widget buidProductList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KPaddingHorizontal),
      child: BlocBuilder(
          bloc: productBloc,
          builder: (context, state) {
            if (state is LoadedProduct) {
              return LazyLoadScrollView(
                onEndOfPage: () => productBloc.add(FetchProduct()),
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 15.0),
                  shrinkWrap: true,
                  itemCount: state.productList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.75,
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 12),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductView(
                                      cusID: cusID,
                                      productID:
                                          state.productList[index].productID,
                                      name: state.productList[index].name,
                                      price: state.productList[index].price,
                                      salePrice:
                                          state.productList[index].salePrice,
                                      discription:
                                          state.productList[index].discription,
                                      image: state.productList[index].image,
                                    )));
                      },
                      child: Container(
                        width: 150,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              state.productList[index].image,
                            ),
                          ),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(KPaddingHorizontal / 2),
                          height: 50,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.75),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "${state.productList[index].name}\n"
                                        .toUpperCase(),
                                    style: Theme.of(context).textTheme.button),
                                TextSpan(
                                  text:
                                      "LKR ${double.parse(state.productList[index].price).toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: kPrimaryColor.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return Row(
              children: [
                CardLoading(
                  height: 200,
                  width: 180,
                  padding: const EdgeInsets.only(bottom: 8),
                  borderRadius: 15,
                ),
                SizedBox(
                  width: 8,
                ),
                CardLoading(
                  height: 200,
                  width: 180,
                  padding: const EdgeInsets.only(bottom: 8),
                  borderRadius: 15,
                ),
              ],
            );
          }),
    );
  }

  Container buildCategory() {
    return Container(
      height: 30.0,
      child: FutureBuilder(
          future: getCategory(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = snapshot.data[index];

                  if (index == indexCategory) {
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Center(
                            child: Text(
                          data['category'],
                          style: TextStyle(color: Colors.white),
                        )));
                  } else {
                    return GestureDetector(
                      onTap: () {
                        textEditingControllerSearch.clear();
                        productBloc = ProductBloc(false, null, index);
                        productBloc.add(FetchProduct());
                        setState(() {
                          indexCategory = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(18.0)),
                        child: Center(
                            child: Text(
                          data['category'],
                          style: TextStyle(color: Colors.black),
                        )),
                      ),
                    );
                  }
                },
              );
            }
            return Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  CardLoading(
                    height: 20,
                    width: 120,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CardLoading(
                    height: 20,
                    width: 120,
                    padding: const EdgeInsets.only(bottom: 8),
                    borderRadius: 15,
                  ),
                ],
              ),
            );
          }),
    );
  }

  AppBar buidAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leadingWidth: 4,
      leading: Icon(
        Icons.access_alarm_sharp,
        color: kBackgroundColor,
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 13.0),
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(246, 246, 246, 1),
              //color : Colors.red,
              borderRadius: BorderRadius.circular(15.0)),
          child: TextField(
            controller: textEditingControllerSearch,
            inputFormatters: [
              // ignore: deprecated_member_use
              new WhitelistingTextInputFormatter(RegExp("[a-zA-Z-0-9-+_)( ]")),
            ],
            onChanged: (text) {
              if (text.isEmpty) {
                setState(() {
                  indexCategory = 0;
                  productBloc = ProductBloc(false, null, 0);
                  productBloc.add(FetchProduct());
                });
              }
            },
            onSubmitted: (text) {
              setState(() {
                if (text.isNotEmpty) {
                  indexCategory = 0;
                  productBloc = ProductBloc(false, text, 0);
                  productBloc.add(FetchProduct());
                }
              });
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Search ...",
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
      ),
    );
  }

  Future getCategory() async {
    try {
      String path = "$url/getCategory.php";

      final response =
          await http.post(Uri.parse(path), body: {"key": accessKey});
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

  void getCusID() async {
    final storage = new FlutterSecureStorage();
    cusID = await storage.read(key: "user");
  }
}
