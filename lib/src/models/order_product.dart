
import 'dart:convert';

import 'package:tag_temporal_app/src/models/product.dart';
import 'package:tag_temporal_app/src/models/user.dart';

import 'address.dart';

OrderProduct orderFromJson(String str) => OrderProduct.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());
String productToJson(Product data) => json.encode(data.toJson());
String orderToJson(OrderProduct data) => json.encode(data.toJson());

class OrderProduct {

  String? idOrder;
  String? idResident;
  String? idVisitor;
  String? idAddress;
  String? status;
  String? status_product;
  double? lat;
  double? lng;
  int? timestamp;

  Product? product;
  User? resident;
  User? visitor;
  Address? address;

  OrderProduct({
    this.idOrder,
    this.idResident,
    this.idVisitor,
    this.idAddress,
    this.status,
    this.status_product,
    this.lat,
    this.lng,
    this.timestamp,
    this.address,
    this.resident,
    this.visitor,
    this.product
  });



  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
    idOrder: json["id_order"],
    idResident: json["id_resident"],
    idVisitor: json["id_visitor"],
    idAddress: json["id_address"],
    status: json["status_order"],
    status_product:  json["status_product"],
    lat: json["lat"],
    lng: json["lng"],
    timestamp: json["timestamp"],
    product: json['product'] is String ? productFromJson(json['product']) : json['product'] is Product ? json['product'] : Product.fromJson(json['product'] ?? {}),
    address: json['address'] is String ? addressFromJson(json['address']) : json['address'] is Address ? json['address'] : Address.fromJson(json['address'] ?? {}),
    visitor: json['visitor'] is String ? userFromJson(json['visitor']) : json['visitor'] is User ? json['visitor'] : User.fromJson(json['visitor'] ?? {}),
    resident: json['resident'] is String ? userFromJson(json['resident']) : json['resident'] is User ? json['resident'] : User.fromJson(json['resident'] ?? {})
  );

  static List<OrderProduct> fromJsonList(List<dynamic> jsonList) {
    List<OrderProduct> toList = [];

    jsonList.forEach((item) {
      OrderProduct order = OrderProduct.fromJson(item);
      toList.add(order);
    });

    return toList;
  }
  Map<String, dynamic> toJson() => {
    "id_order": idOrder,
    "id_resident": idResident,
    "id_visitor": idVisitor,
    "id_address": idAddress,
    "status_order": status,
    "status_product": status_product,
    "lat": lat,
    "lng": lng,
    "timestamp": timestamp,
    "product": product is String ? product :  productToJson(product!),
    "resident": resident is String ? resident : userToJson(resident!),
    "visitor": visitor is String ? visitor : userToJson(visitor!),
    "address": address is String ? address : addressToJson(address!),
  };
}
