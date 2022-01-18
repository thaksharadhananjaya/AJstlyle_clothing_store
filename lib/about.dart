import 'package:ajstyle/config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height *
        MediaQuery.of(context).devicePixelRatio;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
            ),
            Expanded(child: buildBody(height, width)),
          ],
        ),
      ),
    );
  }

  Container buildBody(double height, double width) {
    return Container(
      width: double.infinity,
      height: 700,
      padding: height > 1184
          ? EdgeInsets.symmetric(vertical: 20, horizontal: 40)
          : EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/ajlogo.jpg',
                  fit: BoxFit.scaleDown,
                  height: 180,
                  width: 190,
                ),
                Text(
                  'V 1.1.0',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 36,
            ),
            Text(
              '''Join us Stylish customers for New Trendy designs.
Find clothes and fashion and discover great deals in this app near you or reach even more people by delivering Islandwide. Buy stuff faster and safer than ever. With Buyer Protection we give you peace of mind. Know your item will arrive as expected, or you'll get your money back! Make great bargains, great deals.  It’s so easy to buyclothes, sneakers and with our fashion community.. Shop clothes, fashion brands, and rare vintage pieces. 

🔶️Affordable price.
🔶️Best Quality.
🔶️Attractive Designs.
🔶️Choose your Size.
🔶️Easy to use this app. 

📍Get Buyer Protection and Payment Guarantees with secure delivery
📍Best buy hour near me - in your phone, in our fashinova customer service. Express and reliable prime delivery.  
📍Stay tuned for discounts and promotions.  
📍You can find lowest prices.   

Vintage clothes and fashion, designer clothing, men’s clothing and ( T-shirts, Shirts, Trousers, Skinners or Arm cuts, Shorts, Hoodies.....) streetwear, shoes, Perfumes, Earings, Chains, sports equipment and All clothing stuff for men and much more! 

Install and start shopping! 

We love to hear your feedback about Marketplace. Make sure to give us a rating.''',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 12,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: () async {
                  await launch('https://www.facebook.com/ajstyle.galle',
                      forceSafariVC: false, forceWebView: false);
                },
                child: FaIcon(
                  FontAwesomeIcons.facebookSquare,
                  color: Colors.lightBlue,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: () async {
                  await launch('whatsapp://send?phone=+94771304324',
                      forceSafariVC: false, forceWebView: false);
                },
                child: FaIcon(
                  FontAwesomeIcons.whatsappSquare,
                  color: Colors.green,
                ),
              ),
            ]),
            SizedBox(
              height: 30,
            ),
            Text(
              'Developed By',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 21),
            ),
            SizedBox(
              height: 10,
            ),
            Image.asset(
              'assets/widdev_logo.png',
              fit: BoxFit.scaleDown,
              width: 140,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Widdev (PVT) LTD',
              style: TextStyle(
                  color: Color(0xff6e6262),
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            GestureDetector(
                onTap: () async {
                  await launch('https://www.widdev.com',
                      forceSafariVC: false, forceWebView: false);
                },
                child: Text(
                  'www.widdev.com',
                  style: TextStyle(
                      color: Colors.green,
                      decoration: TextDecoration.underline),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    await launch('https://www.facebook.com/widdev',
                        forceSafariVC: false, forceWebView: false);
                  },
                  child: FaIcon(
                    FontAwesomeIcons.facebookSquare,
                    color: Colors.lightBlue,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    await launch('https://www.linkedin.com/company/widdev',
                        forceSafariVC: false, forceWebView: false);
                  },
                  child: FaIcon(
                    FontAwesomeIcons.linkedin,
                    color: Color(0xff0077b5),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    await launch('whatsapp://send?phone=+94715316516',
                        forceSafariVC: false, forceWebView: false);
                  },
                  child: FaIcon(
                    FontAwesomeIcons.whatsappSquare,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                GestureDetector(
                  onTap: () async {
                    await launch('mailto:info@widdev.com',
                        forceSafariVC: false, forceWebView: false);
                  },
                  child: Icon(
                    Icons.email,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
