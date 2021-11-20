import 'package:ajstyle/cart.dart';
import 'package:ajstyle/pofile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart';
import 'home.dart';
import 'splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      title: 'AJ STYLE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        
      ),
     home: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Splash();
            } else {
              return MainScren(index: 0);
            }
          }),
    );
  }
}

class MainScren extends StatefulWidget {
  MainScren({Key key, @required this.index}) : super(key: key);
  final int index;

  @override
  _MainScrenState createState() => _MainScrenState();
}

class _MainScrenState extends State<MainScren> {
  int index = 0;
  @override
  void initState() {
    super.initState();

    index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    print(height);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: index == 0 ? Home() : (index == 1 ? Cart() : Pofile()),
      bottomNavigationBar: CurvedNavigationBar(
        index: index,
        backgroundColor: Colors.transparent,
        color: Colors.black,
        height: height < 684 ? (height < 593 ? 43 : 50) : 62,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(Icons.shopping_cart, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }
}
