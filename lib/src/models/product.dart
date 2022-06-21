import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {

  String? id;
  String? name;
  String? description;
  String? image1;
  String? image2;
  String? image3;
  String? idCategory;
  double? price;
  int? quantity;
  int? started_date;
  int? ended_date;
  int? delivery_time_hours;

  Product({
    this.id,
    this.name,
    this.description,
    this.image1,
    this.image2,
    this.image3,
    this.idCategory,
    this.price,
    this.quantity,
    this.started_date,
    this.ended_date,
    this.delivery_time_hours
  });



  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    image1: json["image1"],
    image2: json["image2"],
    image3: json["image3"],
    idCategory: json["id_category"],
    price: json["price"].toDouble(),
    quantity: json["quantity"],
    started_date: json["startde_date"],
    ended_date: json["ended_date"],
      delivery_time_hours: json["delivery_time_hours"]
  );

  static List<Product> fromJsonList(List<dynamic> jsonList) {
    List<Product> toList = [];

    jsonList.forEach((item) {
      Product product = Product.fromJson(item);
      toList.add(product);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "image1": image1,
    "image2": image2,
    "image3": image3,
    "id_category": idCategory,
    "price": price,
    "quantity": quantity,
    "started_date": started_date,
    "ended_date": ended_date,
    "delivery_time_hours" : delivery_time_hours
  };
}
