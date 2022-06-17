// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';
import 'package:tag_temporal_app/src/models/rol.dart';
User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String? id;
    String? email;
    String? name;
    String? lastname;
    String? lastname2;
    String? phone;
    dynamic? imagePath;
    String? password;
    String? sessionToken;
    List<Rol>? roles= [];

    User({
        this.id,
        this.email,
        this.name,
        this.lastname,
        this.lastname2,
        this.phone,
        this.imagePath,
        this.password,
        this.sessionToken,
        this.roles,

    });

    

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        lastname: json["lastname"],
        lastname2: json["lastname2"],
        phone: json["phone"],
        imagePath: json["image_path"],
        password: json["password"],
        sessionToken: json["session_token"],
        roles: json["roles"] == null ? [] : List<Rol>.from(json["roles"].map((model)=> Rol.fromJson(model))),
    );

    static List<User> fromJsonList(List<dynamic> jsonList) {
        List<User> toList = [];

        jsonList.forEach((item) {
            User user = User.fromJson(item);
            toList.add(user);
        });

        return toList;
    }
    Map<String, dynamic> toJson() => {
        "id" : id,
        "email": email,
        "name": name,
        "lastname": lastname,
        "lastname2": lastname2,
        "phone": phone,
        "image_path": imagePath,
        "password": password,
        "session_token": sessionToken,
        "roles": roles,
    };
}