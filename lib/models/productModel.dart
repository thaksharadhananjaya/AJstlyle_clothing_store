class Product {
  int productID;
  String name;
  String price;
  String salePrice;
  String discription;
  String image;

  Product({
    this.productID,
    this.price,
    this.name,
    this.discription,
    this.image,
    this.salePrice,
  });

  Product.fromJson(Map<String, dynamic> json) {
    productID = int.parse(json['productID']);
    salePrice = json['salePrice'];
    discription = json['discription'];
    price = json['price'];
    name = json['name'];
    image = json['image'];
  }
}
