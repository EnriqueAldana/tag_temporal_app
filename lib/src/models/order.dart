
import 'dart:convert';

import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/models/user.dart';

import 'address.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

String orderToJson(Order data) => json.encode(data.toJson());

class Order {

  String? id;
  String? idResident;
  String? idVisitor;
  String? idAddress;
  String? status;
  double? lat;
  double? lng;
  int? timestamp;
  List<Product>? products= [];

  User? resident;
  User? visitor;
  Address? address;

  Order({
    this.id,
    this.idResident,
    this.idVisitor,
    this.idAddress,
    this.status,
    this.lat,
    this.lng,
    this.timestamp,
    this.products,
    this.address,
    this.resident,
    this.visitor
  });



  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    idResident: json["id_resident"],
    idVisitor: json["id_visitor"],
    idAddress: json["id_address"],
    status: json["status"],
    products: json["products"] != null ? List<Product>.from(json["products"].map((model) => model is Product ? model : Product.fromJson(model)))  : [],
    lat: json["lat"],
    lng: json["lng"],
    timestamp: json["timestamp"],
    resident: json['resident'] is String ? userFromJson(json['resident']) : json['resident'] is User ? json['resident'] : User.fromJson(json['resident'] ?? {}),
    visitor: json['visitor'] is String ? userFromJson(json['visitor']) : json['visitor'] is User ? json['visitor'] : User.fromJson(json['visitor'] ?? {}),
    address: json['address'] is String ? addressFromJson(json['address']) : json['address'] is Address ? json['address'] : Address.fromJson(json['address'] ?? {}),

  );

  static List<Order> fromJsonList(List<dynamic> jsonList) {
    List<Order> toList = [];

    jsonList.forEach((item) {
      Order order = Order.fromJson(item);
      toList.add(order);
    });

    return toList;
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "id_resident": idResident,
    "id_visitor": idVisitor,
    "id_address": idAddress,
    "status": status,
    "lat": lat,
    "lng": lng,
    "timestamp": timestamp,
    "products": products,
    "resident": resident,
    "visitor": visitor,
    "address": address,
  };
}
