import 'package:ajstyle/dashboad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'signIn.dart';

class Pofile extends StatefulWidget {
  Pofile({Key key}) : super(key: key);

  @override
  _PofileState createState() => _PofileState();
}

class _PofileState extends State<Pofile> {
  String user, pass, name;
  @override
  void initState() {
    super.initState();
    isLoging();
  }

  @override
  Widget build(BuildContext context) {
 
    return FutureBuilder(
        future: isLoging(),
        builder: (context, snapshot) {
          
          if (snapshot.hasData && snapshot.data.length==8) {
            
            return Dashboad(
              user: int.parse(snapshot.data['user']),
              email: snapshot.data['email'],
              pass: snapshot.data['pass'],
              name: snapshot.data['name'],
              city:  snapshot.data['city'],
              district:  snapshot.data['district'],
              address:  snapshot.data['address'],
              mobile: snapshot.data['mobile'],
            );
          } else {
            return SignIn();
          }
        });
    /*if (user == null || pass == null || name == null) {
      return SignIn();
    } else {
      return Dashboad(
        user: user,
        pass: pass,
        name: name,
      );
    }*/
  }

  Future isLoging() async {
    final storage = new FlutterSecureStorage();
    return storage.readAll();
  }
}
