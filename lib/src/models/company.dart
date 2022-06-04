// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

Company companyFromJson(String str) => Company.fromJson(json.decode(str));

String companyToJson(Company data) => json.encode(data.toJson());

class Company {

  String? id;
  String? email;
  String? name;
  String? idname;
  String? phone;
  String? imagePath;
  String? route;

  Company({
    this.id,
    this.email,
    this.name,
    this.idname,
    this.phone,
    this.imagePath,
    this.route,
  });



  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    idname: json["idname"],
    phone: json["phone"],
    imagePath: json["image_path"],
    route: json["route"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "idname": idname,
    "phone": phone,
    "image_path": imagePath,
    "route": route,
  };
}
