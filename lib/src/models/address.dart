// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {

  String? id;
  String? addressStreet;
  String? externalNumber;
  String? internalNumber;
  String? neighborhood;
  String? state;
  String? country;
  String? postalCode;
  double? lat;
  double? lng;
  String? idUser;


  Address({
    this.id,
    this.addressStreet,
    this.externalNumber,
    this.internalNumber,
    this.neighborhood,
    this.state,
    this.country,
    this.postalCode,
    this.lat,
    this.lng,
    this.idUser,
  });



  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    addressStreet: json["address"],
    externalNumber: json["external_number"],
    internalNumber: json["internal_number"],
    neighborhood: json["neighborhood"],
    state: json["state"],
    country: json["country"],
    postalCode: json["postal_code"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    idUser: json["id_user"],
  );

  static List<Address> fromJsonList(List<dynamic> jsonList) {
    List<Address> toList = [];

    jsonList.forEach((item) {
      Address address = Address.fromJson(item);
      toList.add(address);
    });

    return toList;
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "address_street": addressStreet,
    "external_number": externalNumber,
    "internal_number": internalNumber,
    "neighborhood": neighborhood,
    "state": state,
    "country": country,
    "postal_code": postalCode,
    "lat": lat,
    "lng": lng,
    "id_user": idUser,
  };
}
