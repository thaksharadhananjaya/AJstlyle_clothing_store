import 'dart:convert';

import 'package:ajstyle/models/productModel.dart';
import 'package:http/http.dart' as http;

import '../config.dart';

class ProductRepo {
  Future<List<Product>> getProduct(
      bool isSale, int page, int categoryID, String search) async {
    print(search);
    try {
      String path = "$url/getProduct.php";

      var response = await http.post(Uri.parse(path), body: {
        "key": accessKey,
        "page": "$page",
      });
      if (search != null) {
        response = await http.post(Uri.parse(path),
            body: {"key": accessKey, "page": "$page", "search": "$search"});
      }
      if (categoryID != 0) {
        response = await http.post(Uri.parse(path), body: {
          "key": accessKey,
          "page": "$page",
          "search": "$search",
          "category": "$categoryID"
        });
      }
      if (isSale) {
        response = await http.post(Uri.parse(path),
            body: {"key": accessKey, "page": "$page", "isSale": "1"});
      }
      List<dynamic> list = jsonDecode(response.body);
      if (isSale) print(list);
      List<Product> postList = [];
      list.map((data) => postList.add(Product.fromJson(data))).toList();

      return postList.length == 0 ? null : postList;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
